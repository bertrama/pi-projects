#!/bin/bash

apt update
apt upgrade -y
apt autoremove
apt install \
  unattended-upgrades \
  hostapd isc-dhcp-server \
  iptables-persistent
