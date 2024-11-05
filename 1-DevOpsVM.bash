#!/bin/bash

# Create CRM Database in Prod
psql -p 5432 -h 10.160.1.29 -U postgres -c "DROP DATABASE IF EXISTS crm" 
psql -p 5432 -h 10.160.1.29 -U postgres -c "CREATE DATABASE crm"
psql -p 5432 -h 10.160.1.29 -U postgres -d crm -f ./resources/createCrm.sql


# Create ERP Database in Prod
psql -p 5432 -h 10.160.1.29 -U postgres -c "DROP DATABASE IF EXISTS erp"
psql -p 5432 -h 10.160.1.29 -U postgres -c "CREATE DATABASE erp"
psql -p 5432 -h 10.160.1.29 -U postgres -d erp -f ./resources/createErp.sql

# Deplpoy masking Hook Script to the Postgres staging server
    # This will prompt user for a password. To automate this, we need keys set up to enable passwordless SSH from the DevOps VM to the Postgres Server in the core image
echo  **** Enter  the password for the postgres user on Postgres Staging server****
scp ./resources/MaskJobExecution_API.bash postgres@10.160.1.74:~/