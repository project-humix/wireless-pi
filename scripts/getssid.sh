#!/bin/sh
ifconfig|grep wlan0|sed 's/.*HWaddr //'|sed 's/://g'
