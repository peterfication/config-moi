# Use homebrew curl
export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"

# Use homebrew gnu grep
export PATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$PATH"

if which sed | grep -q '/usr/bin/sed'; then
  echo "sed is still the old version from Mac OS X"
  echo "Install a recent one with:"
  echo "  "
  echo "  brew install gnu-sed"
  echo "  sudo ln -s $HOMEBREW_PREFIX/local/bin/gsed $HOMEBREW_PREFIX/bin/sed"
  echo "  "
fi

if zsh -c "export PATH=\"$HOMEBREW_PREFIX/grep/libexec/gnubin:$PATH\" && which grep" | grep -q '/usr/bin/grep'; then
  echo "grep is still the old version from Mac OS X"
  echo "Install a recent one with:"
  echo "  "
  echo "  brew install grep"
  echo "  "
fi
