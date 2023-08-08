#!/bin/bash

# script specific variables
working_dir=$(mktemp -d)
IFS="|"
data_source="balance_by_period"
source functions.sh

# source file specific vars
source_dir="${working_dir}"
destination_path="$data_source/$(date_command -d '1 month ago' +"%Y/%m")" # This creates a /YY/MM folder structure for the previous month to where the file will be uploaded eg: /23/06/[uploaded_file]

# API specific vars
filter=("Single" "Shared") #array of possible api filters normally shared and single 
billing_period=$(date_command -d '1 month ago' +"%Y%m") #We need last month 



for filter in "${filter[@]}"
do
    
    source_file_name="${data_source}_${subscription_name}_${filter}_${billing_period}.json"
      
    base_url='https://management.azure.com/providers/Microsoft.Billing/billingAccounts/'${billing_account}'/billingPeriods/'${billing_period}'/providers/Microsoft.Consumption/balances?&api-version=2023-03-01'
    # testing echos
    echo "---- INFO: The URL being used is:"
    echo $base_url
    echo "----"
    source_full_path="${source_dir}/${source_file_name}"
    az rest --method get --url ${base_url} > ${source_full_path}
    # now upload to storage

    if [[ -f .github/workflows/bash-scripts/storage_account_upload.sh ]]
        then
            
            destination_full_path="/${destination_path}/${source_file_name}"
            echo "upload to Storage Account: "${storage_account_name}" container:" ${container_name} " Path:"${destination_full_path}
            source .github/workflows/bash-scripts/storage_account_upload.sh
            Upload_to_storage
        else
            echo "ERROR: cant find .github/workflows/bash-scripts/storage_account_upload.sh current path:"
            pwd
            echo "INFO: Tree out put"
            ls -R
            exit 1
    fi 


   
done


rm ${working_dir}/*
rmdir ${working_dir}