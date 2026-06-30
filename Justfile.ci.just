# Run all CI tasks
ci: ci-sh ci-json-check ci-toml-check ci-lua ci-yaml ci-modules

ci-modules: karabiner-ci nix-ci

# Check JSON files
ci-json-check:
  find . \
    -name '*.json' \
    -not -name '*.tmpl' \
    -not -name 'symlink_*' \
    -not -path './private_dot_config/zed/private_settings.json' \
    -exec sh -c 'status=0; for file do error="$(jq empty "$file" 2>&1 >/dev/null)" || { printf "invalid JSON: %s\n%s\n" "$file" "$error" >&2; status=1; }; done; exit "$status"' sh {} +

ci-lua: ci-lua-format ci-lua-lint

# Format Lua files
ci-lua-format:
  mise exec -- stylua private_dot_config/nvim private_dot_config/hammerspoon private_dot_config/yazi

# Lint Lua files
ci-lua-lint:
  mise exec -- lua-language-server --check=. --checklevel=Warning --check_format=pretty --configpath=.luarc.json --logpath=/tmp/lua-language-server-log --metapath=/tmp/lua-language-server-meta

ci-sh: ci-shell-format ci-shellcheck

# Check shell scripts
ci-shellcheck:
  mise exec -- shellcheck scripts/*.sh private_dot_local/bin/executable_* private_dot_config/*/executable_*.sh

# Check formatting of Shell scripts
ci-shell-format:
  mise exec -- shfmt -w scripts/*.sh private_dot_local/bin/executable_* private_dot_config/*/executable_*.sh

# Check TOML files
ci-toml-check:
  mise exec -- taplo check '**/*.toml'

ci-yaml: ci-yaml-format ci-yaml-lint

# Format YAML files
ci-yaml-format:
  mise exec -- yamlfmt .

# Lint YAML files
ci-yaml-lint:
  mise exec -- yamllint .
