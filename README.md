Deployment 
This repo is reliant on finops-reporting-bulk-import which builds the Storage account and sets the perms

The App Registration need special permissions given to it to access the cost management api, it also needs contributer permisions to the Storage Account it will write to, and federated perms to allow github actions to run.

Execution
There are 5 APIs interogated all triggered by Cron within GitHub Actions
Balance Summery Export Cost Management API
Balances By Period Cost Management API
Cost Management Export API
Reservation Charges Cost Management API
Reservation Recommendations API

Each of these actions check out the repo on an agent then run the bash script to interogate the specific api, a storage_account_upload script is sourced to complete the upload when the API interogation has been completed.

These scripts use Github actions variables to populate the needed resource info.

note currently the cost management api does not have enough permissions to run. 
