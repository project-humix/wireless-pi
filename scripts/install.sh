#!/bin/bash

HOMEDIR=`pwd`
SSID=humix`./scripts/getssid.sh`

grep -q "###WIRELESSPIDIR###" config/env.sh
if [ $? -eq 0 ]; then
  sed s/###WIRELESSPIDIR###/${HOMEDIR//\//\\/}/ config/env.sh > config/env.sh.new   
  mv config/env.sh.new config/env.sh
fi

grep -q "###HUMIXSSID###" config/hostapd.conf
if [ $? -eq 0 ]; then
  sed s/###HUMIXSSID###/${SSID// /}/ config/hostapd.conf > config/hostapd.conf.new
  mv config/hostapd.conf.new config/hostapd.conf
fi

grep -q "###WIRELESSPIDIR###" scripts/wireless-pi
if [ $? -eq 0 ]; then
  sed s/###WIRELESSPIDIR###/${HOMEDIR//\//\\/}/ scripts/wireless-pi > scripts/wireless-pi.new   
  mv scripts/wireless-pi.new scripts/wireless-pi
fi

if [ ! -f /etc/init.d/wireless-pi ]; then
  cp $HOMEDIR/scripts/wireless-pi /etc/init.d/wireless-pi
  systemctl enable wireless-pi
fi
