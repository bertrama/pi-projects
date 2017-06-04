#!/bin/bash

iptables -t nat -A POSTROUTING -o usb0 -j MASQUERADE
iptables -A FORWARD -i usb0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o usb0 -j ACCEPT
sh -c "iptables-save > /etc/iptables/rules.v4"

update-rc.d hostapd enable
update-rc.d isc-dhcp-server enable
