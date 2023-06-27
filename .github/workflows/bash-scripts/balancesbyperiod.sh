#!/bin/bash

working_dir=$(mktemp -d)
billing_account="59232335"
# start_date="2022-10-01"
# end_date="2022-10-31"
billing_period="202305"
subscription_name="DTS-SHAREDSERVICES-SBOX"
subscription_id="a8140a9e-f1b0-481f-a4de-09e2ee23f7ab"  
filter=("Single" "Shared")
IFS="|"
for filter in "${filter[@]}"
do
    export_name="Reservationcharges_${subscription_name}_${filter}_${billing_period}.json"
    base_url="https://management.azure.com/providers/Microsoft.Billing/billingAccounts/${billing_account}/billingPeriods/'${billing_period}'/providers/Microsoft.Consumption/balances?&api-version=2023-03-01"
    base_command=$(az rest --method get --url ${base_url} > ${working_dir}/${export_name} )
    ${base_command}
done

# now upload to storage

rm ${working_dir}/*
rmdir ${working_dir}