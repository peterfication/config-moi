for file in ~/.config/zsh/tools/*.zsh; do
  [ -r "$file" ] && source "$file"
done
