#!/bin/bash -e
# Standaard pi-gen stage-prerun: neem de rootfs van de vorige stage over.
if [ ! -d "${ROOTFS_DIR}" ]; then
	copy_previous
fi
