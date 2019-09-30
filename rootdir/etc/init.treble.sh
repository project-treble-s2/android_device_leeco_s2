#! /vendor/bin/sh

# common functions
symlink() {
	ln -sf $1 $2;
}

# mount system (which could be root or /system depending on ROM) and vendor as rw
mount -o remount,rw /
mount -o remount,rw /system
mount -o remount,rw /vendor

# symlink camera
symlink /vendor/etc/firmware /system/etc/firmware

# remount system and vendor as ro
mount -o remount,ro /
mount -o remount,ro /system
mount -o remount,ro /vendor
