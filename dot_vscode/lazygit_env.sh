export EDITOR="code --wait"
export GIT_EDITOR="code --wait"

if [ -e /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
