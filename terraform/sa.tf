#############################################################################
# Module for SA Creation
#############################################################################

resource "azurerm_storage_account" "saccnt" {
  name                     = "${var.prefix}thisshdbeunique"
  location            = "${azurerm_resource_group.rg_main.location}"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  access_tier               = "Hot"
}

#############################################################################
# OUTPUTS
#############################################################################


output "sa-name" {
  description = "SA Name."
  value       = "${azurerm_storage_account.saccnt.name}"

}