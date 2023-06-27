#!/bin/bash
# script specific variables
working_dir=$(mktemp -d)
# IFS="|"
data_source="balanceSummary"

# source file specific vars
source_dir="${working_dir}"
source_file_name="${data_source}-$(date +%y%m%d-%H%M%S).json"
source_full_path="${source_dir}/${filter}-${source_file_name}"

# destination speciifc vars
destination_path="$data_source/$(date +%y/%m/%d)" # This creates a /YY/MM/DD  folder structure to where the file will be uploaded eg: /23/06/14/[uploaded_file]
destination_filename="${source_file_name}"

# destination_full_path="/${destination_path}/${destination_filename}" #in this script this is populated in the while loop 

# API specific vars
# filter=("Single" "Shared") #array of possible api filters normally shared and single 
billing_period=$(date +%Y%m)
# start_date="2022-10-01"
# end_date="2022-10-31"
# look_back_period="Last1Days" #time to request data for 

# Log into Azure
echo "INFO: Setting extentions to install without prompt" # This was required in testing to ensure all needed az commands were installed if this isnt present the script waits for user input
az config set extension.use_dynamic_install=yes_without_prompt || { echo "ERROR: az config set fail"; exit 1; } 


# echo "INFO: Set Azure Subscription to" ${subscription_name}
# az account set --subscription $subscription_name || { echo "cant set subscription"; exit 1; } 

# Check subscription is the same as expected

if [[ $(az account show --query "[name]" -o tsv) != ${subscription_name} ]]  
    then
        echo "ERROR: Cannot verify were in correct subscription!"
        echo "INFO: Expecting:" ${subscription_name}
        echo "INFO: Returned:" $(az account show --query "[name]" -o tsv)
        exit 1
fi

echo "INFO: Interogate API start"
az rest --method get --url 'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/'${billing_account}'/billingPeriods/'${billing_period}'/providers/Microsoft.Consumption/balances?api-version=2023-03-01'  > ${source_full_path}
echo "INFO: Interogate API end"
ls ${source_full_path}

# now upload to storage
destination_full_path="/${destination_path}/${source_file_name}"
source storage_account_upload.sh
echo "upload to Storage Account: "${storage_account_name}" container:" ${container_name} " Path:"${destination_full_path}
Upload_to_storage

