#!/bin/bash -e

install -m 644 files/cmdline.txt "${ROOTFS_DIR}/boot/"
install -m 644 files/config.txt "${ROOTFS_DIR}/boot/"

debug_log 8 "Checking ${ARCH} in ${ROOTFS_DIR}/boot/config.txt"

if [ "${ARCH}" = "arm64" ]; then
    debug_log 8 "Setting arm_64bit=1 & arm_freq=2200 in ${ROOTFS_DIR}/boot/config.txt"
    sed -i 's/^#arm_64bit=1/arm_64bit=1/' "${ROOTFS_DIR}/boot/config.txt"
    sed -i 's/^arm_freq=/c\arm_freq=2200/' "${ROOTFS_DIR}/boot/config.txt"
elif [ "${ARCH}" = "armhf" ]; then
    debug_log 8 "Setting #arm_64bit=1 & arm_freq=1200 in ${ROOTFS_DIR}/boot/config.txt"
    sed -i 's/^arm_64bit=1/#arm_64bit=1/' "${ROOTFS_DIR}/boot/config.txt"
    sed -i 's/^arm_freq=/c\arm_freq=1200/' "${ROOTFS_DIR}/boot/config.txt"
else
    debug_log 8 "Not updating ${ROOTFS_DIR}/boot/config.txt"
fi
#read -p "Press [enter] to continue..."