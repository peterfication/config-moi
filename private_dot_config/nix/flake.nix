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
    localConfig = import ./local.nix;
    systemDefaults = import ./systemDefaults.nix;
    systemPackages = import ./systemPackages.nix;
    configuration = { pkgs, ... }: {
      environment.systemPackages = systemPackages pkgs;

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

        PG16_BIN = "${pkgs.postgresql_16}/bin";
        PG17_BIN = "${pkgs.postgresql_17}/bin";
        RUBY_PG16_FLAGS = "--with-pg-include=${pkgs.postgresql_16.dev}/include --with-pg-lib=${pkgs.postgresql_16.lib}/lib";
        RUBY_PG17_FLAGS = "--with-pg-include=${pkgs.postgresql_17.dev}/include --with-pg-lib=${pkgs.postgresql_17.lib}/lib";
      };

      programs.zsh.enableCompletion = false;
      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      nix.enable = false;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Enable touch ID authentication for sudo.
      security.pam.services.sudo_local.touchIdAuth = true;

      system.primaryUser = localConfig.systemPrimaryUser;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      system.defaults = systemDefaults;

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
