#!/usr/bin/env bash
set -euo pipefail

managed_paths_file="$(mktemp)"
secret_paths_file="$(mktemp)"
apply_paths_file="$(mktemp)"
trap 'rm -f "${managed_paths_file}" "${secret_paths_file}" "${apply_paths_file}"' EXIT

chezmoi managed --source-path --path-style=source-relative --include=files,symlinks \
  | sort > "${managed_paths_file}"
rg -l -g '*.tmpl' -F 'onepasswordRead "' . \
  | sed 's#^\./##' \
  | sort > "${secret_paths_file}"
comm -23 "${managed_paths_file}" "${secret_paths_file}" > "${apply_paths_file}"

if [[ -s "${apply_paths_file}" ]]; then
  mapfile -t apply_paths < "${apply_paths_file}"
  chezmoi apply --interactive --source-path -- "${apply_paths[@]}"
fi
