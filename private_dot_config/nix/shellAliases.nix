{
  # Run darwin-rebuild from the nix config directory
  nix-rebuild = "(cd ~/.config/nix && just nix-darwin-rebuild)";
  # Run bundle install from the brew config directory
  brew-install = "(cd ~/.config/brew && just brew-install)";
  install-all = "nix-rebuild && brew-install && mise install";
  # Open vim with the chezmoi config
  conf = " cd $(chezmoi source-path) && nvim";
}
