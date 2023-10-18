#!/bin/bash

set -o nounset
set -o pipefail

declare -r ERROR=1

declare -r SUCCESS=0

declare -r COUNT_PARAMS_REQ=1

declare -r BASE_URL='https://rkn.gov.ru/opendata/'
declare -r URL_FILE_NAME='meta.csv'

declare -r TYPE_LIC='lic'
declare -A LIST_DATA
LIST_DATA=(["${TYPE_LIC}"]='7705846236-LicComm')

declare -r CMD_CURL='curl -s'
declare -r CURL_GET='-O'
declare -r CURL_POST='-X POST'

declare -r CMD_GREP='grep -s -i -e'
declare -r GREP_DATA=',"'

function print_help {
    echo "(c) elsv-v.ru by Mikhail Vasilyev"
    echo
    echo "Usage as:"
    echo "  ./fetch-data.sh lic"
    echo
    echo "where:"
    echo "  lic - get license data"
    echo
}

declare -r ERROR_FETCH=1
declare -r ERROR_EXISTS=2

function print_error {
    error_type="${1}"
    
    case "${error_type}" in
        "${ERROR_FETCH}")
            echo "Could not get a list of data. It may be network or site error."
            ;;
        "${ERROR_EXISTS}")
            echo "Data file already up to date."
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

type_opendata="${1}"

if [ "${type_opendata}" != "${TYPE_LIC}" ]; then
    print_help
    exit "${ERROR}"
fi

url_type="${LIST_DATA["${type_opendata}"]}"

url_tree_data="${BASE_URL}${url_type}"

url_list_data="${url_tree_data}/${URL_FILE_NAME}"

data_file_name=$(${CMD_CURL} "${url_list_data}" | ${CMD_GREP} "${GREP_DATA}${url_tree_data/https:/http:}" | head -n 1 | cut -d '/' -f 6 | tr -d '"' | tr -d '\n\r')

status_data_file_name="${?}"

if [ "${status_data_file_name}" -ne "${SUCCESS}" ]; then
    print_error "${ERROR_FETCH}"
    exit "${ERROR}"
fi

if [ -f "${data_file_name}" ]; then
    print_error "${ERROR_EXISTS}"
    exit "${ERROR}"
fi

url_data="${url_tree_data}/${data_file_name}"

${CMD_CURL} ${CURL_GET} "${url_data}"

status_get_data="${?}"

if [ "${status_get_data}" -ne "${SUCCESS}" ]; then
    print_error "${ERROR_FETCH}"
    exit "${ERROR}"
fi

echo -n "${data_file_name}"

exit "${SUCCESS}"
