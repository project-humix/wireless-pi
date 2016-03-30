#!/bin/sh
. `dirname $0`/../config/env.sh
WIRELESSPI_PID="${WIRELESSPI_PID:-/var/run/wirelesspi.pid}"

action=$1
result=
case "$action" in
  start)
    sudo start-stop-daemon --stop --pidfile "$WIRELESSPI_PID" >/dev/null 2>&1
    sudo ip addr flush dev wlan0

    sudo start-stop-daemon --start --quiet --pidfile "$WIRELESSPI_PID" --exec /sbin/wpa_supplicant -- -s -B -Dnl80211,wext -iwlan0 -P${WIRELESSPI_PID} -c${WIRELESSPI_DIR}/config/wpa_supplicant.conf >/dev/null 2>&1
    for i in `seq 10`; do
      sleep 2
      ifconfig wlan0 | grep 'inet addr' -q
      if [ $? -eq 0 ]; then
        result=done
        break
      fi
    done
    if [ "$result" = "done" ]; then
      echo "connected"
      exit 0
    else
      echo "failed"
      exit 1
    fi
    ;;
  stop)
    sudo start-stop-daemon --stop --pidfile "$WIRELESSPI_PID" #>/dev/null 2>&1
    sudo ip addr flush dev wlan0
    ;;
  *)
    echo "Usage: wpa_util.sh {start|stop}" || true
    exit 1
    ;;
esac
