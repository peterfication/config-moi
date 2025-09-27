alias notes="cd ~/notes && vim"

snotes() {
  cd ~/notes
  git add .
  git stash
  git pull origin master
  git stash pop
  git add .
  git commit -m "Sync `date +"%Y-%m-%d %T"`"
  git push origin master
}
