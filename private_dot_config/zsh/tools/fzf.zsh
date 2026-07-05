export FZF_DEFAULT_COMMAND="rg --files"

# From https://medium.com/@sidneyliebrand/how-fzf-and-ripgrep-improved-my-workflow-61c7ca212861
# mnemonic: [K]ill [P]rocess
kill-process() {
  local query="${1:-}"
  local signal="${2:-9}"
  local -a fzf_output selections
  fzf_output=("${(@f)$(ps -ef | sed 1d | fzf -m --print-query --query="$query" --header='[kill:process]')}")
  query="${fzf_output[1]}"
  selections=("${fzf_output[@]:1}")
  local pid=$(printf '%s\n' "${selections[@]}" | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs sudo kill -"$signal"
    kill-process "$query" "$signal"
  fi
}
alias kp=kill-process
