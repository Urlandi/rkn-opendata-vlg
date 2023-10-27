#!/bin/env bash

set -o nounset
set -o pipefail

declare -r ERROR=1
declare -r SUCCESS=0

declare -r COUNT_PARAMS_REQ=1

function print_help {
    echo "(c) elsv-v.ru by Mikhail Vasilyev"
    echo
    echo "Usage as:"
    echo "  ./make-md.sh <isp lic list file>"
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
    isp_data_line=$(grep -E "^${name_isp}," "${file_isp_lic}" | cut -d , -f 2-)    
    
    if [ -n "${isp_data_line}" ]; then

        while read -r isp_data; do

            isp_lic=$(echo "${isp_data}" | cut -d , -f 4-)
	    isp_lic_num=$(echo "${isp_data}" | cut -d , -f 1)
            
	    isp_end_date=$(echo "${isp_data}" | cut -d , -f 3 | cut -d- -f 1)        
            
            if [ "${year}" -ge "${isp_end_date}" ]; then
                echo "    - <span style="color:red">${isp_lic_num}, ${isp_lic}</span>"
            else
                echo "    - ${isp_lic_num}, ${isp_lic}"
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

file_isp_lic="${1}"

if [ ! -f "${file_isp_lic}" ]; then
    print_error "${ERROR_EXISTS}" "${file_isp_lic}"
    exit "${ERROR}"
fi

year=$(date +"%Y")


# Very slowly, but work. Need rewrite to sed

while read name_isp
    do
    format_md "${name_isp}"
done < <(cut -d , -f 1 "${file_isp_lic}" | sort -bfu)

status_format="${?}"

if [ "${status_format}" -ne "${SUCCESS}" ]; then
    print_error "${ERROR_FORMAT}"
    exit "${ERROR}"
fi

exit "${SUCCESS}"
