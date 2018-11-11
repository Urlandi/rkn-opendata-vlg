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

declare -r SED_CMD_CLEAN="clean-isp.sed"
declare -r SED_CMD_CONCAT="concat-isp-lic.sed"


echo "Name,Licence,Date Reg,License Type,Date Start,Date End"

./find-isp-lic.sh "${file_opendata}" | sed -n -f "${SED_CMD_CLEAN}" | sed -n -f "${SED_CMD_CONCAT}" | LC_COLLATE=C sort -bfu

exit "${SUCCESS}"
