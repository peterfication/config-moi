# Restic

```bash
launchctl bootout gui/$(id -u) "$HOME/Library/LaunchAgents/restic.backup.plist" 2>/dev/null || true
launchctl bootstrap gui/$(id -u) "$HOME/Library/LaunchAgents/restic.backup.plist"
launchctl enable gui/$(id -u)/restic.backup
launchctl kickstart -k gui/$(id -u)/restic.backup
```
