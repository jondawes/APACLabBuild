#!/bin/bash

CCEADDRESS="10.160.1.160"
CCEADDRESS="uvo1r4nau0c9l8943kk.vm.cld.sr"
CCEUSER="admin"
CCEPWD="Delphix_123!"


# Login
result=$(curl -s -X POST -k --data @- http://$CCEADDRESS/masking/api/v5.1.38/login \
-H "Content-Type: application/json" <<EOF
{
    "username": "$CCEUSER",
    "password": "$CCEPWD"
}
EOF
) # end

AUTHTOKEN=$(echo $result | jq -r .Authorization)
echo 
echo $AUTHTOKEN
echo

# Create Applications (CRM & ERP)
result=$(curl -X 'POST' -k \
  "https://$CCEADDRESS/masking/api/v5.1.38/applications" \
  -H "Authorization: $AUTHTOKEN" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "applicationName": "APAC CRM"
  }'
) # end 

echo
echo $result
echo

CRMAPPID=$(echo $result | jq -r .applicationId)
echo $CRMAPPID

#result=$( curl -X 'POST' -k \
#  "https://$CCEADDRESS/masking/api/v5.1.38/applications" \
#  -b ~/cookies.txt \
#  -c ~/cookies.txt \
#  -H 'accept: application/json' \
#  -H 'Content-Type: application/json' \
#  -d '{
#    "applicationName": "ERP"
#  }'
#) # end

echo
echo


# Create Environments ()
 
#CRM Profile Demo
result=$(curl -X 'POST' -k \
  "https://$CCEADDRESS/masking/api/v5.1.38/environments" \
  -H 'accept: application/json' \
  -H "Authorization: $AUTHTOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
      "environmentName": "CRM Profile Demo",
      "applicationId": '\""$CRMAPPID"\"',
      "purpose": "MASK"
  }' 
) # end
echo 
echo $result
echo

CRMPROFILEDEMOID=$(echo $result | jq -r .environmentId)
echo $CRMPROFILEDEMOID
echo



#Import MC Algos
result=$(curl -X 'POST' -k \
  "https://$CCEADDRESS/masking/api/v5.1.38/import?force_overwrite=true" \
  -H 'accept: application/json' \
  -H "Authorization: $AUTHTOKEN" \
  -H 'Content-Type: application/json' \
  --data-binary "@./resources/WIP/AA-Export-Algorithms.json" 
) # end

echo
echo $result
echo


# Import Environments  

