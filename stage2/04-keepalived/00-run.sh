#!/bin/bash -e
install -v -m 644 files/trond.io.list      "${ROOTFS_DIR}/etc/apt/sources.list.d/trond.io.list"
on_chroot apt-key add - < files/debian-repo-public.gpg
