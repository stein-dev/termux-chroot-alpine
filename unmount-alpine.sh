#!/system/bin/sh
set -e

CHROOT='/data/alpinetest'

echo "Unmouting folders..."
busybox umount "$CHROOT/dev/pts"
busybox umount "$CHROOT/dev/shm"
busybox umount "$CHROOT/dev/binderfs"
busybox umount "$CHROOT/dev"
busybox umount "$CHROOT/data/dalvik-cache"
busybox umount "$CHROOT/vendor"
busybox umount "$CHROOT/sys"
busybox umount "$CHROOT/linkerconfig"
busybox umount "$CHROOT/system"
busybox umount "$CHROOT/odm"
busybox umount "$CHROOT/sdcard"
busybox umount "$CHROOT/proc"
busybox umount "$CHROOT/tmp"
busybox umount "$CHROOT/data/data"
cd "$CHROOT/apex"
for f in *; do
        busybox umount "$CHROOT/apex/$f"
done
cd - 2>&1 > /dev/null
echo "Done"