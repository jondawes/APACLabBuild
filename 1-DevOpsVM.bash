#!/bin/bash

psql -c "DROP DATABASE IF EXISTS crm"
psql -c "CREATE DATABASE crm"
psql -d crm -f ./resources/createCRM.sql

psql -c "DROP DATABASE IF EXISTS erp"
psql -c "CREATE DATABASE erp"
psql -d erp -f ./resources/createErp.sql