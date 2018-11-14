#!/bin/bash

set -o nounset
set -o pipefail

declare -r ERROR=1
declare -r SUCCESS=0
declare -r COUNT_PARAMS_REQ=1

count_params="${#}"
if [ "${count_params}" -ne "${COUNT_PARAMS_REQ}" ]; then
    exit "${ERROR}"
fi

file_opendata="${1}"

declare -r GREP_NAMEONLY=":os_name>"
declare -r SED_CMD_CLEAN="clean-isp.sed"

echo "Name"
./find-isp-net.sh "${file_opendata}" | grep -i "${GREP_NAMEONLY}" | sed -n -f "${SED_CMD_CLEAN}" | LC_COLLATE=C sort -bfu

exit "${SUCCESS}"
