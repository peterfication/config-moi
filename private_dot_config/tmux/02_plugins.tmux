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
set -g @plugin 'alexwforsythe/tmux-which-key'
set -g @plugin 'tmux-plugins/tmux-fpp'
set -g @plugin 'Morantron/tmux-fingers'

# https://github.com/Peter-McKinney/tmux-fzf-open-files-nvim
set -g @plugin 'Peter-McKinney/tmux-open-file-nvim'
set -g @open-file-nvim-key e
set -g @open-file-nvim-all-key E
set -g @open-file-nvim-all-history-key H
