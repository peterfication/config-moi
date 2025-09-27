for file in ~/.config/zsh_new/tools/*.zsh; do
  [ -r "$file" ] && source "$file"
done
