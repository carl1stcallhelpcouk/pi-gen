#!/bin/bash -e

install -vm 644 files/sources.list_${ARCH} "${ROOTFS_DIR}/etc/apt/sources.list"
install -vm 644 files/raspi.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
#install -vm 644 files/headmelted_vscode.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
install -vm 644 files/nodesource.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"

sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list"
sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/raspi.list"
sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/nodesource.list"

if [ -n "$APT_PROXY" ]; then
	install -m 644 files/51cache "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
	sed "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache" -i -e "s|APT_PROXY|${APT_PROXY}|"
else
	rm -f "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
fi

on_chroot apt-key add - < files/raspberrypi.gpg.key
#on_chroot apt-key add - < files/headmelted-code-oss-0CC3FD642696BFC8.pub.gpg
on_chroot apt-key add - < files/nodesource.gpg.key
debug_log 8 "Attempting to configure locales"
on_chroot << EOF
export LC_ALL="C"
#export 
dpkg --add-architecture armhf
apt-get update
apt-get dist-upgrade -y
EOF
debug_log 9 "Configureation of locales compleated."