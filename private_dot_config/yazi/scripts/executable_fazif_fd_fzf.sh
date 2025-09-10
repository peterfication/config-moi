#!/usr/bin/env sh

# Find files/directories in current directy (max-depth) with fd and fzf
# https://github.com/Shallow-Seek/fazif.yazi/blob/main/faziffd

fd . --max-depth 1 -H "$@" | \
  fzf --info=inline --layout=reverse
