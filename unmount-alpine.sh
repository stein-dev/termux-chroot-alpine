#!/system/bin/sh
set -e

CHROOT='/data/alpinetest'

busybox umount "$CHROOT/proc"
busybox umount -l "$CHROOT/sys"
busybox umount -l "$CHROOT/dev"
busybox umount -l "$CHROOT/mnt/sdcard"
busybox umount -l "$CHROOT/vendor"
busybox umount -l "$CHROOT/data/dalvik-cache"
busybox umount -l "$CHROOT/system"
busybox umount -l "$CHROOT/data/data"

cd "$CHROOT/apex"
for f in *; do
        busybox umount -l "$CHROOT/apex/$f"
done
cd - 2>&1 > /dev/null
busybox umount -l "$CHROOT"

echo "Done"