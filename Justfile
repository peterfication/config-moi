default:
  just --list

# Chezmoi diff
diff:
  just vscode-extensions-pretty
  chezmoi diff

# Reverse Chezmoi diff (= what needs to moved to chemzmoi)
diff-reverse:
  just vscode-extensions-pretty
  chezmoi diff --reverse

# Chezmoi apply
apply:
  chezmoi apply --interactive

# Custom apply reverse: Apply all changes from the home directory to chezmoi
apply-reverse:
  chezmoi status --path-style absolute | grep '/Users' | awk '{print $2}' | xargs -I {} chezmoi add --prompt {}

# Chezmoi status
status:
  chezmoi status

# Re-add the VSCode extensions.json (See script for more details)
vscode-extensions-add:
  (cd dot_vscode/extensions && ./extensions_add.sh)

# Apply the changes to VSCode extensions.json
vscode-extensions-apply:
  chezmoi apply ~/.vscode/extensions/extensions.json

# Format the VSCode extensions.json file so chezmoi diff is more meaningfull
vscode-extensions-pretty:
  prettier -w ~/.vscode/extensions/extensions.json

# Re-add yazi package.toml file to chezmoi.
yazi-add-package-toml:
   chezmoi add ~/.config/yazi/package.toml
