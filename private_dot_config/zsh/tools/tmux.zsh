alias tm='tmux'

export TMUX_SESSIONS_FILE="$HOME/.config/tmux/sessions.txt"

# Add the current working directory to the tmux sessions file
function tm_add_cwd() {
  local cwd=$(pwd)
  if ! grep -Fxq "$cwd" "$TMUX_SESSIONS_FILE"; then
    echo "$cwd" >> "$TMUX_SESSIONS_FILE"
  fi
}

# Super Guide to the split-window tmux Subcommand (and Beyond)
# https://gist.github.com/sdondley/b01cc5bb1169c8c83401e438a652b84e

function tmux_new_with_name() {
  local ts_dir="$1"
  local dir_name="${ts_dir:t}"
  dir_name="${dir_name//./-}"
  dir_name="${dir_name// /-}"

  echo "Create session '${dir_name}' with window 'nvim' and folder '${ts_dir}'"
  tmux new-session -d -c "$ts_dir" -s "$dir_name" -n nvim
  tmux send-keys -t "${dir_name}:nvim" nvim Enter
}

function ts() {
  local dir_name="${PWD:t}"
  dir_name="${dir_name//./-}"
  dir_name="${dir_name// /-}"

  tmux_new_with_name "$PWD"
  tmux a -t "$dir_name"
}

# This function is for tmux session creations. See tmux/04_mappings.tmux
function ts_from_arg() {
  local ts_dir="$1"

  tmux_new_with_name "$ts_dir"
  # tmux -2 a -t $DIR_NAME
}

# fs [FUZZY PATTERN] - Select selected tmux session
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}
