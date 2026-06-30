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
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        # Disable "Select the previous input source" (Control+Space).
        "60" = {
          enabled = false;
        };

        # Set "Select next source in Input menu" to Hyper+#.
        "61" = {
          enabled = true;
          value = {
            parameters = [
              35
              42
              1966080
            ];
            type = "standard";
          };
        };
      };
    };

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
