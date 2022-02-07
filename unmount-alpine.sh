#!/system/bin/sh
set -e

CHROOT='/data/alpinetest'

echo "1"
busybox umount "$CHROOT/proc"
echo "2"
busybox umount -l "$CHROOT/sys"
echo "3"
busybox umount -l "$CHROOT/dev"
echo "4"
busybox umount -l "$CHROOT/mnt/sdcard"
echo "5"
busybox umount -l "$CHROOT/vendor"
echo "6"
busybox umount -l "$CHROOT/data/dalvik-cache"
echo "7"
busybox umount -l "$CHROOT/system"
echo "8"
busybox umount -l "$CHROOT/data/data"

echo "9"
cd "$CHROOT/apex"
for f in *; do
        busybox umount -l "$CHROOT/apex/$f"
done
cd - 2>&1 > /dev/null

echo "10"
busybox umount -l "$CHROOT"

echo "Done"