#!/bin/bash

while getopts ":m:n:" opt; do
  case $opt in
    m ) METHOD=$OPTARG ;;
    n ) EXPORT_NAME=$OPTARG ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [[ $METHOD == 'put' ]] ; then
az rest --method put --url 'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/59232335/enrollmentAccounts/233705/providers/Microsoft.CostManagement/exports/'${EXPORT_NAME}'?api-version=2022-10-01' --body @../cost_management_export.json
elif [ $METHOD == 'post' ]; then
echo az rest --method post --url 'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/59232335/enrollmentAccounts/233705/providers/Microsoft.CostManagement/exports/'${EXPORT_NAME}'/run?api-version=2022-10-01'
fi