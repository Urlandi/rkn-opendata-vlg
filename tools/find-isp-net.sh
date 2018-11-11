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

declare -r DEFINE_TERRITORY="region_code>34<"

declare -r DEFINE_ISTM="is_tm>1<"
declare -r DEFINE_NOTTM="is_tm>0<"
declare -r DEFINE_ISPD="is_pd>1<"


grep -B 3 -A 38  "${DEFINE_TERRITORY}" "${file_opendata}" | grep -B 18 -A 23 "${DEFINE_ISTM}"
grep -B 3 -A 38  "${DEFINE_TERRITORY}" "${file_opendata}" | grep -B 13 -A 29 "${DEFINE_ISPD}" | grep -B 18 -A 23 "${DEFINE_NOTTM}"


exit "${SUCCESS}"
