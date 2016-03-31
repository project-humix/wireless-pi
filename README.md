# wireless-pi

This is a utility that helps you to power on your raspberry pi with wireless network connectivity.

# Prerequisite

- a raspberry pi with raspbian
- a [EDIMAX EW-7811 Un](http://www.edimax.com/edimax/merchandise/merchandise_detail/data/edimax/global/wireless_adapters_n150/ew-7811un)

Note: Currently, it helps you to download the hostapd package, build and install. 
If you use different wirless dungle, you can skip the preinstall script.

# How it works

The daemon script tries to use wpa_supplicant to start up your wireless with the 
configuration in `config/wpa_supplicant.conf`. If the process fails, the hostapd
and dhcpd are executed and serve a web page in http://192.168.127.1 for you to
config your SSID and password. The hostapd here uses a fix format of SSID, something
like `humix005056c00008`. The number after the 'humix' is the HWAddr of your
wireless NIC. (If you don't know the HWAddr of your wirless NIC, you can plugin it
to your desktop/laptop and query it via `ifconfig` utilities.) You can use your 
laptop/desktop/phone to connect to this hotspot and open up the http://192.168.127.1
page to set up the SSID/password that you are going to connect. After you click the
'Submit' button. It will use the settings to bring up the wpa_supplicant. 
If the SSID/password works, your raspberry pi will be online now. If the wpa_supplicat
fails, it will fail back to hostapd again. Then you can re-assign the SSID/password.

# Installation
