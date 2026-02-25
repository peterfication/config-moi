# List packages installed in system profile. To search by name, run:
# $ nix search nixpkgs <query>
pkgs: with pkgs; [
  icu
  openssl

  # See ~/.config/zsh/tools/postgresql.zsh for how to use these.
  postgresql_16
  postgresql_17

  age # https://github.com/FiloSottile/age
  chezmoi # https://www.chezmoi.io
  delta # https://github.com/dandavison/delta
  direnv # https://github.com/direnv/direnv
  duckdb # https://github.com/duckdb/duckdb
  eza # https://github.com/eza-community/eza
  fd # https://github.com/sharkdp/fd
  fzf # https://github.com/junegunn/fzf
  gh # https://cli.github.com/
  iterm2 # https://github.com/gnachman/iTerm2
  jjui # https://github.com/idursun/jjui
  jq # https://github.com/jqlang/jq
  jujutsu # https://jj-vcs.github.io/jj/latest/
  just # https://github.com/casey/just
  lazygit # https://github.com/jesseduffield/lazygit
  lefthook # https://github.com/evilmartians/lefthook
  mise # https://github.com/jdx/mise
  neovim # https://github.com/neovim/neovim
  peco # https://github.com/peco/peco interactive grep
  rclone # https://rclone.org/
  ripgrep # https://github.com/BurntSushi/ripgrep
  sshfs # https://github.com/libfuse/sshfs
  sshs # https://github.com/quantumsheep/sshs
  starship # https://github.com/starship/starship
  tmux
  uv # https://github.com/astral-sh/uv
  vim
  yazi # https://github.com/sxyazi/yazi
  zoxide # https://github.com/ajeetdsouza/zoxide

  # Container tooling
  dive # https://github.com/wagoodman/dive (Docker image inspection)
  podman # https://github.com/containers/podman
  podman-tui # https://github.com/containers/podman-tui
]
