# Load direnv if a shell is opened directly at a location where there is a .envrc file
if [[ -f .envrc ]] && command -v direnv >/dev/null 2>&1; then
  direnv reload
fi
