#!/bin/sh
sudo apt-get update
sudo apt-get install bridge-utils hostapd isc-dhcp-server

if [ ! -d deps ]; then
  mkdir deps
fi

wget http://12244.wpc.azureedge.net/8012244/drivers/rtdrivers/cn/wlan/0001-RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip -O deps/driver.zip
unzip deps/driver.zip -d deps
tar zxf deps/RTL8188C*/wpa_supplicant_hostapd/wpa_supplicant_hostapd*.tar.gz -C deps/RTL8188C*/wpa_supplicant_hostapd/
sudo make install -C deps/RTL8188C*/wpa_supplicant_hostapd/wpa_supplicant_hostapd*/hostapd
