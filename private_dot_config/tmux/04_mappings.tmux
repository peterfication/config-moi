
# Reload the tmux config Ctrl+b r
bind r source-file ~/.config/tmux/tmux.conf \; display "Config Reloaded!"

#### SESSIONS ####

# Switch sessions with the help of fzf
bind-key C-f run-shell -b 'selected=$(tmux ls -F "##S" | fzf-tmux -- --header "[Switch session]") || exit 0; [ -n "$selected" ] && tmux switch-client -t "$selected"'

# Kill sessions with the help of fzf
bind-key C-d run-shell -b 'selected=$(tmux ls -F "##S" | fzf-tmux -- --header "[Kill session]") || exit 0; [ -n "$selected" ] && tmux kill-session -t "$selected"'

# A key binding that opens the icd history and on enter creates a ts session with this dir
bind-key C-t run-shell -b 'selected=$(cat "$TMUX_SESSIONS_FILE" | fzf-tmux -- --header "[Create session]") || exit 0; [ -n "$selected" ] && zsh -lc '\''source ~/.config/zsh/tools/tmux.zsh && tmux display "Session created for $1" && ts_from_arg "$1"'\'' _ "$selected"'

#### WINDOWNS ####

# Switch windows with the help of fzf
bind-key C-g run-shell -b "tmux list-windows -F \"##I:##W\" | fzf-tmux -- --header '[Switch window]' | cut -d \":\" -f 1 | xargs tmux select-window -t"

# Switch windows
bind C-n next-window
bind C-p previous-window

#### PANES ####

# Switch pane with C-bb
bind C-b select-pane -t :.+

# Move around panes with vim movements
bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R

#### OUTPUT ####

# Enable v and y for vi-mode
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
bind Escape copy-mode # `tmux prefix + Escape` starts copy mode.
bind p paste-buffer

# Lazygit pop-up
bind-key C-g display-popup -E -d "#{pane_current_path}" -xC -yC -w 90% -h 90% "lazygit"

# FPP PathFinder
# Disable default binding
set -g @fpp-bind off
# Bind 'p' to run FPP launching an editor
bind-key p run-shell '~/.tmux/plugins/tmux-fpp/fpp.tmux start edit'

# Bind 'o' to run FPP and paste the list of files in the initial pane
bind-key o run-shell '~/.tmux/plugins/tmux-fpp/fpp.tmux start paste'

# Fingers https://github.com/Morantron/tmux-fingers
set -g @fingers-key m

# Open a new window in the current path and start Codex
bind-key C-c new-window -c "#{pane_current_path}" "codex"
