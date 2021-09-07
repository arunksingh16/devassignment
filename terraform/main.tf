#############################################################################
# TERRAFORM CONFIG
#############################################################################

terraform {
  backend "azurerm" {
        resource_group_name  = "rg-terraform"
        storage_account_name = "tfstorageaccnt"
        container_name       = "terraform"
        key                  = "dev.vnet.terraform.tfstate"
    }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
#  subscription_id   = "${var.ARM_SUBSCRIPTION_ID}"
#  tenant_id         = "${var.ARM_TENANT_ID}"
#  client_id         = "${var.ARM_CLIENT_ID}"
#  client_secret     = "${var.ARM_CLIENT_SECRET}"
}

