# Run all CI tasks
[group('ci')]
ci: ci-sh ci-json-check ci-toml-check ci-lua ci-yaml ci-modules

[group('ci')]
ci-modules: karabiner-ci nix-ci

# Check JSON files
[group('ci')]
ci-json-check:
  find . \
    -name '*.json' \
    -not -name '*.tmpl' \
    -not -name 'symlink_*' \
    -not -path './private_dot_config/zed/private_settings.json' \
    -exec sh -c 'status=0; for file do error="$(jq empty "$file" 2>&1 >/dev/null)" || { printf "invalid JSON: %s\n%s\n" "$file" "$error" >&2; status=1; }; done; exit "$status"' sh {} +

[group('ci')]
ci-lua: ci-lua-format ci-lua-lint

# Format Lua files
[group('ci')]
ci-lua-format:
  mise exec -- stylua private_dot_config/nvim private_dot_config/hammerspoon private_dot_config/yazi

# Lint Lua files
[group('ci')]
ci-lua-lint:
  mise exec -- lua-language-server --check=. --checklevel=Warning --check_format=pretty --configpath=.luarc.json --logpath=/tmp/lua-language-server-log --metapath=/tmp/lua-language-server-meta

[group('ci')]
ci-sh: ci-shell-format ci-shellcheck

# Check shell scripts
[group('ci')]
ci-shellcheck:
  mise exec -- shellcheck scripts/*.sh private_dot_local/bin/executable_* private_dot_config/*/executable_*.sh

# Check formatting of Shell scripts
[group('ci')]
ci-shell-format:
  mise exec -- shfmt -w scripts/*.sh private_dot_local/bin/executable_* private_dot_config/*/executable_*.sh

# Check TOML files
[group('ci')]
ci-toml-check:
  mise exec -- taplo check '**/*.toml'

[group('ci')]
ci-yaml: ci-yaml-format ci-yaml-lint

# Format YAML files
[group('ci')]
ci-yaml-format:
  mise exec -- yamlfmt .

# Lint YAML files
[group('ci')]
ci-yaml-lint:
  mise exec -- yamllint .
