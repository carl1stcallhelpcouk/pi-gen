#!/bin/bash -e

log (){
#	date +"[%T] $*" | tee -a "${LOG_FILE}"
#	date +"[%T] [${STAGE}] - ${*}" | tee -a "${LOG_FILE}"
	date +"[%T] [${STAGE}]/[${SUB_STAGE}] - ${*}" | tee -a "${LOG_FILE}"
}

export -f log

debug_log(){
#	set -x
	local LOG_LEVEL=${1:-0}
	local MSG="${*:-debugging}"
#	echo "LOG_LEVEL = ${LOG_LEVEL} DEBUG_LEVEL = ${DEBUG_LEVEL}"
	if [ ${LOG_LEVEL} -le ${DEBUG_LEVEL} ]; then
#		MSG="$(date +"%x %H:%M:%S") - ${MSG}"
		log "*DEBUG* ${MSG}" | tee -a "${WORK_DIR}/${DEBUG_LOG}"
	fi
#	set +x
}
export -f debug_log

show_progress(){
  echo -n "$0: Please wait..."
  while true
  do
    echo -n "."
    sleep 5
  done
}
export -f show_progress

bootstrap(){
	local BOOTSTRAP_CMD=debootstrap
	local BOOTSTRAP_ARGS=()

	#export http_proxy=${APT_PROXY}

	if [ "$(dpkg --print-architecture)" !=  "armhf" ] && [ "$(dpkg --print-architecture)" !=  "arm64" ]; then
		BOOTSTRAP_CMD=qemu-debootstrap
	fi

	BOOTSTRAP_ARGS+=(--arch "${ARCH}")
	BOOTSTRAP_ARGS+=(--include gnupg,ca-certificates)
	BOOTSTRAP_ARGS+=(--components "main,contrib,non-free")
	#BOOTSTRAP_ARGS+=(--keyring "${STAGE_DIR}/files/raspberrypi.gpg")
	BOOTSTRAP_ARGS+=("$@")
	printf -v BOOTSTRAP_STR '%q ' "${BOOTSTRAP_ARGS[@]}"

	debug_log 6 "Running '${BOOTSTRAP_CMD} ${BOOTSTRAP_STR}'"
	capsh --drop=cap_setfcap -- -c "'${BOOTSTRAP_CMD}' $BOOTSTRAP_STR" || true

	if [ -d "$2/debootstrap" ]; then
		rmdir "$2/debootstrap"
	fi
}
export -f bootstrap

copy_previous(){
	debug_log 5 "PREV_ROOTFS - ${PREV_ROOTFS_DIR}"
	if [ ! -d "${PREV_ROOTFS_DIR}" ]; then
		echo "Previous stage rootfs not found"
		false
	fi
#	show_progress &
#	PROGRESS_PID=$!
	mkdir -p "${ROOTFS_DIR}"
	debug_log 8 "Copying ${PREV_ROOTFS_DIR}/ > ${ROOTFS_DIR}/"
	rsync -aHAXx --exclude var/cache/apt/archives --info=progress2 "${PREV_ROOTFS_DIR}/" "${ROOTFS_DIR}/"
#	kill ${PROGRESS_PID} >/dev/null 2>&1
#	echo -n "...done."
}
export -f copy_previous

unmount(){
	if [ -z "$1" ]; then
		DIR=$PWD
	else
		DIR=$1
	fi

	while mount | grep -q "$DIR"; do
		local LOCS
		LOCS=$(mount | grep "$DIR" | cut -f 3 -d ' ' | sort -r)
		for loc in $LOCS; do
			umount "$loc"
		done
	done
}
export -f unmount

unmount_image(){
	sync
	sleep 1
	local LOOP_DEVICES
	LOOP_DEVICES=$(losetup --list | grep "$(basename "${1}")" | cut -f1 -d' ')
	for LOOP_DEV in ${LOOP_DEVICES}; do
		if [ -n "${LOOP_DEV}" ]; then
			local MOUNTED_DIR
			MOUNTED_DIR=$(mount | grep "$(basename "${LOOP_DEV}")" | head -n 1 | cut -f 3 -d ' ')
			if [ -n "${MOUNTED_DIR}" ] && [ "${MOUNTED_DIR}" != "/" ]; then
				unmount "$(dirname "${MOUNTED_DIR}")"
			fi
			sleep 1
			losetup -d "${LOOP_DEV}"
		fi
	done
}
export -f unmount_image

on_chroot() {
	if ! mount | grep -q "$(realpath "${ROOTFS_DIR}"/proc)"; then
		mount -t proc proc "${ROOTFS_DIR}/proc"
	fi

	if ! mount | grep -q "$(realpath "${ROOTFS_DIR}"/dev)"; then
		mount --bind /dev "${ROOTFS_DIR}/dev"
	fi
	
	if ! mount | grep -q "$(realpath "${ROOTFS_DIR}"/dev/pts)"; then
		mount --bind /dev/pts "${ROOTFS_DIR}/dev/pts"
	fi

	if ! mount | grep -q "$(realpath "${ROOTFS_DIR}"/sys)"; then
		mount --bind /sys "${ROOTFS_DIR}/sys"
	fi

	setarch linux32 capsh --drop=cap_setfcap "--chroot=${ROOTFS_DIR}/" -- -e "$@"
}
export -f on_chroot

update_issue() {
	echo -e "Raspberry Pi reference ${IMG_DATE}\nGenerated using ${PI_GEN}, ${PI_GEN_REPO}, ${GIT_HASH}, ${1}" > "${ROOTFS_DIR}/etc/rpi-issue"
}
export -f update_issue
