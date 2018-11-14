#!/bin/bash

set -o nounset
set -o pipefail

declare -r ERROR=1
declare -r SUCCESS=0

declare -r COUNT_PARAMS_REQ=2

function print_help {
    echo "(c) elsv-v.ru by Mikhail Vasilyev"
    echo
    echo "Usage as:"
    echo "  ./make-md.sh <isp list file> <isp lic list file>"
    echo    
}

declare -r ERROR_EXISTS=1
declare -r ERROR_FORMAT=2

function print_error {
    error_type="${1}"
    
    case "${error_type}" in        
        "${ERROR_EXISTS}")
            file_name="${2}"
            echo "File ${file_name} not exists."
            ;;
        "${ERROR_FORMAT}")        
            echo "Formatting text error."
            ;;
        *)
            echo "There is error with unknown type is ${error_type}"
            ;;
    esac
    
}

function format_md {    
    name_isp="${1}"    

    echo "1. ${name_isp}"
    isp_data_line=$(grep -E "^\"${name_isp}\"" "${file_isp_lic}" | cut -d , -f 2,4-)    
    
    if [ -n "${isp_data_line}" ]; then

        while read -r isp_data; do

            isp_lic=$(echo "${isp_data}" | rev | cut -d , -f 3- | rev)
            
            isp_end_date=$(echo "${isp_data}" | rev | cut -d , -f 1 | cut -d- -f 3 | rev)        
            
            if [ "${year}" -ge "${isp_end_date}" ]; then
                echo "    - <span style="color:red">${isp_lic}</span>"
            else
                echo "    - ${isp_lic}"
            fi
        done < <(echo "${isp_data_line}")        
    fi

    return "${SUCCESS}"
}

count_params="${#}"

if [ "${count_params}" -ne "${COUNT_PARAMS_REQ}" ]; then    
    print_help
    exit "${ERROR}"
fi

file_all_isp="${1}"
file_isp_lic="${2}"

if [ ! -f "${file_all_isp}" ]; then
    print_error "${ERROR_EXISTS}" "${file_all_isp}"
    exit "${ERROR}"
fi

if [ ! -f "${file_isp_lic}" ]; then
    print_error "${ERROR_EXISTS}" "${file_isp_lic}"
    exit "${ERROR}"
fi

year=$(date +"%Y")


# Very slowly, but work. Need rewrite to sed

while read -r name_isp; do
    format_md "${name_isp}"
done<"${file_all_isp}"

status_format="${?}"

if [ "${status_format}" -ne "${SUCCESS}" ]; then
    print_error "${ERROR_FORMAT}"
    exit "${ERROR}"
fi

exit "${SUCCESS}"
