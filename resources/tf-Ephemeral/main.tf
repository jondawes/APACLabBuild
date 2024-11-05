terraform {
  required_providers {
    delphix = {
      source = "delphix-integrations/delphix"
      version = "3.2.3"
    }
  }
}

## Provider config
provider "delphix" {
  # Configuration options
  tls_insecure_skip = true
  key               = "1.3eHlCIKyK3sFatkZylMBiH0T1WN0NDdROOgYCc9M9KAZtXh5xtc46fNYKNuy43eY"
  host              = "uvo1if0anxkwauqnolv.vm.cld.sr"
}

# Variables - make modules later
locals {
    crm_enrichment_id             = "1-APPDATA_CONTAINER-672"
    erp_enrichment_id             = "1-APPDATA_CONTAINER-669"
    target_environment_id         = "1-UNIX_HOST_ENVIRONMENT-41"
    ephemeral_group_id            = "GROUP-33"
}


# CRM vDB
resource "delphix_vdb" "crm-ephemeral" {
    name                    = "crm-ephemeral"
    source_data_id          = local.crm_enrichment_id
    environment_id          = local.target_environment_id
    environment_user_id     = "postgres"
    target_group_id         = local.ephemeral_group_id
    database_name           = "crm-ephemeral"
    auto_select_repository  = true
    appdata_source_params   = jsonencode({
        mountLocation       = "/mnt/provision/crm-ephemeral"
        postgresPort        = 8041
    })

    configure_clone {
        name            = "Open Network Access"
        command         = <<-EOT
                            # Update pg_hba.conf to allow all IPv4 traffic 
                            echo "host  all   all   0.0.0.0/0    trust"  >> $DLPX_DATA_DIRECTORY/data/pg_hba.conf
                            # reload postgress to make above take effect
                            /usr/pgsql-12/bin/pg_ctl reload -D $DLPX_DATA_DIRECTORY/data
                            EOT
        shell           = "bash"
    }

    tags {
        key   = "region"
        value = "apac"
    }

}

# ERP vDB
resource "delphix_vdb" "erp-ephemeral" {
    name                    = "erp-ephemeral"
    source_data_id          = local.erp_enrichment_id
    environment_id          = local.target_environment_id
    environment_user_id     = "postgres"
    target_group_id         = local.ephemeral_group_id
    database_name           = "erp-ephemeral"
    auto_select_repository  = true
    appdata_source_params = jsonencode({
        mountLocation       = "/mnt/provision/erp-ephemeral"
        postgresPort        = 8042
    })

    configure_clone {
        name            = "Open Network Access"
        command         = <<-EOT
                            # Update pg_hba.conf to allow all IPv4 traffic 
                            echo "host  all   all   0.0.0.0/0    trust"  >> $DLPX_DATA_DIRECTORY/data/pg_hba.conf
                            # reload postgress to make above take effect
                            /usr/pgsql-12/bin/pg_ctl reload -D $DLPX_DATA_DIRECTORY/data
                            EOT
        shell           = "bash"
    }

    tags {
        key   = "region"
        value = "apac"
    }

}

# vDB Group for both
resource "delphix_vdb_group" "apac-ephemeral" {
    depends_on      = [ delphix_vdb.crm-ephemeral, delphix_vdb.erp-ephemeral ]
    name            = "apac-ephemeral"
    vdb_ids         = [delphix_vdb.crm-ephemeral.id, delphix_vdb.erp-ephemeral.id]
}

output "apac-ephemeral-id" {
    depends_on      = [ delphix_vdb_group.apac-ephemeral ]
    value           = delphix_vdb_group.apac-ephemeral.id
}