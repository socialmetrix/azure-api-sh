#!/bin/sh

cfg_file="azure_login.cfg"

echo "APP Service Principal Generator -Read Only- for Microsoft Azure infrastructure"
echo
echo "PREQUISITES:"
echo
echo "- az cli installed"
echo "- You must log into Azure with \"az login\" command and have enough"
echo "  permissions for creating service principal users."
echo
echo "Please, enter app name. E.g.: my-app"
read app_name
echo "Please, enter app password"
read app_pass

tmp_file=$(mktemp)

echo
echo "Creating APP: ${app_name} with secret: ${app_pass} (wait a few seconds please)"
echo
az ad sp create-for-rbac --name ${app_name} --password ${app_pass} --role Reader --years 1 -o json > $tmp_file

app_id=$(cat ${tmp_file} | jq -r '.appId')
client_secret=$(cat ${tmp_file} | jq -r '.client_secret')
subscription_id=$(az account list | jq -r '.[].id')
tenant_id=$(cat ${tmp_file} | jq -r '.tenant')

echo "app_id=\"${app_id}\"" > $cfg_file
echo "client_secret=\"${app_pass}\"" >> $cfg_file
echo "subscription_id=\"${subscription_id}\"" >> $cfg_file
echo "tenant_id=\"${tenant_id}\"" >> $cfg_file

echo
echo "Config file \"${cfg_file}\" created. Current content:"
echo
cat ${cfg_file}
echo

rm $tmp_file
