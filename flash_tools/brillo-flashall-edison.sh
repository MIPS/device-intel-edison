#!/bin/bash

# Only execute this script on a Brillo provisioned Edison.
# See your Brillo-Edison online information for initial provisioning and recovery.

set -e

function dir_with_file() {
    local file=${1}; shift
    local dir;
    for dir; do
        if [ -z "${dir}" ]; then continue; fi
        if [ -r "${dir}/${file}" ]; then
            echo ${dir}
            return
        fi
    done
    echo "Could not find ${file}, looked in $@" >&2
    return 1
}

LOCAL_DIR=$(dirname "${0}")

# Location of where the Brillo OS image is built.
_EDISON_IMG_DIR=$(dir_with_file boot.img \
    "${LOCAL_DIR}" \
    "${BRILLO_OUT_DIR}" \
    "${ANDROID_PRODUCT_OUT}")

# Location of binary blobs supplied by the vendor.
_EDISON_UBOOT_DIR=$(dir_with_file u-boot-edison.bin \
    "${LOCAL_DIR}" \
    "${ANDROID_BUILD_TOP}/device/intel/edison/uboot_firmware")

fastboot flash gpt     "${_EDISON_IMG_DIR}"/gpt.bin \
	flash u-boot   "${_EDISON_UBOOT_DIR}"/u-boot-edison.bin \
	flash boot_a   "${_EDISON_IMG_DIR}"/boot.img \
	flash system_a "${_EDISON_IMG_DIR}"/system.img \
	flash data     "${_EDISON_IMG_DIR}"/userdata.img
fastboot oem set_active 0
