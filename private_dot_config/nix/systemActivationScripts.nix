{ pkgs, chezmoiUrl }:
with pkgs; {
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
}
