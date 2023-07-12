#!/bin/bash

# script specific variables
working_dir=$(mktemp -d)
IFS="|"
data_source="reservation_charges"

# source file specific vars
source_dir="${working_dir}"
source_file_name="${data_source}-$(date +%y%m%d-%H%M%S).json"
source_full_path="${source_dir}/${source_file_name}" 

# destination speciifc vars
destination_path="$data_source/$(date +%y/%m/%d)" # This creates a /YY/MM/DD  folder structure to where the file will be uploaded eg: /23/06/14/[uploaded_file]
destination_filename="${source_file_name}"
# destination_full_path="/${destination_path}/${destination_filename}" #in this script this is populated in the while loop 

# API specific vars
filter=("Single" "Shared") #array of possible api filters normally shared and single 
# start_date="2022-10-01"
# end_date="2022-10-31"
# look_back_period="Last1Days" #time to request data for 
date_range_start=$(date +%Y"-"%m"-01")
date_range_end=$(date +%Y"-"%m"-29") # 29th is specified on purpose and the api should return the whole month if dates after 
export_name="${data_source}_${subscription_name}_${filter}_${start_date}-${end_date}.json"
# 'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/'${billing_account}'/providers/Microsoft.Consumption/reservationTransactions?$filter=properties/eventDate+ge+'${date_range_start}'+AND+properties/eventDate+le+'${date_range_end}'&api-version=2023-03-01'


az rest --method get --url 'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/'${billing_account}'/providers/Microsoft.Consumption/reservationTransactions?$filter=properties/eventDate+ge+'${date_range_start}'+AND+properties/eventDate+le+'${date_range_end}'&api-version=2023-03-01' > $source_full_path

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
        echo "upload to Storage Account: "${storage_account_name}" container:" ${container_name} " Path:"${destination_full_path}
        destination_full_path="/${destination_path}/${source_filename}"
        source .github/workflows/bash-scripts/storage_account_upload.sh
        Upload_to_storage
    else
        echo "ERROR: cant find .github/workflows/bash-scripts/storage_account_upload.sh current path:"
        pwd
        echo "INFO: Tree out put"
        ls -R
        exit 1
fi



rm ${working_dir}/*
rmdir ${working_dir} 
