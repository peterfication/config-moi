export XDG_CONFIG_HOME="$HOME/.config"

export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"
mkdir -p "$ZSH_CACHE_DIR/completions"

export ZCOMET_DIR=${XDG_CONFIG_HOME:-${HOME}}/.zcomet
# Clone zcomet if necessary
if [[ ! -f ${ZCOMET_DIR}/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZCOMET_DIR}/bin
fi

source ${ZCOMET_DIR}/bin/zcomet.zsh

source ~/.config/zsh/00_path.zsh
source ~/.config/zsh/01_languages.zsh
source ~/.config/zsh/02_plugins.zsh
source ~/.config/zsh/03_general.zsh
source ~/.config/zsh/04_alias.zsh
source ~/.config/zsh/05_theme.zsh
source ~/.config/zsh/10_tools.zsh
source ~/.config/zsh/11_macos.zsh
source ~/.config/zsh/99_starship.zsh

# Source a local file if it exists
if [[ -f ~/.config/zsh/local.zsh ]]; then
  source ~/.config/zsh/local.zsh
fi

# It is good to load these popular plugins last, and in this order:
zcomet load zsh-users/zsh-syntax-highlighting
# zcomet load zsh-users/zsh-autosuggestions

# Disable compaudit security warning by default
zstyle ':zcomet:compinit' arguments -C
# Run compinit and compile its cache
zcomet compinit
