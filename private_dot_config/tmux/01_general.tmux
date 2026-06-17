# Base

# Enable support for extended (modified) keys, e.g. Shift+Arrow keys, Ctrl+Arrow keys, etc.
set -g extended-keys-format csi-u

set -g mode-keys vi # Enable vi-mode
# emacs key bindings in tmux command prompt (prefix + :) are better than
# vi keys, even for vim users
set -g status-keys emacs
set -g mouse on

set -g status-left-length 30
set -g base-index 1
set -sg escape-time 10 # Don't delay the ESC key too much
set-option -g history-limit 30000
# Show the status display longer
set-option -g display-time 4000

# Don't rename the window to the current command
set-option -g allow-rename off

# Set tmux TERM
set-option -g default-terminal "tmux-256color"

set -g allow-passthrough on
set -g set-titles on
set -g set-titles-string '#S:#I #W'

# For terminal applications to receive focus events
set -g focus-events on
