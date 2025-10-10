# Remove files a little bit more secure
alias shred="rm -rPv"

# Restart the camera on a Mac when it fails
alias restart-camera='sudo killall VDCAssistant && sudo killall AppleCameraAssistant'

# Clear the current shell, not only scroll down like clear does
alias clear-real="clear && printf '\e[3J'"

# Inspired by https://github.com/jlevy/the-art-of-command-line
alias explain="~/config/zsh/other/explain.sh"

alias sqlite='sqlite3'
sqlite-csv-viewer() {
  sqlite3 -column :memory: ".import --csv $1 tmp" 'select * from tmp;' | bat
}
# curl https://clickhouse.com/ | sh
# See https://clickhouse.com/docs/en/operations/utilities/clickhouse-local
alias clickhouse=~/clickhouse
clickhouse-csv-viewer() {
  clickhouse local --query="SELECT * FROM '$1'"
}

# If there is a fork processes problem:
alias processes_count="ps -e | awk '{print $4" "$5" "$6}' | sort | uniq -c | sort -n"
# => Check for zombie/defunct processes to find the root cause.
# Make sure macOS is in server mode:
# sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"
# Increase max processes:
# sudo sysctl kern.tty.ptmx_max=999
