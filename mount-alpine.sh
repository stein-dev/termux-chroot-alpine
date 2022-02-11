#!/system/bin/sh
set -e

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

CHROOT='/data/chrootalpine'

echo "Mounting stuff..."
# From Android 10, /apex is needed
busybox mount -t proc none $CHROOT/proc

cd /apex
for f in *; do
        busybox mount --rbind "/apex/$f" "$CHROOT/apex/$f"
done
cd - 2>&1 > /dev/null

busybox mount --rbind /dev "$CHROOT/dev"
busybox mount -o bind /data/dalvik-cache "$CHROOT/data/dalvik-cache"
busybox mount --rbind /vendor "$CHROOT/vendor"
busybox mount --rbind /sys "$CHROOT/sys"
busybox mount --rbind /system "$CHROOT/system"
busybox mount --rbind /sdcard "$CHROOT/sdcard"
busybox mount -o bind /data/data "$CHROOT/data/data"
busybox mount --rbind /linkerconfig "$CHROOT/linkerconfig"

unset LD_PRELOAD
unset PREFIX

echo "Done"
