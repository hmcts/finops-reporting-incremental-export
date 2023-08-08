#!/bin/bash

# script specific variables
working_dir=$(mktemp -d)
IFS="|"
data_source="reservation_recommendations"
source functions.sh
# source file specific vars
source_dir="${working_dir}"
source_file_name="${data_source}_${subscription_name}_$(date_command -d '1 day ago' +%y%m%d-%H%M%S).json"
# source_full_path="${source_dir}/${source_file_name}" # This is populated in the while loop for this script 

# destination speciifc vars
destination_path="$data_source/$(date_command -d '1 day ago' +%Y/%m/%d)" # This creates a /YY/MM/DD  folder structure to where the file will be uploaded eg: /23/06/14/[uploaded_file]
destination_filename="${source_file_name}"
# destination_full_path="/${destination_path}/${destination_filename}" #in this script this is populated in the while loop 

# API specific vars
filter=("Single" "Shared") #array of possible api filters normally shared and single 
look_back_period="Last1Days" #time to request data for 

# loop through the filters and interogate the api storing json locally

for filter in "${filter[@]}"
do
    
    source_full_path="${source_dir}/${filter}-${source_file_name}"
    base_url="https://management.azure.com/subscriptions/${subscription_id}/providers/Microsoft.Consumption/reservationRecommendations?\$filter=properties/scope eq '${filter}' AND properties/lookBackPeriod eq 'Last7Days'&api-version=2023-03-01"
    
    echo "INFO: Interogate API start"
    az rest --method get --url ${base_url} > ${source_full_path}

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
            destination_full_path="/${destination_path}/${data_source}_${subscription_name}_$(date_command -d '1 day ago' +%y%m%d-%H%M%S)_${filter}.json"
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
done



# cleanup 
rm ${working_dir}/*
rmdir ${working_dir}