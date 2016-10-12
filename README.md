# wireless-pi

This is a utility that helps you to power on your raspberry pi3 with wireless network connectivity.

# Prerequisite

- a raspberry pi with raspbian
- nodejs


# How it works

The daemon script tries to use wpa_supplicant to start up your wireless with the 
configuration in `config/wpa_supplicant.conf`. If the process fails, the hostapd
and dhcpd are executed and serve a web page in http://192.168.127.1:3000. It contains
a simple page for you to config your SSID and password. The hostapd here uses a fix 
format SSID name, something like `humix005056c00008`. The number after the 'humix'
is the HWAddr of your wireless NIC. (If you don't know the HWAddr of your wirless NIC,
you can plugin it to your desktop/laptop and query it via `ifconfig` utilities.) You can use your
laptop/desktop/phone to connect to this hotspot and open up the http://192.168.127.1:3000
page to set up the SSID/password that you are going to connect. After you click the
'Submit' button. It will use the settings to bring up the wpa_supplicant. 
If the SSID/password works, your raspberry pi will be online now. If the wpa_supplicat
fails, it will fail back to hostapd again. Then you can re-assign the SSID/password.

# Scripts

All of the scripts under `scripts` folder need to be executed with root permission, means
you need to execute the scripts with `sudo`. You can use these scripts to turn on/off the
hotspot mode or connect to a access point manually.
- wpa_util.sh: this is used to stop/stop the wpa_supplicat. The configruation it uses is
  `config/wpa_supplicant.conf`. Normally, this file doesn't exit when you install this tool.
  The config file will be created after you assign the SSID/password in hotspot mode via
  the page in http://192.168.127.1:3000

- hostap_util.sh: this is used to start/stop the hotspot mode. It uses the `config/dhcpd.conf`
  for dhcpd and `config/hostapd.conf` for hostapd. The fixed IPAddr for the dhcpd is `192.168.127.1`.

# Installation

- git clone this project  
  `git clone https://github.com/project-humix/wireless-pi.git`
- get into the project directory  
  `cd wireless-pi`
- kick off the installation  
  `npm install`

**Make sure that the `/etc/network/interfaces` should look like this**:

```
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

iface eth0 inet manual

allow-hotplug wlan0

allow-hotplug wlan1
```
