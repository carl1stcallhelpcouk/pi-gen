debug_log 8 "running dpkg -i ${SUB_STAGE_DIR}/files/*.deb on chroot"
cp -v ${SUB_STAGE_DIR}/files/code_1.50.1-1602600638_arm64.deb ${STAGE_WORK_DIR}/rootfs/tmp/
on_chroot <<EOF
    dpkg -i /tmp/code_1.50.1-1602600638_arm64.deb
EOF