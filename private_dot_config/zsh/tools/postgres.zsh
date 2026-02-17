# Find the installed versions:
#   ls -l /nix/store/*postgresql-*/bin/psql
export PG16_BIN="/nix/store/8mjxcgh6l95v0855rps2wgjshq0x6f2s-postgresql-16.11/bin"
export PG17_BIN="/nix/store/8dqr0i6k6r2cjfgd2r5jyaihbdicqb9c-postgresql-17.7/bin"

# PostgreSQL 16
export PG16_HOME="$HOME/.local/share/postgres16"
export PG16_DATA="$PG16_HOME/data"
export PG16_LOGDIR="$PG16_HOME/log"
export PG16_RUNDIR="$PG16_HOME/run"
export PG16_LOGFILE="$PG16_LOGDIR/postgres.log"
export PG16_PIDFILE="$PG16_RUNDIR/postgres.pid"

alias pgc16_init='mkdir -p "$PG16_LOGDIR" "$PG16_RUNDIR" && "$PG16_BIN/initdb" -D "$PG16_DATA"'
alias pgc16_service_start='mkdir -p "$PG16_LOGDIR" "$PG16_RUNDIR" && "$PG16_BIN/pg_ctl" -D "$PG16_DATA" -l "$PG16_LOGFILE" -o "-k $PG16_RUNDIR -c unix_socket_permissions=0700 -c listen_addresses=localhost -c logging_collector=off -c log_destination=stderr -c log_line_prefix=%m[%p]%q%u@%d " -w start'
alias pgc16_service_stop='"$PG16_BIN/pg_ctl" -D "$PG16_DATA" -m fast -w stop'
alias pgc16_service_restart='"$PG16_BIN/pg_ctl" -D "$PG16_DATA" -m fast -w restart -l "$PG16_LOGFILE"'
alias pgc16_service_status='"$PG16_BIN/pg_ctl" -D "$PG16_DATA" status'
alias pgc16_service_tail='tail -n 200 -f "$PG16_LOGFILE"'
alias pgc16_ready='"$PG16_BIN/pg_isready" -h localhost -p 5433'

# PostgreSQL 17
export PG17_HOME="$HOME/.local/share/postgres17"
export PG17_DATA="$PG17_HOME/data"
export PG17_LOGDIR="$PG17_HOME/log"
export PG17_RUNDIR="$PG17_HOME/run"
export PG17_LOGFILE="$PG17_LOGDIR/postgres.log"
export PG17_PIDFILE="$PG17_RUNDIR/postgres.pid"

alias pgc17_init='mkdir -p "$PG17_LOGDIR" "$PG17_RUNDIR" && "$PG17_BIN/initdb" -D "$PG17_DATA"'
alias pgc17_service_start='mkdir -p "$PG17_LOGDIR" "$PG17_RUNDIR" && "$PG17_BIN/pg_ctl" -D "$PG17_DATA" -l "$PG17_LOGFILE" -o "-k $PG17_RUNDIR -c unix_socket_permissions=0700 -c listen_addresses=localhost -c logging_collector=off -c log_destination=stderr -c log_line_prefix=%m[%p]%q%u@%d " -w start'
alias pgc17_service_stop='"$PG17_BIN/pg_ctl" -D "$PG17_DATA" -m fast -w stop'
alias pgc17_service_restart='"$PG17_BIN/pg_ctl" -D "$PG17_DATA" -m fast -w restart -l "$PG17_LOGFILE"'
alias pgc17_service_status='"$PG17_BIN/pg_ctl" -D "$PG17_DATA" status'
alias pgc17_service_tail='tail -n 200 -f "$PG17_LOGFILE"'
alias pgc17_ready='"$PG17_BIN/pg_isready" -h localhost -p 5434'
