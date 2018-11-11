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

declare -r DEFINE_TERRITORY="territory>.*волгоград"
declare -r DEFINE_LICENSE="kind_description>.*(данных, за исключением|телемати)"

grep -B 7 -iE "${DEFINE_TERRITORY}" "${file_opendata}" | grep -B 4 -A 3 -iE "${DEFINE_LICENSE}"

exit "${SUCCESS}"
