#!/bin/bash

# script specific variables
working_dir=$(mktemp -d)
IFS="|"
data_source="reservationchanges"

# source file specific vars
source_dir="${working_dir}"
source_file_name="${data_source}-$(date +%y%m%d-%H%M%S).json"
# source_full_path="${source_dir}/${source_file_name}" # This is populated in the while loop for this script 

# destination speciifc vars
destination_path="$data_source/$(date +%y/%m/%d)" # This creates a /YY/MM/DD  folder structure to where the file will be uploaded eg: /23/06/14/[uploaded_file]
destination_filename="${source_file_name}"
# destination_full_path="/${destination_path}/${destination_filename}" #in this script this is populated in the while loop 

# API specific vars
filter=("Single" "Shared") #array of possible api filters normally shared and single 
billing_period=$(date +%Y%m)


# billing_account=59232335
for filter in "${filter[@]}"
do
    export_name="Reservationcharges_${subscription_name}_${filter}_${billing_period}.json"
    base_url="https://management.azure.com/providers/Microsoft.Billing/billingAccounts/${billing_account}/billingPeriods/'${billing_period}'/providers/Microsoft.Consumption/balances?&api-version=2023-03-01"
    # testing echos
    echo "---- INFO: The URL being used is:"
    echo $base_url
    echo "----"
    # base_url="https://management.azure.com/providers/Microsoft.Billing/billingAccounts/${billing_account}/billingPeriods/'${billing_period}'/providers/Microsoft.Consumption/balances?&api-version=2023-03-01"
    az rest --method get --url ${base_url} ;exit # > ${working_dir}/${export_name}
    # now upload to storage

    if [[ -f .github/workflows/bash-scripts/storage_account_upload.sh ]]
        then
            source .github/workflows/bash-scripts/storage_account_upload.sh
            echo "upload to Storage Account: "${storage_account_name}" container:" ${container_name} " Path:"${destination_full_path}
            destination_full_path="/${destination_path}/${source_filename}"
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