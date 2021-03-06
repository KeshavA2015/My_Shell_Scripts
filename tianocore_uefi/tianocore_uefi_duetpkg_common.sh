#!/usr/bin/env bash

set -x -e

_SOURCE_CODES_DIR="${__SOURCE_CODES_PART__}/Source_Codes"

_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

_MAIN_BRANCH="Keshav_duetpkg"

source "${_WD}/tianocore_uefi_common.sh"

_UDK_DUETPKG_BOOTSECT_BIN_DIR="${_UDK_DIR}/DuetPkg/BootSector/bin/"
_UDK_BUILD_OUTER_DIR="${_UDK_DIR}/Build/DuetPkgX64/"
_UDK_BUILD_DIR="${_UDK_BUILD_OUTER_DIR}/${_TARGET}_${_COMPILER}/"

_DUETPKG_EMUVARIABLE_BUILD_DIR="${_BACKUP_BUILDS_DIR}/DUETPKG_EMUVARIABLE_BUILD"
_DUETPKG_FSVARIABLE_BUILD_DIR="${_BACKUP_BUILDS_DIR}/DUETPKG_FSVARIABLE_BUILD"
_DUETPKG_NVVARS_BUILD_DIR="${_BACKUP_BUILDS_DIR}/DUETPKG_NVVARS_BUILD"

_DUET_BUILDS_DIR="${_SOURCE_CODES_DIR}/Firmware/UEFI/Tianocore_UEFI_DUET_Builds/"
_UEFI_DUET_INSTALLER_DIR="${_DUET_BUILDS_DIR}/Tianocore_UEFI_DUET_Installer_GIT/"
_DUET_MEMDISK_COMPILED_DIR="${_DUET_BUILDS_DIR}/Tianocore_UEFI_DUET_memdisk_compiled_GIT/"
_DUET_MEMDISK_TOOLS_DIR="${_DUET_BUILDS_DIR}/Tianocore_UEFI_DUET_memdisk_tools_GIT/"

_MIGLE_BOOTDUET_COMPILE_DIR="${_SOURCE_CODES_DIR}/Firmware/UEFI/Tianocore_UEFI_DUET_3rd_Party_Projects/migle_BootDuet_GIT"
_ROD_SMITH_DUET_INSTALL_DIR="${_SOURCE_CODES_DIR}/Firmware/UEFI/Tianocore_UEFI_DUET_3rd_Party_Projects/Rod_Smith_duet-install_my_GIT"

_BOOTPART="/boot/"
_UEFI_SYS_PART="/efisys/"
_SYSLINUX_LIB_DIR="/usr/lib/syslinux"

_DUET_PART_PARTUUID="49c6d99c-2e29-4ea3-aa5e-f1447d9be7ce"
_DUET_PART_MP="/mnt/DUET"

_MIGLE_BOOTDUET_CLEAN() {
	
	echo
	
	cd "${_MIGLE_BOOTDUET_COMPILE_DIR}/"
	make clean
	
	echo
	
}

_MIGLE_BOOTDUET_COMPILE() {
	
	echo
	echo "Compiling Migle's BootDuet"
	echo
	
	_MIGLE_BOOTDUET_CLEAN
	
	echo
	
	cd "${_MIGLE_BOOTDUET_COMPILE_DIR}/"
	
	sed 's|Jump into EFILDR at 2000:0200|Jump into EFILDR at 2000:0000|g' -i "${_MIGLE_BOOTDUET_COMPILE_DIR}/BootDuet.S"
	sed 's|$0x2000,$0x0200|$0x2000,$0x0000|g' -i "${_MIGLE_BOOTDUET_COMPILE_DIR}/BootDuet.S"
	
	echo
	
	make
	make lba64
	make hardcoded-drive
	
	echo
	
}

_POST_DUET_MEMDISK() {
	
	echo
	
	"${_WD}/duetpkg_x86_64_create_memdisk_old.sh"
	
	echo
	
}

_COPY_MEMDISK_SYSLINUX_BOOTPART() {
	
	echo
	
	sudo rm -f "${_BOOTPART}/memdisk_syslinux" || true
	sudo install -D -m0644 "${_SYSLINUX_LIB_DIR}/memdisk" "${_BOOTPART}/memdisk"
	
	echo
	
}
