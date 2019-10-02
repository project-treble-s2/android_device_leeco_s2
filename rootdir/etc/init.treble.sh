#! /vendor/bin/sh

# common functions
symlink() {
	ln -sn $1 $2;
}

# mount system (which could be root or /system depending on ROM) and vendor as rw
mount -o remount,rw /
mount -o remount,rw /system
mount -o remount,rw /vendor


# symlink camera
symlink /vendor/etc/firmware/a530_pfp.fw /system/etc/firmware/a530_pfp.fw
symlink /vendor/etc/firmware/a530_pm4.fw /system/etc/firmware/a530_pm4.fw
symlink /vendor/etc/firmware/cpp_firmware_v1_5_0.fw /system/etc/firmware/cpp_firmware_v1_5_0.fw
symlink /vendor/etc/firmware/leia_pfp_470.fw /system/etc/firmware/leia_pfp_470.fw
symlink /vendor/etc/firmware/leia_pm4_470.fw /system/etc/firmware/leia_pm4_470.fw
symlink /vendor/etc/firmware/venus-v1.b00 /system/etc/firmware/venus-v1.b00
symlink /vendor/etc/firmware/venus-v1.b01 /system/etc/firmware/venus-v1.b01
symlink /vendor/etc/firmware/venus-v1.b02 /system/etc/firmware/venus-v1.b02
symlink /vendor/etc/firmware/venus-v1.b03 /system/etc/firmware/venus-v1.b03
symlink /vendor/etc/firmware/venus-v1.b04 /system/etc/firmware/venus-v1.b04
symlink /vendor/etc/firmware/venus-v1.mbn /system/etc/firmware/venus-v1.mbn
symlink /vendor/etc/firmware/venus-v1.mdt /system/etc/firmware/venus-v1.mdt
symlink /vendor/etc/firmware/venus.b00 /system/etc/firmware/venus.b00
symlink /vendor/etc/firmware/venus.b01 /system/etc/firmware/venus.b01
symlink /vendor/etc/firmware/venus.b02 /system/etc/firmware/venus.b02
symlink /vendor/etc/firmware/venus.b03 /system/etc/firmware/venus.b03
symlink /vendor/etc/firmware/venus.b04 /system/etc/firmware/venus.b04
symlink /vendor/etc/firmware/venus.mbn /system/etc/firmware/venus.mbn
symlink /vendor/etc/firmware/venus.mdt /system/etc/firmware/venus.mdt
symlink /vendor/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin /system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin
symlink /vendor/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv_nofem.bin /system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv_nofem.bin
if [ ! -d "/system/etc/firmware" ]; then mkdir /system/etc/firmware; fi
chmod 644 /system/etc/firmware
cd /vendor/etc/firmware/
for f in *; do
	symlink /vendor/etc/firmware/$f /system/etc/firmware/$f
done

# remount system and vendor as ro
mount -o remount,ro /
mount -o remount,ro /system
mount -o remount,ro /vendor
