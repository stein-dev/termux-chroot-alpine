#!/system/bin/sh
set -e

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

CHROOT='/data/alpinetest'

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

echo "Setting up environment variables"
echo "
export ANDROID_ART_ROOT=/apex/com.android.art
export ANDROID_DATA=/data
export ANDROID_I18N_ROOT=/apex/com.android.i18n
export ANDROID_ROOT=/system
export ANDROID_RUNTIME_ROOT=
export ANDROID_TZDATA_ROOT=/apex/com.android.tzdata
export BOOTCLASSPATH=/apex/com.android.art/javalib/core-oj.jar:/apex/com.android.art/javalib/core-libart.jar:/apex/com.android.art/javalib/core-icu4j.jar:/apex/com.android.art/javalib/okhttp.jar:/apex/com.android.art/javalib/bouncycastle.jar:/apex/com.android.art/javalib/apache-xml.jar:/system/framework/framework.jar:/system/framework/ext.jar:/system/framework/telephony-common.jar:/system/framework/voip-common.jar:/system/framework/ims-common.jar:/system/framework/framework-atb-backward-compatibility.jar:/system/framework/telephony-ext.jar:/system/framework/WfdCommon.jar:/apex/com.android.conscrypt/javalib/conscrypt.jar:/apex/com.android.media/javalib/updatable-media.jar:/apex/com.android.mediaprovider/javalib/framework-mediaprovider.jar:/apex/com.android.os.statsd/javalib/framework-statsd.jar:/apex/com.android.permission/javalib/framework-permission.jar:/apex/com.android.sdkext/javalib/framework-sdkextensions.jar:/apex/com.android.wifi/javalib/framework-wifi.jar:/apex/com.android.tethering/javalib/framework-tethering.jar
export COLORTERM=truecolor
export DEX2OATBOOTCLASSPATH=/apex/com.android.art/javalib/core-oj.jar:/apex/com.android.art/javalib/core-libart.jar:/apex/com.android.art/javalib/core-icu4j.jar:/apex/com.android.art/javalib/okhttp.jar:/apex/com.android.art/javalib/bouncycastle.jar:/apex/com.android.art/javalib/apache-xml.jar:/system/framework/framework.jar:/system/framework/ext.jar:/system/framework/telephony-common.jar:/system/framework/voip-common.jar:/system/framework/ims-common.jar:/system/framework/framework-atb-backward-compatibility.jar:/system/framework/telephony-ext.jar:/system/framework/WfdCommon.jar
export EXTERNAL_STORAGE=/sdcard
[ -z '$LANG' ] && export LANG=C.UTF-8
export PATH=${PATH}:/data/data/com.termux/files/usr/bin:/system/bin:/system/xbin
export TERM=xterm-256color
export TMPDIR=/tmp
export PULSE_SERVER=127.0.0.1
export MOZ_FAKE_NO_SANDBOX=1
" >> $CHROOT/etc/profile.d/termux-proot.sh
# sed "/export ANDROID_DATA=\"\/data\"/d" -i "$CHROOT/etc/profile"
# echo "export ANDROID_DATA=\"/data\"" >> "$CHROOT/etc/profile"
# sed "/export ANDROID_ROOT=\"\/system\"/d" -i "$CHROOT/etc/profile"
# echo "export ANDROID_ROOT=\"/system\"" >> "$CHROOT/etc/profile"
# sed "/export ANDROID_ART_ROOT=\"\/apex\/com.android.art\"/d" -i "$CHROOT/etc/profile"
# echo "export ANDROID_ART_ROOT=\"/apex/com.android.art\"" >> "$CHROOT/etc/profile"
# sed "/export ANDROID_RUNTIME_ROOT=\"\/apex\/com.android.runtime\"/d" -i "$CHROOT/etc/profile"
# echo "export ANDROID_RUNTIME_ROOT=\"/apex/com.android.runtime\"" >> "$CHROOT/etc/profile"
# sed "/export ANDROID_I18N_ROOT=\"\/apex\/com.android.i18n\"/d" -i "$CHROOT/etc/profile"
# echo "export ANDROID_I18N_ROOT=\"/apex/com.android.i18n\"" >> "$CHROOT/etc/profile"
# sed "/export ANDROID_TZDATA_ROOT=\"\/apex\/com.android.tzdata\"/d" -i "$CHROOT/etc/profile"
# echo "export ANDROID_TZDATA_ROOT=\"/apex/com.android.tzdata\"" >> "$CHROOT/etc/profile"
# sed "/export BOOTCLASSPATH=\"/d" -i "$CHROOT/etc/profile"
# echo "export BOOTCLASSPATH=\"/apex/com.android.art/javalib/core-oj.jar:/apex/com.android.art/javalib/core-libart.jar:/apex/com.android.art/javalib/core-icu4j.jar:/apex/com.android.art/javalib/okhttp.jar:/apex/com.android.art/javalib/bouncycastle.jar:/apex/com.android.art/javalib/apache-xml.jar:/system/framework/framework.jar:/system/framework/ext.jar:/system/framework/telephony-common.jar:/system/framework/voip-common.jar:/system/framework/ims-common.jar:/system/framework/framework-atb-backward-compatibility.jar:/system/framework/telephony-ext.jar:/system/framework/WfdCommon.jar:/apex/com.android.conscrypt/javalib/conscrypt.jar:/apex/com.android.media/javalib/updatable-media.jar:/apex/com.android.mediaprovider/javalib/framework-mediaprovider.jar:/apex/com.android.os.statsd/javalib/framework-statsd.jar:/apex/com.android.permission/javalib/framework-permission.jar:/apex/com.android.sdkext/javalib/framework-sdkextensions.jar:/apex/com.android.wifi/javalib/framework-wifi.jar:/apex/com.android.tethering/javalib/framework-tethering.jar\"" >> "$CHROOT/etc/profile"
# sed "/export DEX2OATBOOTCLASSPATH=\"/d" -i "$CHROOT/etc/profile"
# echo "export DEX2OATBOOTCLASSPATH=\"/apex/com.android.art/javalib/core-oj.jar:/apex/com.android.art/javalib/core-libart.jar:/apex/com.android.art/javalib/core-icu4j.jar:/apex/com.android.art/javalib/okhttp.jar:/apex/com.android.art/javalib/bouncycastle.jar:/apex/com.android.art/javalib/apache-xml.jar:/system/framework/framework.jar:/system/framework/ext.jar:/system/framework/telephony-common.jar:/system/framework/voip-common.jar:/system/framework/ims-common.jar:/system/framework/framework-atb-backward-compatibility.jar:/system/framework/telephony-ext.jar:/system/framework/WfdCommon.jar\"" >> "$CHROOT/etc/profile"
# sed "/export DISPLAY=\":1\"/d" -i "$CHROOT/etc/profile"
# echo "export DISPLAY=\":1\"" >> "$CHROOT/etc/profile"
# sed "/export EXTERNAL_STORAGE=\"/d" -i "$CHROOT/etc/profile"
# echo "export EXTERNAL_STORAGE=\"/sdcard/\"" >> "$CHROOT/etc/profile"

# unset LD_PRELOAD
unset PREFIX

echo "Done"

busybox chroot $CHROOT /bin/sh --login

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