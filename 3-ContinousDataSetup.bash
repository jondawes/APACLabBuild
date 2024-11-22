#!/bin/bash

#  Need to run 01A-Create DCT environment that exists in Jenkins already

CRMMASKGCJOBID=$(cat config.json | jq -r .CRMMASKGCJOBID)
ERPMASKGCJOBID=$(cat config.json | jq -r .ERPMASKGCJOBID)

echo CRM Mask Job ID : $CRMMASKGCJOBID
echo ERP Mask Job ID : $ERPMASKGCJOBID
echo

# Update Terraform jobs with correct Job IDs in hook scripts
echo updating hook scripts...
sed -i "s/-p 1 -j 50 > crmMask.log/-p 1 -j $CRMMASKGCJOBID > crmMask.log/g" ./resources/tf-StaticEnvironment/main.tf
sed -i "s/-p 1 -j 54 > erpMask.log/-p 1 -j $ERPMASKGCJOBID > erpMask.log/g" ./resources/tf-StaticEnvironment/main.tf
echo

# Build Static environment
cd ./resources/tf-StaticEnvironment
terraform init
terraform apply --auto-approve
