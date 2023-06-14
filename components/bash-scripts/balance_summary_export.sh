#!/bin/bash

while getopts ":p:" opt; do
  case $opt in
    p ) BILLING_PERIOD=$OPTARG ;;
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

az rest --method get --url 'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/59232335/billingPeriods/'${BILLING_PERIOD}'/providers/Microsoft.Consumption/balances?api-version=2023-03-01'