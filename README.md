# APACLabBuild

This repository contains the components required to build an Australian based Delphix Demo. This is designed ot be built on top of the existing CLoudShare environment, though the contents could be customised to be deploying about into other environments.

The core files in this repository are:
- A set of BASH scripts numbered 1-6. 
    - Scripts 1-3 are used to build the environment components. Usage is discussed below.
    - Scripts 4a and 4b can be used to provision and destroy a set of ephemeral vDBs based on the masked vDBs created in the setup steps.
    - Scripts 5a and 5b can be used to provision and destroy a set of vDBs based on production that can be profiled and masked with pre-configured Compliance jobs created in the setup phase.
    - Script 6 will delete the setup created in step 3 to remove all the vDBs and dSources. Typically not required, but could be used to do a deeper demo where the entire environment is built in the session.
- config.json - contains some aspects of the config
    -  DCTADDRESS, CCEADDRESS, CCEUSER, CCEPWD are pre-configured for the scripts to work when run inside the Cloudshare lab. They may be edited if needed, more info below. 
    - Other values will be updated dynamically by the setup scripts as they refer to items created during the config.
- DemoSQL.sql contains SQL snippets than can be copy/pasted into the named DBeaver connections to assist in the demo flow.
- resources folder - contains supporting scripts and Terraform configs for the setup. The readme in that folder has more information.

## Prerequisites
This is designed to work with the "Delphix-Blazemeter Demo 2.0" image available in CloudShare. It has been tested with v15 of that image. Once you have spun up a copy of that environment, to prepare to run the build scripts first:
1. Open the Jenkins page and run the pipeline *Demo 2.0 Postgres > 01A-Create DCT environment*. This pipeline will set up DCT by registering the Continuous Data and Compliance engines. This needs to be completed prior to running these build scripts
2. Get the files in this repository into the environment on the *DCT K8S - Jenkins* VM by either:
    - executing *git clone https://github.com/jondawes/APACLabBuild.git* (or with the relevant URL if this moves)
    - Copying the files into your CLoud Folder and mounting them into the VM (At tht time of writing, Cloud Folders do not appear to work on that VM but it is being fixed in the image)
3. Import the DBeaver configuration - the file ./resources/DBeaverProject/APAC Demo-20241114.dbp contains a DBeaver project that will provide preconfigiured connections to all the databases that are used as part of this demo. This can be imported by copying the file to you Cloudshare Cloud Folder and importing on the Developer 2.0 VM.
    - You can import by selecting **File > Import** then choosing **Project** and clickiong **Next >**. Select the import file and check the box next to **APAC Demo**. You can change the Target Name if desired. Click **Finish** to import the project.
    - You should see a new project in the Projects pane called APAC Demo with 3 folders, 1-Production, 2-Staging and 3-Non-Production.

## Build Process
To build the environment, run each of the build scripts in turn as below.

### 1-ProdSetup
**1-ProdSetup.bash** will execute the following:
1. Create the production databases on the Postgres Source server. Two databases will be created and populated with data, **CRM** and **ERP**
2. A script to be used to execute masking on Hook Scripts in a later stage will be deployed tot he Postgres Staging Server, this will require you interactively providing the password for the **postgres** user at the prompt

#### Validation
To confirm that this step has worked:
1. Verify that no errors have been thrown by the script
2. Check the verification outputs provided by the script. You will see the message **CRM Validation - following count should be "200"** followed by a SQL COUNT(*) output that should return the state value of 200. A similar pair of outputs will be provided fore the ERP database.
3. Ensure that in DBeaver, the **CRM PROD** and **ERP PROD** connections under **1-Production** are able to connect and the relevant queries in **DemoSQL.sql** are successful.

### 2-ContinuousComplianceSetup

## Demo Scripts


