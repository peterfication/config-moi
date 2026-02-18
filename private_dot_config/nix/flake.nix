{
  description = "My nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    # nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    chezmoiUrl = "https://github.com/peterfication/config-moi.git";
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix search nixpkgs <query>
      environment.systemPackages = with pkgs; [
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
        podman # https://github.com/containers/podman
        podman-tui # https://github.com/containers/podman-tui
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
      ];

      fonts.packages = [
        pkgs.nerd-fonts.fira-code
      ];

      environment.shellAliases = {
        # Run darwin-rebuild from the nix config directory
        nix-rebuild = "(cd ~/.config/nix && just nix-darwin-rebuild)";
        # Run bundle install from the brew config directory
        brew-install = "(cd ~/.config/brew && just brew-install)";
        install-all = "nix-rebuild && brew-install";
        # Open vim with the chezmoi config
        conf = " cd $(chezmoi source-path) && nvim";
      };

      environment.variables = {
        PKG_CONFIG_PATH = "${pkgs.icu.dev}/lib/pkgconfig:${pkgs.openssl.dev}/lib/pkgconfig";
        CFLAGS = "-I${pkgs.icu.dev}/include -I${pkgs.openssl.dev}/include";
        LDFLAGS = "-L${pkgs.icu.dev}/lib -L${pkgs.openssl.dev}/lib";
      };

      programs.zsh.enableCompletion = false;

      nix.enable = false;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Enable touch ID authentication for sudo.
      security.pam.services.sudo_local.touchIdAuth = true;

      system.activationScripts = {
        # See https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/activation-scripts.nix#L154
        # for available activation scripts.
        postActivation = {
          text = ''
            echo ""
            chezmoi_config_file_path="/Users/$(logname)/.config/chezmoi/chezmoi.toml"
            if [ -f "$chezmoi_config_file_path" ]; then
              echo "Found chezmoi config file at $chezmoi_config_file_path"
              echo "Don't init chezmoi again."
              # ${pkgs.chezmoi}/bin/chezmoi apply
            else
              echo "Running chezmoi init ..."
              sudo -u "$(logname)" env HOME="/Users/$(logname)"  ${pkgs.chezmoi}/bin/chezmoi init --apply "${chezmoiUrl}"
              echo "Running chezmoi init done"
            fi
            echo ""
          '';
        };
      };
    };
  in
  {
    # First time run:
    # sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- --flake ~/config/nix#simple switch

    # Following darwin builds:
    # sudo darwin-rebuild switch --flake ~/config/nix#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
