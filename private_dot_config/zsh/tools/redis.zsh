export REDIS_HOME="$HOME/.local/share/redis"
export REDIS_DATA="$REDIS_HOME/data"
export REDIS_LOGDIR="$REDIS_HOME/log"
export REDIS_RUNDIR="$REDIS_HOME/run"
export REDIS_LOGFILE="$REDIS_LOGDIR/redis.log"
export REDIS_PIDFILE="$REDIS_RUNDIR/redis.pid"

alias s-redis_service_start='mkdir -p "$REDIS_DATA" "$REDIS_LOGDIR" "$REDIS_RUNDIR" && redis-server --daemonize yes --bind 127.0.0.1 --port 6379 --dir "$REDIS_DATA" --pidfile "$REDIS_PIDFILE" --logfile "$REDIS_LOGFILE"'
alias s-redis_service_stop='redis-cli -p 6379 shutdown'
alias s-redis_service_status='redis-cli -p 6379 ping'
alias s-redis_service_logs_tail='tail -n 200 -f "$REDIS_LOGFILE"'
