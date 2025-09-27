for file in ~/.config/zsh_new/languages/*.zsh; do
  [ -r "$file" ] && source "$file"
done
