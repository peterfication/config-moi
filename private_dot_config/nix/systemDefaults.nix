{
  # Check the values with the following command:
  #
  #   defaults read NSGlobalDomain KeyRepeat
  #
  NSGlobalDomain = {
    KeyRepeat = 3; # Lower is faster
    InitialKeyRepeat = 15; # Lower is sooner
  };

  CustomUserPreferences = {
    NSGlobalDomain = {
      NSUserKeyEquivalents = {
        # Control+Option+Shift+F20, intentionally unavailable on the physical keyboard.
        "Hide Others" = builtins.fromJSON ''"^~$\uf717"'';
        "Andere ausblenden" = builtins.fromJSON ''"^~$\uf717"'';
      };
    };

    pbs = {
      NSServicesStatus = {
        "com.mitchellh.ghostty - New Ghostty Window Here - openWindow" = {
          key_equivalent = "@~^$t";
        };
      };
    };
  };
}
