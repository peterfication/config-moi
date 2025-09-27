export FZF_DEFAULT_COMMAND="rg --files"

# From https://medium.com/@sidneyliebrand/how-fzf-and-ripgrep-improved-my-workflow-61c7ca212861
# mnemonic: [K]ill [P]rocess
kill-process() {
  local pid=$(ps -ef | sed 1d | eval "fzf  -m --header='[kill:process]'" | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs sudo kill -${1:-9}
    kp
  fi
}
alias kp=kill-process
