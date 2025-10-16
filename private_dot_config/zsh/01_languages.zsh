for file in ~/.config/zsh/languages/*.zsh; do
  [ -r "$file" ] && source "$file"
done
