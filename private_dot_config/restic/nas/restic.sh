source ~/./.env

restic backup \
  --exclude-file=$HOME/.restic_ignore \
  --files-from=$HOME/.restic_paths

restic check --read-data-subset=10G
restic forget --prune --keep-last 10 --keep-hourly 24 --keep-daily 7 --keep-weekly 52 --keep-monthly 120 --keep-yearly 100
restic prune
