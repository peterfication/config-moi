export ZCOMET_DIR=${XDG_CONFIG_HOME:-${HOME}}/.zcomet
# Clone zcomet if necessary
if [[ ! -f ${ZCOMET_DIR}/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZCOMET_DIR}/bin
fi

source ${ZCOMET_DIR}/bin/zcomet.zsh

source ~/.config/zsh/00_path.zsh

zcomet load ohmyzsh plugins/direnv
zcomet load ohmyzsh plugins/dotenv
zcomet load ohmyzsh plugins/fzf
zcomet load ohmyzsh plugins/git-extras
zcomet load ohmyzsh plugins/uv
zcomet load ohmyzsh plugins/zoxide

zcomet load Aloxaf/fzf-tab

source ~/.config/zsh/99_starship.zsh

# It is good to load these popular plugins last, and in this order:
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions

# Run compinit and compile its cache
zcomet compinit
