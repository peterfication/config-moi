# /// script
# dependencies = [
#   "requests",
# ]
# ///
# -*- coding: utf-8 -*-
"""
Reads a text file with one GitHub repo URL per line and writes a CSV report:
- archived?
- default branch name
- last commit date on the default branch (fallback to pushedAt)
- days since last activity
- stale flag (archived OR older than threshold)

Uses GitHub GraphQL with batching (aliases) for speed.

Usage:
  python check_repos_graphql.py repos.txt repo_activity.csv --threshold-days 365 --batch-size 50

Environment:
  GITHUB_TOKEN  (required; fine-grained or classic; needs read access to the repos)
"""

import argparse
import csv
import json
import os
import re
import sys
import time
from datetime import datetime, timezone
from typing import List, Tuple, Dict, Any, Optional

import requests

GQL_ENDPOINT = "https://api.github.com/graphql"
DEFAULT_THRESHOLD_DAYS = 365
DEFAULT_BATCH_SIZE = 50
REQUEST_TIMEOUT = 40
RETRY_STATUSES = {429, 500, 502, 503, 504}


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser()
    p.add_argument("input", help="Path to repos.txt (one URL per line)")
    p.add_argument("output", help="Path to output CSV")
    p.add_argument("--threshold-days", type=int, default=DEFAULT_THRESHOLD_DAYS,
                   help=f"Days since last activity to mark as stale (default {DEFAULT_THRESHOLD_DAYS})")
    p.add_argument("--batch-size", type=int, default=DEFAULT_BATCH_SIZE,
                   help=f"How many repos per GraphQL request (default {DEFAULT_BATCH_SIZE})")
    return p.parse_args()


def gh_session() -> requests.Session:
    token = os.getenv("GITHUB_TOKEN")
    if not token:
        print("ERROR: GITHUB_TOKEN environment variable is not set.", file=sys.stderr)
        sys.exit(2)
    s = requests.Session()
    s.headers.update({
        "Authorization": f"Bearer {token}",
        "Accept": "application/json",
        "User-Agent": "repo-activity-checker-graphql"
    })
    return s


def parse_owner_repo(url: str) -> Tuple[Optional[str], Optional[str]]:
    """
    Accepts:
      https://github.com/owner/repo
      git@github.com:owner/repo.git
      https://github.com/owner/repo.git
    """
    url = url.strip()
    if not url or url.startswith("#"):
        return None, None
    m = re.search(r"github\.com[:/](?P<owner>[^/]+)/(?P<repo>[^/#\s\.]+)", url)
    if not m:
        return None, None
    return m["owner"], m["repo"]


def iso_to_days_ago(iso: str) -> Optional[int]:
    try:
        dt = datetime.fromisoformat(iso.replace("Z", "+00:00")).astimezone(timezone.utc)
        return (datetime.now(timezone.utc) - dt).days
    except Exception:
        return None


def chunked(seq: List[Any], n: int) -> List[List[Any]]:
    return [seq[i:i+n] for i in range(0, len(seq), n)]


def build_query(batch: List[Tuple[str, str, str]]) -> str:
    """
    Build a single GraphQL query using aliases.
    Each item in batch: (alias, owner, repo)
    We grab:
      - isArchived
      - defaultBranchRef { name, target { ... on Commit { committedDate } } }
      - pushedAt (fallback if no default branch/commit)
    Also include rateLimit for visibility.
    """
    parts = ["query {"]
    parts.append("  rateLimit { remaining cost resetAt }")
    for alias, owner, repo in batch:
        # Escape quotes in owner/repo just in case
        o = json.dumps(owner)
        r = json.dumps(repo)
        parts.append(f"""  {alias}: repository(owner: {o}, name: {r}) {{
    isArchived
    pushedAt
    defaultBranchRef {{
      name
      target {{
        __typename
        ... on Commit {{ committedDate }}
      }}
    }}
  }}""")
    parts.append("}")
    return "\n".join(parts)


def backoff_sleep(attempt: int, retry_after: Optional[str] = None):
    if retry_after:
        try:
            delay = float(retry_after)
        except Exception:
            delay = min(2 ** attempt, 30)
    else:
        delay = min(2 ** attempt, 30)
    time.sleep(delay)


def gql_post(sess: requests.Session, query: str, max_retries: int = 5) -> requests.Response:
    payload = {"query": query}
    attempt = 0
    while True:
        r = sess.post(GQL_ENDPOINT, json=payload, timeout=REQUEST_TIMEOUT)
        if r.status_code in RETRY_STATUSES or (r.status_code == 403 and "rate limit" in r.text.lower()):
            retry_after = r.headers.get("Retry-After")
            backoff_sleep(attempt, retry_after)
            attempt += 1
            if attempt > max_retries:
                return r
            continue
        return r


