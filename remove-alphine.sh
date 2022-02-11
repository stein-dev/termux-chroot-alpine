#!/system/bin/sh
set -e

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

CHROOT='/data/chrootalpine'

./unmount-alpine.sh || true

echo "Deleting alpine rootfs"
rm -rf $CHROOT
echo "Done"