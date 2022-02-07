#!/system/bin/sh
set -e

# PARAMETERS ---
CHROOT='/data/alpinetest'
MIRR='http://dl-cdn.alpinelinux.org/alpine'
DNS1='1.1.1.1'
DNS2='1.0.0.1'


echo "Setting up folders"
ARCH=`uname -m`
mkdir -p $CHROOT
cd $CHROOT
echo "Done"

echo "Downloading alpine rootfs"
FILE=`busybox wget -qO- "$MIRR/latest-stable/releases/$ARCH/latest-releases.yaml" | busybox grep -o -m 1 'alpine-minirootfs-.*.tar.gz'`

busybox wget "$MIRR/latest-stable/releases/$ARCH/$FILE" -O rootfs.tar.gz
echo "Done"


echo "Extracting rootfs"
busybox tar -xf rootfs.tar.gz
echo "Done"

echo "Setting up dns"
echo "nameserver $DNS1
nameserver $DNS2" > etc/resolv.conf
echo "Done"

echo "Creating mountpoints"
mkdir -p "$CHROOT/apex"
cd "/apex"
for f in *; do
        mkdir -p "$CHROOT/apex/$f"
done
cd - 2>&1 > /dev/null
mkdir -p "$CHROOT/data/data"
mkdir -p "$CHROOT/dev/shm"
mkdir -p "$CHROOT/dev/binderfs"
mkdir -p "$CHROOT/data/dalvik-cache"
mkdir -p "$CHROOT/vendor"
mkdir -p "$CHROOT/system"
mkdir -p "$CHROOT/odm"
mkdir -p "$CHROOT/sdcard"
mkdir -p "$CHROOT/linkerconfig"
echo "Done"