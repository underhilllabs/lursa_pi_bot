#!/bin/bash
# Start up lursa-bot at startup time
LURSA_DIR="/home/pi/projects/lursa_pi_bot"
CMD="iex -S mix"

#
# Function that starts the daemon/service
#
do_start()
{
  tmux new-session -s lursabot -d 'cd /home/pi/projects/lursa_pi_bot && iex -S mix'
  echo "starting Lursa Bot..."
}

do_stop()
{
  tmux kill-session -t lursabot
  echo "stopping Lursa Bot..."
}
case "$1" in
  start|restart)
        do_start
	exit 0
        ;;
  reload|force-reload|restart)
	do_stop
	do_start
	exit 0
	;;
  stop)
	do_stop
	exit 3
	;;
  *)
    echo "Only starts daemon" >&2
    exit 3
    ;;
esac

exit 0
