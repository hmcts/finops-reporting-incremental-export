#!/bin/bash



# script specific variables
working_dir=$(mktemp -d)
IFS="|"
data_source="reservationRecommendations"

# Azure specific vars
subscription_name="DTS-SHAREDSERVICES-SBOX"
subscription_id="a8140a9e-f1b0-481f-a4de-09e2ee23f7ab"  
service_principal_app_id="c9f9bf69-1285-4857-8979-7f644e922918"
service_principal_secret=""
tenant_id="531ff96d-0ae9-462a-8d2d-bec7c0b42082"
resource_group="finops-reporting-sbox-rg"
storage_account_name="finopsreportingincsbox"
container_name="test"

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
billing_account="59232335"
start_date="2022-10-01"
end_date="2022-10-31"
look_back_period="Last1Days" #time to request data for 



# # Log into Azure
# echo "INFO: Setting extentions to install without prompt" # This was required in testing to ensure all needed az commands were installed if this isnt present the script waits for user input
# az config set extension.use_dynamic_install=yes_without_prompt || { echo "ERROR: az config set fail"; exit 1; } 


# # Log on and set subscription to work in 
# echo "INFO: Log in to azure"
# az login --service-principal -u ${service_principal_app_id} -p ${service_principal_secret} --tenant ${tenant_id} || { echo "ERROR: cant log in to az CLI"; exit 1; } 

# echo "INFO: Set Azure Subscription to" ${subscription_name}
# az account set --subscription $subscription_name || { echo "cant set subscription"; exit 1; } 

# # Check subscription is the same as expected

# if [[ $(az account show --query "[name]" -o tsv) != ${subscription_name} ]]  
#     then
#         echo "ERROR: Cannot verify were in correct subscription!"
#         echo "INFO: Expecting:" ${subscription_name}
#         echo "INFO: Returned:" $(az account show --query "[name]" -o tsv)
#         exit 1
# fi


# loop through the filters and interogate the api storing json locally

for filter in "${filter[@]}"
do
    
    source_full_path="${source_dir}/${filter}-${source_file_name}"
   
    base_url="https://management.azure.com/subscriptions/${subscription_id}/providers/Microsoft.Consumption/${data_source}?\$filter=properties/scope eq '${filter}' AND properties/lookBackPeriod eq '${look_back_period}'&api-version=2023-03-01"
    
    base_command=$(az rest --method get --url ${base_url} > ${source_full_path} )
    echo "INFO: Interogate API start"
    # ${base_command}
    echo "INFO: Interogate API end"
    # now upload to storage
    destination_full_path="/${destination_path}/${source_filename}"
    # source storage_account_upload.sh
    # Upload_to_storage
done



# cleanup 
rm ${working_dir}/*
rmdir ${working_dir}