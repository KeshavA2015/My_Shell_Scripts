#!/usr/bin/env bash

set -x -e

_SOURCE_CODES_DIR="${__SOURCE_CODES_PART__}/Source_Codes"

_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_common.sh"

_UDK_BUILD_OUTER_DIR="${_UDK_DIR}/Build/StdLib/"
_UDK_BUILD_DIR="${_UDK_BUILD_OUTER_DIR}/${_TARGET}_${_COMPILER}/"

_STDLIB_BUILD_DIR="${_BACKUP_BUILDS_DIR}/STDLIB_BUILD"

_COMPILE_STDLIB() {
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	cd "${_UDK_DIR}/"
	git checkout "${_MAIN_BRANCH}"
	
	echo
	
	# _COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_APPLY_PATCHES
	
	echo
	
	_APPLY_CHANGES
	
	echo
	
	_COMPILE_BASETOOLS_MANUAL
	
	echo
	
	"${EDK_TOOLS_PATH}/BinWrappers/PosixLike/build" -p "${_UDK_DIR}/StdLib/StdLib.dsc" -a "X64" -b "${_TARGET}" -t "${_COMPILER}"
	
	echo
	
	cp -rf "${_UDK_BUILD_DIR}" "${_STDLIB_BUILD_DIR}"
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	# _SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_STDLIB

echo

unset _SOURCE_CODES_DIR
unset _WD
unset _UDK_DIR
unset _UDK_BUILD_TOOLS_DIR
unset _UDK_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset _STDLIB_BUILD_DIR
unset _BACKUP_BUILDS_DIR
unset _MAIN_BRANCH

set +x +e
