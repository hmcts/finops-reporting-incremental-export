#!/bin/bash
# Usage: Script.sh [subscription storage_account full_path_to_file ]

set -e
data_source="test_data_source"
subscription_name="DTS-SHAREDSERVICES-SBOX"
subscription_id="a8140a9e-f1b0-481f-a4de-09e2ee23f7ab"  
service_principal_app_id="c9f9bf69-1285-4857-8979-7f644e922918"
service_principal_secret="PbP8Q~loVsi3ypSSoPvG3RpHiYxVA2tL4SLSja3A"
tenant_id="531ff96d-0ae9-462a-8d2d-bec7c0b42082"
resource_group="finops-reporting-sbox-rg"
storage_account_name="finopsreportingincsbox"
container_name="test"
source_dir="."
source_file_name="test"
source_full_path="${source_dir}/${source_file_name}"
destination_path="$data_source/$(date +%y/%m/%d)" # This creates a /YY/MM/DD  folder structure to where the file will be uploaded eg: /23/06/14/[uploaded_file]
destination_filename="${data_source}-$(date +%y%m%d-%H%M%S).json"
destination_full_path=/${destination_path}/${destination_filename}

# echo ${destination_filename}
# echo ${destination_path}
# echo ${destination_full_path}
# exit



storage_account_key=$(az storage account keys list -g ${resource_group} -n ${storage_account_name} --query "[0].value" -o tsv)

echo "INFO: Setting extentions to install without prompt" # This was required in testing to ensure all needed az commands were installed if this isnt present the script waits for user input
az config set extension.use_dynamic_install=yes_without_prompt || { echo "ERROR: az config set fail"; exit 1; } 


# Log on and set subscription to work in 
echo "INFO: Log in to azure"
az login --service-principal -u ${service_principal_app_id} -p ${service_principal_secret} --tenant ${tenant_id} || { echo "ERROR: cant log in to az CLI"; exit 1; } 

echo "INFO: Set Azure Subscription to" ${subscription_name}
az account set --subscription $subscription_name || { echo "cant set subscription"; exit 1; } 

# Check subscription is the same as expected

if [[ $(az account show --query "[name]" -o tsv) != ${subscription_name} ]]  
    then
        echo "ERROR: Cannot verify were in correct subscription!"
        echo "INFO: Expecting:" ${subscription_name}
        echo "INFO: Returned:" $(az account show --query "[name]" -o tsv)
        exit 1
fi


# Check storage account is reachable

if [[ $( az storage account show -g $resource_group -n $storage_account_name --query "[statusOfPrimary]"  -o tsv) != "available" ]]
    then    
        echo "ERROR: Storage account status is not available"
        echo "INFO: Query returned -" $( az storage account show -g $resource_group -n $storage_account_name --query "[statusOfPrimary]"  -o tsv)
        exit 1
fi 

# Check Container is available
storage_account_key=$(az storage account keys list -g ${resource_group} -n ${storage_account_name} --query "[0].value" -o tsv)
if [[ $(az storage container exists --account-name=${storage_account_name} --name test --account-key ${storage_account_key} --query "[exists]" -o tsv) != "true" ]]
    then
        echo "ERROR: Failed to detect if Storage Account Container" ${container_name} "exists"
        exit 1
    fi
# Check source file is reachable
if [[ ! -f ${source_full_path} ]]
    then
        echo "Error: source file not reachable"
        exit 1
fi

echo "INFO: Starting upload of file" ${source_full_path}

# az storage blob upload --account-name={$storage_account_name} --connection-string "$(az storage account show-connection-string --name ${storage_account_name} --resource-group ${resource_group})" --container-name ${container_name} --file ${source_full_path} --destination-path ${destination_path} --name ${destination_filename}
# az storage blob directory upload --account-name={$storage_account_name} --connection-string "$(az storage account show-connection-string --name ${storage_account_name} --resource-group ${resource_group})" --container ${container_name} --source ${source_full_path} --destination-path ${destination_full_path}

# az storage fs directory create --name cmtest2 --file-system test --account-name finopsreportingincsbox --connection-string ${cs}  
# az storage fs directory list --file-system test --account-name finopsreportingincsbox --account-key $(az storage account keys list -g ${resource_group} -n ${storage_account_name} --query "[0].value" -o tsv)
az storage fs directory upload --file-system ${container_name} --account-name $storage_account_name --account-key $(az storage account keys list -g ${resource_group} -n ${storage_account_name} --query "[0].value" -o tsv) --destination-path ${destination_full_path} --source ${source_full_path} --recursive
if [[ $? -ne 0 ]]
    then
        echo "ERROR: upload failed!"
        exit 1
fi

echo "INFO: Complete"
