#!/bin/bash
apt-get install coreutils quilt parted qemu-user-static debootstrap zerofree zip \
dosfstools libarchive-tools libcap2-bin grep rsync xz-utils file git curl bc \
qemu-utils kpartx

echo -n "Enter Wifi name: "
read WIFI_NAME

echo -n "Enter Wifi password: "
read -s WIFI_PASS
echo

echo -n "Repeat: "
read -s WIFI_PASS2
echo

if [[ $WIFI_PASS != $WIFI_PASS2 ]]; then
  echo "Passwords do not match"
  exit 1
fi


echo "You entered: "
echo "Wifi name: $WIFI_NAME"
echo "Wifi password: $WIFI_PASS"

echo -n "This is correct? [y/N]: "
read CONFIRM

if [[ $CONFIRM == "y" ]]; then
  cat << EOF > wifi.conf
EOF_ESSID="$WIFI_NAME"
WPA_PASSWORD="$WIFI_PASS"
WPA_COUNTRY="NO"
EOF
  CLEAN=1 ./build.sh -c wifi.conf
fi
