#!/bin/bash

#  Need to run 01A-Create DCT environment that exists in Jenkins already

# Get masking Job IDs for hook scrripts
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

# Get configuted SC Address
DCTADDRESS=$(cat config.json | jq -r .DCTADDRESS)
echo DCT ADDRESS : $DCTADDRESS
echo
# Update Terraform jobs with correct DCT Address

echo updating DCT Address...
sed -i "s/host              = \"\"/host              = \"$DCTADDRESS\"/g" ./resources/tf-StaticEnvironment/main.tf
sed -i "s/host              = \"\"/host              = \"$DCTADDRESS\"/g" ./resources/tf-Profile/main.tf
sed -i "s/host              = \"\"/host              = \"$DCTADDRESS\"/g" ./resources/tf-Ephemeral/main.tf

# Build Static environment
cd ./resources/tf-StaticEnvironment
terraform init
terraform apply --auto-approve

cd ../..