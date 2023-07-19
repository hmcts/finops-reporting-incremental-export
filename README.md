# finops-reporting-incremental-export

Github actions run on a cron schedule to run scripts that interogate Cost Management APIs and upload to a Storage Account.

- Balance by period runs on the 1st of every month for the previous months data
- Balance Summary export runs on the 1st of every month for the previous months data
- Cost management export currently only uploads the relevant export to the portal and then it needs to be started manually in the portal in cost management. This is due to needing admin rights to run the post section of the process.
- Reservation charges (reservation transactions API) runs on the 1st of every month for the previous months data
- Reservation recommendations runs daily at 00:10 to get the previous days data


## Deployment 
This repo is reliant on [finops-reporting-bulk-import](https://github.com/hmcts/finops-reporting-bulk-import) which builds the Storage account and sets the required permissions.

The App Registration needs the `Enterprise Reader` permission on the enrolment account for accessing the cost management api, it also needs contributor permissions to the Storage Account it will write to, and federated permissions to allow GitHub actions to run.

## Execution
The 5 APIs interogated all triggered by Cron within GitHub Actions

Each of these actions check out the repo on an agent then run the bash script to interrogate the specific api, a storage_account_upload script is sourced to complete the upload when the API interrogation has been completed.

These scripts use Github actions variables to populate the needed resource info.


