#!/bin/sh
. `dirname $0`/../config/env.sh
WIRELESSPI_DHCP_PID="${WIRELESSPI_PID:-/var/run/wirelesspi-dhcp.pid}"
WIRELESSPI_AP_PID="${WIRELESSPI_PID:-/var/run/wirelesspi-ap.pid}"

action=$1
result=
case "$action" in
  start)
    #try to stop dhcpd and hostapd
    start-stop-daemon --stop --pidfile "$WIRELESSPI_DHCP_PID" >/dev/null 2>&1
    start-stop-daemon --stop --pidfile "$WIRELESSPI_AP_PID" >/dev/null 2>&1

    #clear all ip on wlan0
    sudo ip addr flush dev wlan0
    sleep 1

    #use static ip address for dhcp server
    sudo ifconfig wlan0 192.168.127.1 netmask 255.255.255.0
    sleep 1
    
    #start dhcp server
    start-stop-daemon --start --quiet --pidfile "$WIRELESSPI_DHCP_PID" --exec /usr/sbin/dhcpd -- -cf ${WIRELESSPI_DIR}/config/dhcpd.conf -pf ${WIRELESSPI_DHCP_PID} wlan0 >/dev/null 2>&1
    sleep 2

    #start hostapd for hotspot
    start-stop-daemon --start --quiet --pidfile "$WIRELESSPI_AP_PID" --exec /usr/local/bin/hostapd -- -B -P "$WIRELESSPI_AP_PID" ${WIRELESSPI_DIR}/config/hostapd.conf >/dev/null 2>&1

    for i in `seq 10`; do
      sleep 3
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
    start-stop-daemon --stop --pidfile "$WIRELESSPI_DHCP_PID" >/dev/null 2>&1
    start-stop-daemon --stop --pidfile "$WIRELESSPI_AP_PID" >/dev/null 2>&1
    ip addr flush dev wlan0
    ;;
  *)
    echo "Usage: wpa_util.sh {start|stop}" || true
    exit 1
    ;;
esac
