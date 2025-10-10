# zoxide interactive
alias zz=zi

# NOTE: --basedir is not released yet (merged in August, last release in May)
# https://github.com/ajeetdsouza/zoxide/pull/1027

# zoxide with Git root as basedir
alias zg='zoxide --basedir $(git rev-parse --show-toplevel)'
# zoxide with current directory as basedir
alias zb='zoxide --basedir .'

# Use Ctrl-z to start zoxide interactive mode
# Widget: feed `zi` and new line
__run_zi() {
  LBUFFER="zi"
  zle accept-line
}
zle -N __run_zi
bindkey '^z' __run_zi
bindkey -M viins '^z' __run_zi
bindkey -M vicmd '^z' __run_zi
