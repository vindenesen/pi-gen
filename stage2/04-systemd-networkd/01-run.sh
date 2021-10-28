#!/bin/bash -e

if [[ -f "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf" ]]; then
        mv "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf" "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant-wlan0.conf"
fi

on_chroot << EOF
systemctl disable ifupdown dhcpcd dhcpcd5 isc-dhcp-client isc-dhcp-common rsyslog wpa_supplicant
apt --autoremove purge -y ifupdown dhcpcd dhcpcd5 isc-dhcp-client isc-dhcp-common rsyslog
rm -r /etc/network /etc/dhcp

ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
apt-mark hold avahi-daemon dhcpcd dhcpcd5 ifupdown isc-dhcp-client isc-dhcp-common libnss-mdns openresolv raspberrypi-net-mods rsyslog
systemctl enable systemd-networkd.service systemd-resolved.service

systemctl disable wpa_supplicant
systemctl enable wpa_supplicant@wlan0
EOF

install -v -m 644 files/04-eth0.network               "${ROOTFS_DIR}/etc/systemd/network/"
install -v -m 644 files/08-wlan0.network              "${ROOTFS_DIR}/etc/systemd/network/"

sed -i 's/#LLMNR=no/LLMNR=yes/g'                     "${ROOTFS_DIR}/etc/systemd/resolved.conf"
