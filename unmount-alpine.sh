#!/system/bin/sh
set -e

CHROOT='/data/alpinetest'

# ps=(`lsof -Fp "$CHROOT" | sed "s/^p//"`)
# for pid in "${ps[@]}"; do
#         kill -9 "$pid"
# done
umount "$CHROOT/dev/pts"
umount "$CHROOT/dev/shm"
umount "$CHROOT/dev/binderfs"
umount "$CHROOT/dev"
umount "$CHROOT/data/dalvik-cache"
umount "$CHROOT/vendor"
umount "$CHROOT/sys"
umount "$CHROOT/linkerconfig"
umount "$CHROOT/system"
umount "$CHROOT/odm"
umount "$CHROOT/sdcard"
umount "$CHROOT/proc"
umount "$CHROOT/tmp"
umount "$CHROOT/data/data"
cd "$CHROOT/apex"
for f in *; do
        umount "$CHROOT/apex/$f"
done
cd - 2>&1 > /dev/null
umount "$CHROOT"

echo "Done"