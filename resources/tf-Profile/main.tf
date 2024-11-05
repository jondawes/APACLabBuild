terraform {
  required_providers {
    delphix = {
      source = "delphix-integrations/delphix"
      version = "3.2.3"
    }
  }
}

# Provider config
provider "delphix" {
  # Configuration options
  tls_insecure_skip = true
  key               = "1.3eHlCIKyK3sFatkZylMBiH0T1WN0NDdROOgYCc9M9KAZtXh5xtc46fNYKNuy43eY"
  host              = "uvo1if0anxkwauqnolv.vm.cld.sr"
}


# Variables
locals {
    crm_source_id           = "1-APPDATA_CONTAINER-627"
    target_environment_id   = "1-UNIX_HOST_ENVIRONMENT-41"
    mask_group_id           = "GROUP-34"
}

# MASK Profile Demo vDB - CRM data
resource "delphix_vdb" "crm-mask" {
    name                    = "crm-profile"
    source_data_id          = local.crm_source_id
    environment_id          = local.target_environment_id
    environment_user_id     = "postgres"
    target_group_id         = local.mask_group_id
    database_name           = "crm-profile"
    auto_select_repository  = true
    appdata_source_params = jsonencode({
        mountLocation       = "/mnt/provision/crm-profile"
        postgresPort        = 8061
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
