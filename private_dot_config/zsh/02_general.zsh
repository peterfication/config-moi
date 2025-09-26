export VISUAL="nvim"
export EDITOR="nvim"
# alias nvim="~/.local/share/neovim/bin/nvim"
alias e=nvim
alias n=nvim

# See https://wilsonmar.github.io/maximum-limits/
# To me a problem occurred with Capybara and Webmock displaying the following message:
#   Failed to open TCP connection to 127.0.0.1:9515 (Too many open files - socket(2) for "127.0.0.1" port 9515
ulimit -n 8192
