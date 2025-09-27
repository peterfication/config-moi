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

source ~/.config/zsh_new/00_path.zsh
source ~/.config/zsh_new/01_languages.zsh
source ~/.config/zsh_new/02_plugins.zsh
source ~/.config/zsh_new/03_general.zsh
source ~/.config/zsh_new/04_alias.zsh
source ~/.config/zsh_new/10_tools.zsh
source ~/.config/zsh_new/11_macos.zsh
source ~/.config/zsh_new/99_starship.zsh

# It is good to load these popular plugins last, and in this order:
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions

# Run compinit and compile its cache
zcomet compinit
