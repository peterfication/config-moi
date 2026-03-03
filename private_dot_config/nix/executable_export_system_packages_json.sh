#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_PATH="${1:-"$SCRIPT_DIR/system-packages.json"}"

NIX_EXPR='
let
  flake = builtins.getFlake (toString ./.);
  packages = import ./systemPackages.nix flake.darwinConfigurations.simple.pkgs;
  normalize = pkg:
    let parsed = builtins.parseDrvName pkg.name;
    in {
      name = if pkg ? pname then pkg.pname else parsed.name;
      version = if pkg ? version then pkg.version else parsed.version;
    };
  normalized = builtins.map normalize packages;
  sorted = builtins.sort
    (a: b:
      if a.name == b.name
      then a.version < b.version
      else a.name < b.name)
    normalized;
in
  sorted
'

cd "$SCRIPT_DIR"

json="$(
  nix eval \
    --json \
    --impure \
    --extra-experimental-features "nix-command flakes" \
    --expr "$NIX_EXPR"
)"

if command -v jq >/dev/null 2>&1; then
  json="$(printf '%s\n' "$json" | jq -S .)"
fi

if [[ "$OUTPUT_PATH" == "-" ]]; then
  printf '%s\n' "$json"
else
  printf '%s\n' "$json" > "$OUTPUT_PATH"
  printf 'Wrote system package versions to %s\n' "$OUTPUT_PATH"
fi
