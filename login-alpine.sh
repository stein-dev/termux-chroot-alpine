#!/system/bin/sh

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

CHROOT='/data/chrootalpine'

busybox chroot $CHROOT /bin/bash --login