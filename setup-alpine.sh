#!/system/bin/sh
set -e

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# PARAMETERS ---
CHROOT='/data/alpinetest'
MIRR='http://dl-cdn.alpinelinux.org/alpine'
DNS1='1.1.1.1'
DNS2='1.0.0.1'

echo "Setting up folders"
ARCH=`uname -m`
mkdir -p $CHROOT
cd $CHROOT

echo "Downloading alpine rootfs"
FILE=`busybox wget -qO- "$MIRR/latest-stable/releases/$ARCH/latest-releases.yaml" | busybox grep -o -m 1 'alpine-minirootfs-.*.tar.gz'`

busybox wget "$MIRR/latest-stable/releases/$ARCH/$FILE" -O rootfs.tar.gz


echo "Extracting rootfs"
busybox tar -xf rootfs.tar.gz

echo "Setting up dns"
echo "nameserver $DNS1
nameserver $DNS2" > etc/resolv.conf

echo "Creating mountpoints"
mkdir -p "$CHROOT/apex"
cd "/apex"
for f in *; do
        mkdir -p "$CHROOT/apex/$f"
done
cd - 2>&1 > /dev/null

# Creating mountpoints
mkdir -p "$CHROOT/data/data"
mkdir -p "$CHROOT/data/dalvik-cache"
mkdir -p "$CHROOT/vendor"
mkdir -p "$CHROOT/system"
mkdir -p "$CHROOT/sdcard"
mkdir -p "$CHROOT/linkerconfig"
echo "Done"

echo "Setting up environment variables"
sed "/export ANDROID_DATA=\"\/data\"/d" -i "$CHROOT/etc/profile"
echo "export ANDROID_DATA=\"/data\"" >> "$CHROOT/etc/profile"
sed "/export ANDROID_ROOT=\"\/system\"/d" -i "$CHROOT/etc/profile"
echo "export ANDROID_ROOT=\"/system\"" >> "$CHROOT/etc/profile"
sed "/export ANDROID_ART_ROOT=\"\/apex\/com.android.art\"/d" -i "$CHROOT/etc/profile"
echo "export ANDROID_ART_ROOT=\"/apex/com.android.art\"" >> "$CHROOT/etc/profile"
sed "/export ANDROID_RUNTIME_ROOT=\"\/apex\/com.android.runtime\"/d" -i "$CHROOT/etc/profile"
echo "export ANDROID_RUNTIME_ROOT=\"/apex/com.android.runtime\"" >> "$CHROOT/etc/profile"
sed "/export ANDROID_I18N_ROOT=\"\/apex\/com.android.i18n\"/d" -i "$CHROOT/etc/profile"
echo "export ANDROID_I18N_ROOT=\"/apex/com.android.i18n\"" >> "$CHROOT/etc/profile"
sed "/export ANDROID_TZDATA_ROOT=\"\/apex\/com.android.tzdata\"/d" -i "$CHROOT/etc/profile"
echo "export ANDROID_TZDATA_ROOT=\"/apex/com.android.tzdata\"" >> "$CHROOT/etc/profile"
sed "/export BOOTCLASSPATH=\"/d" -i "$CHROOT/etc/profile"
echo "export BOOTCLASSPATH=\"/apex/com.android.art/javalib/core-oj.jar:/apex/com.android.art/javalib/core-libart.jar:/apex/com.android.art/javalib/core-icu4j.jar:/apex/com.android.art/javalib/okhttp.jar:/apex/com.android.art/javalib/bouncycastle.jar:/apex/com.android.art/javalib/apache-xml.jar:/system/framework/framework.jar:/system/framework/ext.jar:/system/framework/telephony-common.jar:/system/framework/voip-common.jar:/system/framework/ims-common.jar:/system/framework/framework-atb-backward-compatibility.jar:/system/framework/telephony-ext.jar:/system/framework/WfdCommon.jar:/apex/com.android.conscrypt/javalib/conscrypt.jar:/apex/com.android.media/javalib/updatable-media.jar:/apex/com.android.mediaprovider/javalib/framework-mediaprovider.jar:/apex/com.android.os.statsd/javalib/framework-statsd.jar:/apex/com.android.permission/javalib/framework-permission.jar:/apex/com.android.sdkext/javalib/framework-sdkextensions.jar:/apex/com.android.wifi/javalib/framework-wifi.jar:/apex/com.android.tethering/javalib/framework-tethering.jar\"" >> "$CHROOT/etc/profile"
sed "/export DEX2OATBOOTCLASSPATH=\"/d" -i "$CHROOT/etc/profile"
echo "export DEX2OATBOOTCLASSPATH=\"/apex/com.android.art/javalib/core-oj.jar:/apex/com.android.art/javalib/core-libart.jar:/apex/com.android.art/javalib/core-icu4j.jar:/apex/com.android.art/javalib/okhttp.jar:/apex/com.android.art/javalib/bouncycastle.jar:/apex/com.android.art/javalib/apache-xml.jar:/system/framework/framework.jar:/system/framework/ext.jar:/system/framework/telephony-common.jar:/system/framework/voip-common.jar:/system/framework/ims-common.jar:/system/framework/framework-atb-backward-compatibility.jar:/system/framework/telephony-ext.jar:/system/framework/WfdCommon.jar\"" >> "$CHROOT/etc/profile"
sed "/export DISPLAY=\":1\"/d" -i "$CHROOT/etc/profile"
echo "export DISPLAY=\":1\"" >> "$CHROOT/etc/profile"
sed "/export EXTERNAL_STORAGE=\"/d" -i "$CHROOT/etc/profile"
echo "export EXTERNAL_STORAGE=\"/sdcard/\"" >> "$CHROOT/etc/profile"
echo "Done"
