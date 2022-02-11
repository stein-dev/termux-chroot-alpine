#!/system/bin/sh
set -e

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

CHROOT='/data/chrootalpine'

echo "Unmounting $CHROOT/proc"
busybox umount "$CHROOT/proc"

echo "Unmounting $CHROOT/sys"
busybox umount -l "$CHROOT/sys"

echo "Unmounting $CHROOT/dev"
busybox umount -l "$CHROOT/dev"

echo "Unmounting $CHROOT/sdcard"
busybox umount -l "$CHROOT/sdcard"

echo "Unmounting $CHROOT/vendor"
busybox umount -l "$CHROOT/vendor"

echo "Unmounting $CHROOT/data/dalvik-cache"
busybox umount -l "$CHROOT/data/dalvik-cache"

echo "Unmounting $CHROOT/system"
busybox umount -l "$CHROOT/system"

echo "Unmounting $CHROOT/data/data"
busybox umount -l "$CHROOT/data/data"

echo "Unmounting $CHROOT/linkerconfig"
busybox umount -l "$CHROOT/linkerconfig"

echo "Unmounting $CHROOT/proc"
cd "$CHROOT/apex"
for f in *; do
        busybox umount -l "$CHROOT/apex/$f"
done
cd - 2>&1 > /dev/null
echo "Done"