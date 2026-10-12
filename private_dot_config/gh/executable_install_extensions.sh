#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
manifest="${1:-"$script_dir/extensions.toml"}"

for command_name in gh jq yq; do
	if ! command -v "$command_name" >/dev/null 2>&1; then
		printf 'Error: required command not found: %s\n' "$command_name" >&2
		exit 1
	fi
done

if [[ ! -r "$manifest" ]]; then
	printf 'Error: extension manifest not readable: %s\n' "$manifest" >&2
	exit 1
fi

extensions_tsv="$(
	yq --input-format toml --output-format json '.' "$manifest" |
		jq -er '
      if type != "object" or length == 0
        or any(to_entries[]; (.value | type) != "string" or .value == "")
      then
        error("manifest must map extension repositories to non-empty string refs")
      else
        to_entries
        | sort_by(.key)
        | .[]
        | [.key, .value]
        | @tsv
      end
    '
)"

while IFS=$'\t' read -r repository ref; do
	printf 'Installing %s pinned to %s\n' "$repository" "$ref"
	gh extension install "$repository" --pin "$ref" --force
done <<<"$extensions_tsv"
