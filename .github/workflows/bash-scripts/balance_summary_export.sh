#!/bin/bash
# script specific variables
working_dir=$(mktemp -d)
# IFS="|"
data_source="balance_summary"

# source file specific vars
source_dir="${working_dir}"
source_file_name="${data_source}-$(date -d-1m +"%y%m%d-%H%M%S").json"
source_full_path="${source_dir}/${filter}-${source_file_name}"

# destination speciifc vars
destination_path="$data_source/$(date -d-1m +"%Y-%m")" # This creates a /YY/MM folder structure for the previous month to where the file will be uploaded eg: /23/06/[uploaded_file]
destination_filename="${source_file_name}"
destination_full_path="/${destination_path}/${source_file_name}"
# destination_full_path="${source_file_name}"

# API specific vars
billing_period=$(date -d-1m +"%Y-%m") #We need last month 

# Log into Azure
# echo "INFO: Setting extentions to install without prompt" # This was required in testing to ensure all needed az commands were installed if this isnt present the script waits for user input
# az config set extension.use_dynamic_install=yes_without_prompt || { echo "ERROR: az config set fail"; exit 1; } 


echo "INFO: Interogate API start"
az rest --method get --url 'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/'${billing_account}'/billingPeriods/'${billing_period}'/providers/Microsoft.Consumption/balances?api-version=2023-03-01'  > ${source_full_path}
if [[ $? -ne 0 ]]
    then
        echo "ERROR: FAIL Exit code is:" $?
        exit 1
    else 
        echo "INFO: Interogate API end"
fi

# now upload to storage

if [[ -f .github/workflows/bash-scripts/storage_account_upload.sh ]]
    then
        source .github/workflows/bash-scripts/storage_account_upload.sh
        echo "upload to Storage Account: "${storage_account_name}" container:" ${container_name} " Path:"${destination_full_path}
        Upload_to_storage
    else
        echo "ERROR: cant find .github/workflows/bash-scripts/storage_account_upload.sh current path:"
        pwd
        echo "INFO: Tree out put"
        ls -R
        exit 1
    fi


