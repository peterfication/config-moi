#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${BREWFILE:-"$SCRIPT_DIR/Brewfile"}"
OUTPUT_PATH="${1:-"$SCRIPT_DIR/brew-packages.json"}"

for command_name in brew jq; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'Error: required command not found: %s\n' "$command_name" >&2
    exit 1
  fi
done

if [[ ! -r "$BREWFILE" ]]; then
  printf 'Error: Brewfile not readable: %s\n' "$BREWFILE" >&2
  exit 1
fi

declarations_json="$(
  sed -En "s/^[[:space:]]*(brew|cask)[[:space:]]+['\"]([^'\"]+)['\"].*/\\1	\\2/p" "$BREWFILE" |
    jq -Rn '
      [
        inputs
        | split("\t")
        | {
            declared_type: (if .[0] == "brew" then "formula" else "cask" end),
            declared_name: .[1],
            name: (.[1] | split("/") | last)
          }
      ]
    '
)"

installed_json="$(brew list --versions --json)"

json="$(
  jq -n \
    --argjson declarations "$declarations_json" \
    --argjson installed "$installed_json" '
      def installed_packages:
        (
          $installed.formulae[]
          | {name, type: "formula", versions}
        ),
        (
          $installed.casks[]
          | {name: .token, type: "cask", versions}
        );

      [installed_packages] as $packages
      | [
          $declarations[]
          | . as $declaration
          | (
              first(
                $packages[]
                | select(
                    .name == $declaration.name
                    and .type == $declaration.declared_type
                  )
              )
              //
              first(
                $packages[]
                | select(.name == $declaration.name)
              )
            ) as $package
          | select($package != null)
          | $package
        ]
      | unique_by([.type, .name])
      | sort_by(.name, .type)
    '
)"

missing="$(
  jq -nr \
    --argjson declarations "$declarations_json" \
    --argjson installed "$installed_json" '
      [
        $installed.formulae[].name,
        $installed.casks[].token
      ] as $installed_names
      | $declarations[]
      | . as $declaration
      | select(($installed_names | index($declaration.name)) == null)
      | "\(.declared_type) \(.declared_name)"
    '
)"

if [[ -n "$missing" ]]; then
  printf 'Warning: Brewfile entries not installed:\n%s\n' "$missing" >&2
fi

json="$(printf '%s\n' "$json" | jq -S .)"

if [[ "$OUTPUT_PATH" == "-" ]]; then
  printf '%s\n' "$json"
else
  printf '%s\n' "$json" > "$OUTPUT_PATH"
  printf 'Wrote Homebrew package versions to %s\n' "$OUTPUT_PATH"
fi
