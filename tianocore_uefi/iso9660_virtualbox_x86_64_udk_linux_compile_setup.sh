#!/bin/bash

set -x -e

_SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_duet_common.sh"

_UDK_BUILD_OUTER_DIR="${_UDK_DIR}/Build/StdLib/"
_UDK_BUILD_DIR="${_UDK_BUILD_OUTER_DIR}/DEBUG_GCC45/"

_ISO9660_BUILD_DIR="${_BACKUP_BUILDS_DIR}/ISO9660_BUILD"

_COMPILE_ISO9660() {
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	cd "${_UDK_DIR}/"
	git checkout keshav_pr
	
	echo
	
	_COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_CORRECT_WERROR
	
	echo
	
	_APPLY_PATCHES
	
	echo
	
	_APPLY_CHANGES
	
	echo
	
	_COMPILE_BASETOOLS_MANUAL
	
	echo
	
	sed -i 's|TARGET_ARCH           = IA32|TARGET_ARCH           = X64|g' "${_UDK_DIR}/Conf/target.txt"
	sed -i 's|ACTIVE_PLATFORM       = Nt32Pkg/Nt32Pkg.dsc|ACTIVE_PLATFORM       = DuetPkg/DuetPkgX64.dsc|g' "${_UDK_DIR}/Conf/target.txt"
	
	echo
	
	build -p "${_UDK_DIR}/DuetPkg/DuetPkgX64.dsc" -m "${_UDK_DIR}/VBoxPkg/VBoxFsDxe/VBoxIso9660.inf" -a X64 -b RELEASE -t GCC45
	
	echo
	
	cp -r "${_UDK_BUILD_DIR}" "${_ISO9660_BUILD_DIR}"
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	_SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_ISO9660

echo

unset _SOURCE_CODES_DIR
unset _WD
unset _UDK_DIR
unset _UDK_BUILD_TOOLS_DIR
unset _UDK_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset _ISO9660_BUILD_DIR
unset _BACKUP_BUILDS_DIR

set +x +e
