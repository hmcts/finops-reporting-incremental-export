#!/bin/bash


subscription_id="b72ab7b7-723f-4b18-b6f6-03b0f2c6a1bb"
resource_group="finops-reporting-sbox-rg"
storage_account_name="finopsreportingsbox"
container_name="exports"
exports_path="TEST_EXPORTS_FOLDER"

data_source=cost_management_export
resource_id="/subscriptions/${subscription_id}/resourceGroups/${resource_group}/providers/Microsoft.Storage/storageAccounts/${storage_account_name}"
export_name="${data_source}-$(date +%Y-%m-%d-%H%M)"
# we need yesterdays date 
start_period=$(date  -d '1 day ago' +"%Y-%m-%d"T00:00:00+00:00Z)
end_period=$(date  -d '1 day ago' +"%Y-%m-%d"T23:59:59+00:00Z)

post_file_name="post-${export_name}.json"
source_file_name="${export_name}.json"
source_full_path=./${source_file_name}

# Build json file
jq \
  --arg r ${resource_id} \
  --arg c ${container_name} \
  --arg f ${start_period} \
  --arg e ${end_period} \
  --arg p ${exports_path}\
  '.properties.deliveryInfo.destination.resourceId = $r | .properties.deliveryInfo.destination.container = $c | .properties.deliveryInfo.destination.rootFolderPath = $p | .properties.definition.timePeriod.from = $f | .properties.definition.timePeriod.to = $e' .github/workflows/bash-scripts/cost_management_export.json > ./${post_file_name}


# put the new export
az rest --method put --url 'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/59232335/providers/Microsoft.CostManagement/exports/'${export_name}'?api-version=2022-10-01' --body @./${post_file_name}


# Currently the following does not work due to needing administrator role accross the tennent, therefore this part is actioned in the portal > cost management.

# post new export
# az rest --method post --url 'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/59232335/providers/Microsoft.CostManagement/exports/'${export_name}'?api-version=2022-10-01' > ${source_full_path}

# # need to add a cleanup once gone
# az rest --method delete --url 'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/59232335/providers/Microsoft.CostManagement/exports/'${export_name}'?api-version=2022-10-01'