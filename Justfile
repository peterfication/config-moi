default:
  just --list

# Chezmoi diff
diff:
  just vscode-extensions-pretty
  chezmoi diff

# Chezmoi apply
apply:
  chezmoi apply

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
