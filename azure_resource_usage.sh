#!/bin/sh

# Our info for logging into Azure

. ./azure_login.cfg

# For billing purposes

ADALServiceURL="login.microsoftonline.com"
ARMBillingServiceURL="management.azure.com"
subscription_url="https://${ARMBillingServiceURL}/subscriptions"
resources_url="providers/Microsoft.Commerce/UsageAggregates"

# API version for calling Microsoft Azure API
api_version="2015-06-01-preview"

# Full URL (without filters)
api_url="${resources_url}?api-version=${api_version}"

# Date Format: "YYYY-MM-DD". Note that End time DOES NOT include data from the same day.
Start_time="2018-04-03"
End_time="2018-05-03"

filter="reportedStartTime=${Start_time}T00%3a00%3a00%2b00%3a00&reportedEndTime=${End_time}T00%3a00%3a00%2b00%3a00&aggregationGranularity=Daily&showDetails=false"

# Get token for later access

token=$(curl -s -X POST -d "grant_type=client_credentials&client_id=${app_id}&client_secret=${client_secret}&resource=https%3A%2F%2F${ARMBillingServiceURL}%2F" https://${ADALServiceURL}/${tenant_id}/oauth2/token | jq -r '.access_token')

# Retrieve info by calling Microsoft's Azure API

ms_api="${subscription_url}/${subscription_id}/${api_url}&${filter}"

curl -L -s -X GET -H "Authorization: Bearer ${token}" -H "Content-Type: application/json" ${ms_api}
