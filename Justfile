default:
  just --list

import 'private_dot_config/brew/Justfile'
import 'private_dot_config/git/Justfile'
import 'private_dot_config/mise/Justfile'
import 'private_dot_config/nix/Justfile'
import 'private_dot_config/nvim/Justfile'
import 'private_dot_config/private_karabiner/Justfile'
import 'private_dot_config/yazi/Justfile'
import 'Justfile.alfred.just'
import 'Justfile.ci.just'
import 'dot_vscode/Justfile'

# Chezmoi diff
[group('chezmoi')]
diff:
  just vscode-extensions-pretty
  chezmoi diff

# Reverse Chezmoi diff (= what needs to moved to chemzmoi)
[group('chezmoi')]
diff-reverse:
  just vscode-extensions-pretty
  chezmoi diff --reverse

# Chezmoi apply
[group('chezmoi')]
apply:
  chezmoi apply --interactive

# Chezmoi apply without rendering 1Password-backed templates
[group('chezmoi')]
apply-public:
  ./scripts/apply_public.sh

# Apply only modified files with chezmoi
[group('chezmoi')]
apply-modified:
  git status --porcelain | awk '{print $2}' | \
    xargs -r chezmoi apply --interactive --source-path --

# Custom apply reverse: Apply all changes from the home directory to chezmoi
[group('chezmoi')]
apply-reverse:
  chezmoi status --path-style absolute | grep '/Users' | awk '{$1=""; sub(/^ /, ""); print}' | xargs -I {} chezmoi add --prompt "{}"

# Chezmoi status
[group('chezmoi')]
status:
  chezmoi status

# Check if there are outdated repositories in repos.txt
repos-check:
  GITHUB_TOKEN="$(gh auth token)" uv run ./scripts/check_repos_graphql.py repos.txt repo_activity.csv --threshold-days 365 --batch-size 50
