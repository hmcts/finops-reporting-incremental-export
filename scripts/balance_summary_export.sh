#!/bin/bash
# script specific variables
working_dir=$(mktemp -d)
# IFS="|"
data_source="balance_summary"
source functions.sh

# API specific vars
billing_period=$(date_command -d '1 month ago' +"%Y%m") #We need last month 

# source file specific vars
source_dir="${working_dir}"
source_file_name="${data_source}_${subscription_name}_${billing_period}.json"
source_full_path="${source_dir}/${filter}-${source_file_name}"

# destination speciifc vars
destination_path="$data_source/$(date_command -d '1 month ago' +"%Y/%m")" # This creates a /YY/MM folder structure for the previous month to where the file will be uploaded eg: /23/06/[uploaded_file]
destination_filename="${source_file_name}"
destination_full_path="/${destination_path}/${source_file_name}"

# Log into Azure

echo "INFO: Interogate API start"

base_url='https://management.azure.com/providers/Microsoft.Billing/billingAccounts/'${billing_account}'/billingPeriods/'${billing_period}'/providers/Microsoft.Consumption/balances?api-version=2023-03-01'
 # testing echos
echo "---- INFO: The URL being used is:"
echo $base_url
echo "----"
echo "Billing period: ${billing_period}"    
az rest --method get --url ${base_url}  > ${source_full_path}
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


