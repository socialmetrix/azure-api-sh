#!/bin/sh

# Our info for logging into Azure

. ./azure_login.cfg

# Your offer id. Retrieved via <Azure Portal>->Admin Account->View My Bill->Overview->My Subscriptions->[your subscription]->Overview
# Retrieve the proper name from: https://azure.microsoft.com/en-us/support/legal/offer-details/
#
# Modify the following as needed
#
# This offer id is "Pay-As-You-Go". You should adjust this properly to your offer id.
offer_id="MS-AZR-0003P"

currency="USD"
locale="en-US"
Region="US"

# For billing purposes

ADALServiceURL="login.microsoftonline.com"
ARMBillingServiceURL="management.azure.com"
subscription_url="https://${ARMBillingServiceURL}/subscriptions"
resources_url="providers/Microsoft.Commerce/RateCard"

# API version for calling Microsoft Azure API
# (Choose one and uncomment it)
#api_version="2015-06-01-preview"
api_version="2016-08-31-preview"

# Full URL (without filters)
api_url="${resources_url}?api-version=${api_version}"

# Get token for later access

token=$(curl -s -X POST -d "grant_type=client_credentials&client_id=${app_id}&client_secret=${client_secret}&resource=https%3A%2F%2F${ARMBillingServiceURL}%2F" https://${ADALServiceURL}/${tenant_id}/oauth2/token | jq -r '.access_token')

# Retrieve info by calling Microsoft's Azure API

# Azure API asks for a filter. If you set up the filter by Region="US", you'll get the WHOLE LIST for EVERY COUNTRY!
filter="\$filter=OfferDurableId+eq+%27${offer_id}%27+and+Currency+eq+%27${currency}%27+and+Locale+eq+%27${locale}%27+and+RegionInfo+eq+%27${Region}%27"

ms_api="${subscription_url}/${subscription_id}/${api_url}&${filter}"

curl -L -s -X GET -H "Authorization: Bearer ${token}" -H "Content-Type: application/json" ${ms_api}
