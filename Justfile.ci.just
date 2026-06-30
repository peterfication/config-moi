# Run all CI tasks
ci: karabiner-ci ci-sh ci-json-check ci-toml-check ci-lua-format

ci-sh: ci-shell-format ci-shellcheck

# Check shell scripts
ci-shellcheck:
  shellcheck scripts/*.sh private_dot_local/bin/executable_* private_dot_config/*/executable_*.sh

# Check formatting of Shell scripts
ci-shell-format:
  shfmt -w scripts/*.sh private_dot_local/bin/executable_* private_dot_config/*/executable_*.sh

# Check JSON files
ci-json-check:
  find . \
    -name '*.json' \
    -not -name '*.tmpl' \
    -not -name 'symlink_*' \
    -not -path './private_dot_config/zed/private_settings.json' \
    -exec sh -c 'status=0; for file do error="$(jq empty "$file" 2>&1 >/dev/null)" || { printf "invalid JSON: %s\n%s\n" "$file" "$error" >&2; status=1; }; done; exit "$status"' sh {} +

# Check TOML files
ci-toml-check:
  taplo check '**/*.toml'

# Format lua files
ci-lua-format:
  stylua private_dot_config/nvim private_dot_config/hammerspoon private_dot_config/yazi