def process_batch(sess: requests.Session, items: List[Tuple[str, str, str]]) -> Tuple[List[Dict[str, Any]], bool]:
    """
    items: list of (alias, owner, repo)
    returns: (rows, had_error)
    """
    query = build_query(items)
    resp = gql_post(sess, query)
    rows = []
    had_error = False

    if resp.status_code != 200:
        # Whole-batch failure
        for alias, owner, repo in items:
            rows.append({
                "url": f"https://github.com/{owner}/{repo}",
                "archived": "",
                "default_branch": "",
                "last_timestamp_iso": "",
                "days_since_last_activity": "",
                "stale_by_threshold": "",
                "status": f"error_http_{resp.status_code}",
            })
        return rows, True

    data = resp.json()
    # GraphQL-level errors can be per-alias
    gql_errors = { }
    if "errors" in data:
        # Collect errors; not always aliased, but often includes "path"
        for e in data["errors"]:
            path = ".".join(str(p) for p in e.get("path", [])) if e.get("path") else ""
            gql_errors[path] = e.get("message", "GraphQL error")
        had_error = True

    d = data.get("data") or {}
    for alias, owner, repo in items:
        node = d.get(alias)
        url = f"https://github.com/{owner}/{repo}"

        if node is None:
            # Try to find a matching error by alias
            msg = gql_errors.get(alias, "not_found_or_no_access")
            rows.append({
                "url": url,
                "archived": "",
                "default_branch": "",
                "last_timestamp_iso": "",
                "days_since_last_activity": "",
                "stale_by_threshold": "",
                "status": f"error_{msg}",
            })
            continue

        archived = bool(node.get("isArchived", False))
        pushed_at = node.get("pushedAt")
        default_branch = ""
        committed_date = ""
        db = node.get("defaultBranchRef")
        if db:
            default_branch = db.get("name") or ""
            target = db.get("target") or {}
            if target.get("__typename") == "Commit":
                committed_date = target.get("committedDate") or ""

        last_iso = committed_date or pushed_at or ""
        days = iso_to_days_ago(last_iso) if last_iso else None

        rows.append({
            "url": url,
            "archived": archived,
            "default_branch": default_branch,
            "last_timestamp_iso": last_iso,
            "days_since_last_activity": days if days is not None else "",
            "stale_by_threshold": "",  # fill later when we know threshold
            "status": "ok",
        })

    return rows, had_error


def main():
    args = parse_args()
    sess = gh_session()

    # Load URLs
    try:
        with open(args.input, "r", encoding="utf-8") as f:
            urls = [ln.strip() for ln in f if ln.strip()]
    except FileNotFoundError:
        print(f"Input file not found: {args.input}", file=sys.stderr)
        sys.exit(2)

    # Parse to (owner, repo), keep original order; include bad_url entries
    parsed: List[Tuple[str, str, str]] = []
    preliminary_rows: List[Dict[str, Any]] = []
    for u in urls:
        owner, repo = parse_owner_repo(u)
        if not owner:
            preliminary_rows.append({
                "url": u,
                "archived": "",
                "default_branch": "",
                "last_timestamp_iso": "",
                "days_since_last_activity": "",
                "stale_by_threshold": "",
                "status": "bad_url",
            })
        else:
            alias = f"a_{len(parsed)}"  # alias must start with a letter
            parsed.append((alias, owner, repo))

    rows: List[Dict[str, Any]] = []
    had_any_error = False

    for batch in chunked(parsed, args.batch_size):
        batch_rows, had_error = process_batch(sess, batch)
        rows.extend(batch_rows)
        had_any_error = had_any_error or had_error
        time.sleep(0.1)  # gentle pacing

    # Merge preliminary bad_url rows in original order
    all_rows: List[Dict[str, Any]] = []
    pi = 0
    gi = 0
    for u in urls:
        if parse_owner_repo(u)[0] is None:
            all_rows.append(preliminary_rows[pi]); pi += 1
        else:
            all_rows.append(rows[gi]); gi += 1

    # Compute stale_by_threshold
    for r in all_rows:
        if r.get("status") == "ok":
            archived = bool(r.get("archived"))
            days = r.get("days_since_last_activity")
            stale = archived or (isinstance(days, int) and days > args.threshold_days)
            r["stale_by_threshold"] = stale

    # Write CSV
    fieldnames = [
        "url",
        "archived",
        "default_branch",
        "last_timestamp_iso",
        "days_since_last_activity",
        "stale_by_threshold",
        "status",
    ]
    with open(args.output, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        w.writerows(all_rows)

    print(f"Wrote {args.output} with {len(all_rows)} rows.")

    # Helpful non-zero exit if there were request-level errors
    if had_any_error or any(str(r.get("status","")).startswith("error_") for r in all_rows):
        sys.exit(1)


if __name__ == "__main__":
    main()
