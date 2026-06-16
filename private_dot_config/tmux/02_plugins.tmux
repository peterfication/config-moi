# Show URLs with CTRL+b + u
# Needs brew install urlview
set -g @plugin 'tmux-plugins/tmux-urlview'

# Select console output line with CTRL+b + TAB
set -g @plugin 'laktak/extrakto'

# https://github.com/sainnhe/tmux-fzf
# CTRL+b + SHIFT+f
set -g @plugin 'sainnhe/tmux-fzf'

# Check out:
# - https://github.com/thewtex/tmux-mem-cpu-load

set -g @plugin 'schasse/tmux-jump'
# tmux which-key
# Trigger with prefix+space
set -g @plugin 'alexwforsythe/tmux-which-key'

# FPP PathFinder
set -g @plugin 'tmux-plugins/tmux-fpp'
# Disable default binding
set -g @fpp-bind off
# Bind 'p' to run FPP launching an editor
bind-key p run-shell '~/.tmux/plugins/tmux-fpp/fpp.tmux start edit'
# Bind 'o' to run FPP and paste the list of files in the initial pane
bind-key o run-shell '~/.tmux/plugins/tmux-fpp/fpp.tmux start paste'

# Fingers https://github.com/Morantron/tmux-fingers
set -g @plugin 'Morantron/tmux-fingers'
set -g @fingers-key m

# https://github.com/Peter-McKinney/tmux-fzf-open-files-nvim
set -g @plugin 'Peter-McKinney/tmux-open-file-nvim'
set -g @open-file-nvim-key e
set -g @open-file-nvim-all-key E
set -g @open-file-nvim-all-history-key H
