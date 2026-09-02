# Add alfred resources to chezmoi
[group('alfred')]
alfred-add: alfred-add-websearches

# Add Alfred websearches to chezmoi
[group('alfred')]
alfred-add-websearches:
  chezmoi add ~/Library/Application\ Support/Alfred/Alfred.alfredpreferences/preferences/features/websearch/prefs.plist
