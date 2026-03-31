# List packages installed in system profile. To search by name, run:
# $ nix search nixpkgs <query>
{ pkgs, pkgsUnstable }:
with pkgs; [
  icu
  openssl

  # See ~/.config/zsh/tools/postgresql.zsh for how to use these.
  postgresql_16
  postgresql_17
  redis

  age # https://github.com/FiloSottile/age
  bitwarden-cli # https://github.com/bitwarden/clients
  chezmoi # https://www.chezmoi.io
  delta # https://github.com/dandavison/delta
  direnv # https://github.com/direnv/direnv
  duckdb # https://github.com/duckdb/duckdb
  eza # https://github.com/eza-community/eza
  fd # https://github.com/sharkdp/fd
  fzf # https://github.com/junegunn/fzf
  pkgsUnstable.gh # https://cli.github.com/
  pkgsUnstable.ghostty-bin # https://github.com/ghostty-org/ghostty
  iterm2 # https://github.com/gnachman/iTerm2
  jjui # https://github.com/idursun/jjui
  jq # https://github.com/jqlang/jq
  jujutsu # https://jj-vcs.github.io/jj/latest/
  just # https://github.com/casey/just
  pkgsUnstable.lazygit # https://github.com/jesseduffield/lazygit
  pkgsUnstable.lefthook # https://github.com/evilmartians/lefthook
  lnav # https://github.com/tstack/lnav
  mise # https://github.com/jdx/mise
  _1password-cli # https://developer.1password.com/docs/cli/
  pkgsUnstable.neovim # https://github.com/neovim/neovim
  peco # https://github.com/peco/peco interactive grep
  rclone # https://rclone.org/
  restic # https://github.com/restic/restic
  ripgrep # https://github.com/BurntSushi/ripgrep
  pkgsUnstable.sshfs # https://github.com/libfuse/sshfs
  sshs # https://github.com/quantumsheep/sshs
  starship # https://github.com/starship/starship
  tmux
  pkgsUnstable.uv # https://github.com/astral-sh/uv
  vim
  pkgsUnstable.yazi # https://github.com/sxyazi/yazi
  zoxide # https://github.com/ajeetdsouza/zoxide

  # Container tooling
  dive # https://github.com/wagoodman/dive (Docker image inspection)
  podman # https://github.com/containers/podman
  podman-compose # https://github.com/containers/podman-compose
  podman-tui # https://github.com/containers/podman-tui
]
