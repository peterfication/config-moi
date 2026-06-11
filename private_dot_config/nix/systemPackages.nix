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

  pkgsUnstable.aerospace # https://github.com/nikitabobko/AeroSpace
  age # https://github.com/FiloSottile/age
  arp-scan # https://github.com/royhills/arp-scan
  bat # https://github.com/sharkdp/bat
  bitwarden-cli # https://github.com/bitwarden/clients
  chezmoi # https://www.chezmoi.io
  pkgsUnstable.colima # https://github.com/abiosoft/colima
  curl
  docker
  delta # https://github.com/dandavison/delta
  direnv # https://github.com/direnv/direnv
  duckdb # https://github.com/duckdb/duckdb
  eza # https://github.com/eza-community/eza
  fd # https://github.com/sharkdp/fd
  ffmpeg # https://ffmpeg.org/
  fpp # https://github.com/facebook/pathpicker
  fzf # https://github.com/junegunn/fzf
  pkgsUnstable.gh # https://cli.github.com/
  pkgsUnstable.ghostty-bin # https://github.com/ghostty-org/ghostty
  imagemagick # https://github.com/imagemagick/imagemagick
  iterm2 # https://github.com/gnachman/iTerm2
  jjui # https://github.com/idursun/jjui
  jq # https://github.com/jqlang/jq
  jujutsu # https://jj-vcs.github.io/jj/latest/
  just # https://github.com/casey/just
  pkgsUnstable.lazygit # https://github.com/jesseduffield/lazygit
  pkgsUnstable.lazydocker # https://github.com/jesseduffield/lazydocker
  pkgsUnstable.lefthook # https://github.com/evilmartians/lefthook
  lnav # https://github.com/tstack/lnav
  pkgsUnstable.mise # https://github.com/jdx/mise
  ncftp # https://www.ncftp.com/ncftp/
  natscli # https://nats.io/
  nats-server # https://nats.io/
  _1password-cli # https://developer.1password.com/docs/cli/
  _1password-gui
  pkgsUnstable.neovim # https://github.com/neovim/neovim
  peco # https://github.com/peco/peco interactive grep
  rclone # https://rclone.org/
  restic # https://github.com/restic/restic
  ripgrep # https://github.com/BurntSushi/ripgrep
  samba # https://gitlab.com/samba-team/samba
  # pkgsUnstable.sshfs # https://github.com/libfuse/sshfs => Brewfile fuse-t
  sshs # https://github.com/quantumsheep/sshs
  starship # https://github.com/starship/starship
  tmux
  extract_url # https://www.memoryhole.net/~kyle/extract_url/
  ueberzugpp # https://github.com/jstkdng/ueberzugpp
  pkgsUnstable.uv # https://github.com/astral-sh/uv
  vim
  pkgsUnstable.yazi # https://github.com/sxyazi/yazi
  watch
  pkgsUnstable.whosthere # https://github.com/ramonvermeulen/whosthere
  wireshark # https://www.wireshark.org/
  zoxide # https://github.com/ajeetdsouza/zoxide

  # Container tooling
  dive # https://github.com/wagoodman/dive (Docker image inspection)
  podman # https://github.com/containers/podman
  podman-compose # https://github.com/containers/podman-compose
  podman-tui # https://github.com/containers/podman-tui
]
