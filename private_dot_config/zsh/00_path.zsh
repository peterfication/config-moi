if [ -e /opt/homebrew/bin/brew ]; then
  # Write homebrew to cache for speed up if it doesn't exist yet
  export HOMEBREW_SHELLENV_CACHE_FILE="$HOME/.cache/homebrew_shellenv.sh"
  if [ ! -e "$HOMEBREW_SHELLENV_CACHE_FILE" ]; then
    /opt/homebrew/bin/brew shellenv > "$HOMEBREW_SHELLENV_CACHE_FILE"
  fi

  source "$HOMEBREW_SHELLENV_CACHE_FILE"
fi
if [ -e /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Nix is loaded via the files /etc/zprofile /etc/zshenv /etc/zshrc
# homebrew is loaded afterwards at the top of this file. This sets homebrew
# before nix in the PATH. Nix should be before homewbrew so I need to add it again.
#
# NOTE: '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' should not be sourced
# because I'm using nix-darwin. I can't source nix-darwin files again, because they are
# protected to be sourced only once. Hence, I need to manually set the PATH.
export PATH="$HOME/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH"

export PATH=$HOME"/.local/bin:$PATH"
