## Function

Github actions run on a cron schedule to run scripts that interogate Cost Management APIs and upload to a Storage Account.

- Balance by period runs on the 1st of every month for the previous months data
- Balance Summary export runs on the 1st of every month for the previous months data
- Cost management export currently only uploads the relevant export to the portal and then it needs to be started manually in the portal in cost management. This is due to needing admin rights to run the post section of the process.
- Reservation charges (reservation transactions API) runs on the 1st of every month for the previous months data
- Reservation recommendations runs daily at 00:10 to get the previous days data


## Deployment 
This repo is reliant on finops-reporting-bulk-import which builds the Storage account and sets the perms

The App Registration need special permissions given to it to access the cost management api, it also needs contributer permisions to the Storage Account it will write to, and federated perms to allow github actions to run.

## Execution
The 5 APIs interogated all triggered by Cron within GitHub Actions

Each of these actions check out the repo on an agent then run the bash script to interogate the specific api, a storage_account_upload script is sourced to complete the upload when the API interogation has been completed.

These scripts use Github actions variables to populate the needed resource info.


