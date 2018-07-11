# Sample Shell scripts for Microsoft's Azure API

### Pre-requisites:

1. Tools already installed:
  * curl
  * jq
  * Azure Cli (v2.0) (az)

1. Existing user with enough permissions for creating Azure API access "Service Principal" for APPs

  Example:

  1. Create with Azure CLI (v2.0), having APP "get_billing_az" with secret: "modifythispass", "Reader" role with 1 year of valid login.
  (Note that script "create_app_login.sh" executes the following actions by asking needed info and creating azure_login.cfg):

  > $ az login # Log with your own credentials

  >$ az ad sp create-for-rbac --name get_billing_az --password modifythispass --role Reader --years 1 -o json

  1. Take note of tenant_id and app_id
  1. Modify APPs permissions [\*]:

[*] Reference: https://github.com/Azure/azure-docs-cli-python/blob/master/docs-ref-conceptual/create-an-azure-service-principal-azure-cli.md

---
ToDo:

  1. The user should be assigned to a custom role with access only to list resources, get price listing, get consumption (Current permissions: Reader).

  Restrictions should apply to /resources, /providers/Microsoft.Commerce/RateCard, /providers/Microsoft.Commerce/UsageAggregates

  1. Instead of using password, it's better to use certificates (Advanced).

---
For retrieving again the info from created Service Principal:

* #### Tenant Id. (It will show info about current logged account, including tenant id)
> az account list --output json --query '[].{Name:name, SubscriptionId:id, TenantId:tenantId}' | jq -r '.[].TenantId'

* #### App Id. (It will show your AppId assigned value)
> az ad sp list --display-name "<app_name>" | jq -r '.[].appId'

* #### For removing Service Principal Account:
> az ad sp delete --id <app_id>

* #### Subscription Id:

> az account list | jq -r '.[].id'

* #### azure_login.cfg format:

```
app_id="<your registered app id>"
client_secret="modifythispass"
subscription_id="<your subscription id>"
tenant_id="<your tenant id>"
```
 
References: https://medium.com/@mauridb/calling-azure-rest-api-via-curl-eb10a06127

----

### Available scripts:

* azure_list_all_resources.sh
* azure_ratecard.sh
* azure_resource_usage.sh
* create_app_login.sh
---
