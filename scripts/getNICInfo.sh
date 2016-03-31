#!/bin/sh
NIC=$1
HWAddr=$(ifconfig $NIC|grep HWaddr|sed 's/.*HWaddr //'| sed 's/^.*HWaddr\([0-9a-f:]+\).*$/\1/' |sed 's/://g')
IPAddr=$(ifconfig $NIC|grep 'inet addr'|sed 's/.*inet addr:\(.*\) Bcast.*/\1/')
echo ${HWAddr},${IPAddr}
