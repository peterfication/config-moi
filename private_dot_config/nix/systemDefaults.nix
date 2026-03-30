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
    pbs = {
      NSServicesStatus = {
        "com.mitchellh.ghostty - New Ghostty Window Here - openWindow" = {
          key_equivalent = "@~^$t";
        };
      };
    };
  };
}
