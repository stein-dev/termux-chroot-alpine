#!/system/bin/sh
set -e

CHROOT='/data/alpinetest'

echo "Mounting stuff..."
# Mounting
mount --rbind /dev "$CHROOT/dev"
mkdir -p "$CHROOT/dev/shm"
mkdir -p "$CHROOT/dev/binderfs"
# From Android 10, /apex is needed
cd /apex
for f in *; do
        mount --rbind "/apex/$f" "$CHROOT/apex/$f"
done
cd - 2>&1 > /dev/nul
mount -o bind /data/dalvik-cache "$CHROOT/data/dalvik-cache"
mount --rbind /vendor "$CHROOT/vendor"
mount --rbind /dev/pts "$CHROOT/dev/pts"
mount --rbind /dev/binderfs "$CHROOT/dev/binderfs"
mount -t tmpfs -o nosuid,nodev,noexec shm "$CHROOT/dev/shm"
mount --rbind /sys "$CHROOT/sys"
mount --rbind /system "$CHROOT/system"
mount --rbind /odm "$CHROOT/odm"
mount --rbind /linkerconfig "$CHROOT/linkerconfig"
mount --rbind /sdcard "$CHROOT/sdcard"
mount --rbind /proc "$CHROOT/proc"
mount -t tmpfs tmpfs "$CHROOT/tmp"
mount -o bind /data/data "$CHROOT/data/data"

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

unset LD_PRELOAD
unset PREFIX

echo "Done"
