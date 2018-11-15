#!/bin/bash

set -o nounset
set -o pipefail

declare -r ERROR=1
declare -r SUCCESS=0

declare -r COUNT_PARAMS_REQ=1

function print_help {
    echo "(c) elsv-v.ru by Mikhail Vasilyev"
    echo
    echo "Usage as:"
    echo "  ./update-isp.sh <destination directory>"
    echo    
}

declare -r ERROR_EXISTS=1
declare -r ERROR_NOTHING=2

function print_error {
    error_type="${1}"
    
    case "${error_type}" in        
        "${ERROR_EXISTS}")
            file_name="${2}"
            echo "Directory ${data_path} not exists."
            ;;
        "${ERROR_NOTHING}")            
            echo "Nothing to do."
            ;;        
        *)
            echo "There is error with unknown type is ${error_type}"
            ;;
    esac
    
}

count_params="${#}"

if [ "${count_params}" -ne "${COUNT_PARAMS_REQ}" ]; then    
    print_help
    exit "${ERROR}"
fi

data_path="${1}"

if [ ! -d "${data_path}" ]; then
    print_error "${ERROR_EXISTS}" "${data_path}"
    exit "${ERROR}"
fi

start_path="$(pwd -P)"
tool_path="$(cd $(dirname "${0}"); pwd -P)"

fetch_cmd="${tool_path}/fetch-data.sh"

cd "${data_path}"

data_lic_file="${data_path}$("${fetch_cmd}" lic)"
status_fetch_lic="${?}"

data_net_zip_file="${data_path}$("${fetch_cmd}" net)"
status_fetch_net="${?}"

data_net_file="${data_net_zip_file:0:-4}.xml"

if [ "${status_fetch_net}" -eq "${SUCCESS}" ] && [ -f "${data_net_zip_file}" ]; then
    gzip -k -d -c -S '.zip' "${data_net_zip_file}" > "${data_net_file}"
fi

cd "${tool_path}"

declare -r CSV_LIC_FILE="${data_path}volgograd-isp-lic.csv"

if [ "${status_fetch_lic}" -eq "${SUCCESS}" ] && [ -f "${data_lic_file}" ]; then
    ./list-isp-lic.sh "${data_lic_file}" > "${CSV_LIC_FILE}"
fi

declare -r CSV_NET_FILE="${data_path}volgograd-isp-net.csv"

if [ -f "${data_net_file}" ]; then
    ./list-isp-net.sh "${data_net_file}" > "${CSV_NET_FILE}"
fi

declare -r CSV_ISP_FILE="${data_path}volgograd-isp.csv"
declare -r MD_ISP_FILE="${data_path}volgograd-isp.md"

if [ "${status_fetch_lic}" -eq "${SUCCESS}" ] || [ "${status_fetch_net}" -eq "${SUCCESS}" ]; then
    cat "${CSV_LIC_FILE}" "${CSV_NET_FILE}" | ./list-isp-all.sh > "${CSV_ISP_FILE}"
    ./make-md.sh "${CSV_ISP_FILE}" "${CSV_LIC_FILE}" | tail -n +2 > "${MD_ISP_FILE}"
else
    print_error "${ERROR_NOTHING}"
fi

cd "${start_path}"

exit "${SUCCESS}"
