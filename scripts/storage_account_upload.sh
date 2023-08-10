#!/bin/bash
# Usage: source as a function

set -e

function Upload_to_storage(){

     # Check source file is reachable
    if [[ ! -f ${source_full_path} ]]
        then
            echo "Error: source file not reachable"
            echo "Trying to reach: " $source_full_path
            exit 1
    fi

    echo "INFO: Starting upload of file. Path: " ${source_full_path}
    echo "INFO: Container name is :" ${container_name}
    echo "INFO: Storage Account name is:" ${storage_account_name}
    echo "INFO: Resource Group name is :" ${resource_group}
    echo "INFO: Destination path is: " ${destination_full_path}
    # az storage fs directory upload --file-system ${container_name} --account-name ${storage_account_name} --account-key ${sa_key} --destination-path ${destination_full_path} --source ${source_full_path} --recursive
    az storage fs file upload --file-system ${container_name} --account-name ${storage_account_name} --account-key ${sa_key} --path ${destination_full_path} --source ${source_full_path} --overwrite true
    if [[ $? -ne 0 ]]
        then
            echo "ERROR: upload failed!"
            exit 1
    fi

    echo "INFO: Complete"

}