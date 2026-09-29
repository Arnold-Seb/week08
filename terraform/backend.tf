# Terraform state has to live somewhere both my machine and the GitHub runner
# can reach. A runner is a fresh machine every time, so local state would make
# the pipeline think nothing exists and try to recreate everything.
terraform {
    backend "azurerm" {
        resource_group_name  = "tfstate-rg"
        storage_account_name = "tfstatearnolds225095328"
        container_name       = "tfstate"
        key                  = "week08.tfstate"
    }
}
