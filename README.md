# pi-projects

Use a raspberry pi to make my phone a wifi hotspot.  Because bits are bits.

1. ~~Tethering. `sudo dhclient usb0`~~ (doesn't look necessary to me)
1. ~~Look into udev rules to make that automatic.~~
1. [Adafruit has instructions for the rest](https://cdn-learn.adafruit.com/downloads/pdf/setting-up-a-raspberry-pi-as-a-wifi-access-point.pdf)
    1. Update/upgrade/install
        ```
        sudo apt update
        sudo apt upgrade -y
        sudo apt autoremove
        sudo apt install unattended-upgrades hostapd isc-dhcp-server iptables-persistent
        ```
    1. Edit `/etc/dhcp/dhcpd.conf`
        ```
        # Comment out these lines
        #option domain-name "example.org";
        #option domain-name-servers ns1.example.org, ns2.example.org;

        # Uncomment this line
        authoritative
        
        # Add this to the end of the file
        subnet 192.168.8.0 netmask 255.255.255.0 {
          range 192.168.8.10 192.168.8.50;
          option broadcast-address 192.168.8.255;
          option routers 192.168.8.1;
          default-lease-time 600;
          max-lease-time 7200;
          option domain-name "local";
          option domain-name-servers 8.8.8.8, 8.8.4.4;
        }
        ```
    1. Edit `/etc/default/isc-dhcp-server
        ```
        # Change this line
        INTERFACES="wlan0"
        ```
    1. Edit `/etc/network/interfaces`
        ```
        # Comment out anything referencing wlan0.
        # auto wlan0
        allow-hotplug wlan0
        iface wlan0 inet static
          address 192.168.8.1
          netmask 255.255.255.0
        ```
    1. Edit `/etc/hostapd/hostapd.conf`
        ```
        interface=wlan0
        ssid=Pi_AP
        country_code=US
        hw_mode=g
        channel=6
        macaddr_acl=0
        auth_algs=1
        ignore_broadcast_ssid=0
        wpa=2
        wpa_passphrase=Raspberry
        wpa_key_mgmt=WPA-PSK
        wpa_pairwise=CCMP
        wpa_group_rekey=86400
        ieee80211n=1
        wme_enabled=1
        ```
    1. Edit `/etc/default/hostapd`
        ```
        #Change the line
        DAEMON_CONF="/etc/hostapd/hostapd.conf"
        ```
    1. Edit `/etc/init.d/hostapd`
        ```
        Change the line
        DAEMON_CONF="/etc/hostapd/hostapd.conf"
        ```
    1. Edit `/etc/sysctl.conf`
        ```
        # Add the line
        net.ipv4.ip_forward=1
        ```
    1. Setup iptables
        ```
        sudo iptables -t nat -A POSTROUTING -o usb0 -j MASQUERADE
        sudo iptables -A FORWARD -i usb0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
        sudo iptables -A FORWARD -i wlan0 -o usb0 -j ACCEPT
        sudo sh -c "iptables-save > /etc/iptables/rules.v4"
        ```
    1. Enable services
        ```
        sudo update-rc.d hostapd enable
        sudo update-rc.d isc-dhcp-server enable
        ```
