#!/bin/bash

#  Need to run 01B-Create local Demo environment that exists in Jenkins already

# dSources
./dct-toolkit create_postgres_source environment_id="Postgres Source" name="Postgres_crm" repository_id="Postgres vFiles (15.0)" 
./dct-toolkit create_postgres_source environment_id="Postgres Source" name="Postgres_erp" repository_id="Postgres vFiles (15.0)" 

# Link dSources - his
dct-toolkit link_appdata_database \
    source_id="Postgres_crm" \
    group_id="Source" \
    link_type=AppDataStaged \
    staging_environment="Postgres Source" \
    environment_user="postgres" \
    sync_parameters='{"resync": true}' \
    parameters='{ \
        "mountLocation":"/mnt/provision/pg_master",\
        "externalBackup":[], \
        "delphixInitiatedBackupFlag":true,  \
        "privilegedOsUser":"",   \
        "delphixInitiatedBackup":[  \
            {"userName":"postgres",  \
            "userPass":"Delphix_123!", \
            "sourceHostAddress":"10.160.1.29", \
            "postgresSourcePort":5432} \
        ], \
        "singleDatabaseIngestionFlag":false, \
        "singleDatabaseIngestion":[], \ 
        "postgresPort":5433, \
        "configSettingsStg":[] \
    }' 


# Link dSources - mine
./dct-toolkit link_appdata_database \
    source_id="Postgres_crm" \
    group_id="Source" \
    link_type=AppDataStaged \
    staging_environment="Postgres Source" \
    environment_user="postgres" \
    sync_parameters='{"resync": true}' \
    parameters='{ 
        "mountLocation":"/mnt/provision/pg_crm",
        "externalBackup":[], 
        "delphixInitiatedBackupFlag":false,  
        "privilegedOsUser":"",   
        "delphixInitiatedBackup":[], 
        "singleDatabaseIngestionFlag":true, 
        "singleDatabaseIngestion":[{  
            "databaseUserName":"postgres", 
            "databaseUserPassword":"Delphix_123!", 
            "sourcePort":5432, 
            "databaseName":"crm", 
            "dumpDir":"/var/lib/pgsql/backups", 
            "restoreJobs":2, 
            "dumpJobs":2, 
            "sourceHost": "10.160.1.29"
            }], 
        "postgresPort":8001, 
        "configSettingsStg":[] 
    }' 


