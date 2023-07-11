#!/bin/bash
# Usage: source as a function

set -e

function Upload_to_storage(){

    # storage_account_key=$(az storage account keys list -g ${resource_group} -n ${storage_account_name} --query "[0].value" -o tsv)

    # Check storage account is reachable

    # if [[ $( az storage account show -g $resource_group -n $storage_account_name --query "[statusOfPrimary]"  -o tsv) != "available" ]]
    #     then    
    #         echo "ERROR: Storage account status is not available"
    #         echo "INFO: Query returned -" $( az storage account show -g $resource_group -n $storage_account_name --query "[statusOfPrimary]"  -o tsv)
    #         exit 1
    # fi 

    # Check Container is available
    # storage_account_key=$(az storage account keys list -g ${resource_group} -n ${storage_account_name} --query "[0].value" -o tsv)
    # if [[ $(az storage container exists --account-name=${storage_account_name} --name test --account-key ${storage_account_key} --query "[exists]" -o tsv) != "true" ]]
    #     then
    #         echo "ERROR: Failed to detect if Storage Account Container" ${container_name} "exists"
    #         exit 1
    #     fi

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
    az storage fs directory upload --file-system ${container_name} --account-name ${storage_account_name} --account-key $(sa_key} --destination-path ${destination_full_path} --source ${source_full_path} --recursive
    
    if [[ $? -ne 0 ]]
        then
            echo "ERROR: upload failed!"
            exit 1
    fi

    echo "INFO: Complete"

}