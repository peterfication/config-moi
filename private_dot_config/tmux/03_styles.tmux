# Style

# Update Interval
set -g status-interval 1

# set -g window-style 'fg=colour242,bg=colour237'
# set -g window-active-style 'bg=black,fg=colour247'

# This tmux statusbar config was created by tmuxline.vim
# on Mon, 08 Mar 2021
# https://github.com/edkolev/tmuxline.vim
set -g status-justify "left"
set -g status "on"
set -g status-left-style "none"
set -g message-command-style "fg=#f8f8f0,bg=#232526"
set -g status-right-style "none"
set -g pane-active-border-style "fg=#b08602"
set -g status-style "none,bg=#465457"
set -g message-style "fg=#f8f8f0,bg=#232526"
set -g pane-border-style "fg=#232526"
set -g status-right-length "100"
set -g status-left-length "100"
setw -g window-status-activity-style "none"
setw -g window-status-separator ""
setw -g window-status-style "none,fg=#f8f8f0,bg=#465457"
set -g status-right "#[fg=#232526,bg=#465457,nobold,nounderscore,noitalics]#[fg=#f8f8f0,bg=#232526] %Y-%m-%d  %H:%M #[fg=#b08602,bg=#232526,nobold,nounderscore,noitalics]#[fg=#080808,bg=#b08602] #h "
set -g @tool-pane-state '#{?#{@tool-state},#{@tool-state},#{pane_title}}'
set -g @tool-pane-title-indicator '#{?#{==:#{E:@tool-pane-state},tool:running},#[fg=#b08602]● ,#{?#{==:#{E:@tool-pane-state},tool:requires-input},#[fg=#ff5f5f]! ,#{?#{==:#{E:@tool-pane-state},tool:finished},#[fg=#87af5f]✓ ,}}}'
set -g @tool-session-title-indicator '#{?#{==:#{@tool-session-state},tool:running},#[fg=#b08602]● ,#{?#{==:#{@tool-session-state},tool:requires-input},#[fg=#ff5f5f]! ,#{?#{==:#{@tool-session-state},tool:finished},#[fg=#87af5f]✓ ,}}}'
set -g status-left "#[fg=#080808,bg=#b08602] #{E:@tool-session-title-indicator}#[fg=#080808,bg=#b08602]#S #[fg=#b08602,bg=#465457,nobold,nounderscore,noitalics]"
setw -g window-status-format "#[fg=#f8f8f0,bg=#465457] #{E:@tool-pane-title-indicator}#[fg=#f8f8f0,bg=#465457]#I #[fg=#f8f8f0,bg=#465457] #W "
setw -g window-status-current-format "#[fg=#465457,bg=#232526,nobold,nounderscore,noitalics]#[fg=#f8f8f0,bg=#232526] #{E:@tool-pane-title-indicator}#[fg=#f8f8f0,bg=#232526]#I #[fg=#f8f8f0,bg=#232526] #W #[fg=#232526,bg=#465457,nobold,nounderscore,noitalics]"
