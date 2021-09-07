#############################################################################
# Module for KV Creation
#############################################################################

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "kv" {
  name                = "${var.prefix}kv-bbthisisunique"
  location            = "${azurerm_resource_group.rg_main.location}"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"
  enabled_for_disk_encryption = true
  tenant_id                   = "${data.azurerm_client_config.current.tenant_id}"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${data.azurerm_client_config.current.subscription_id}"     
    application_id = "${data.azurerm_client_config.current.client_id}"

    secret_permissions = [
      "set",
      "get",
      "delete",
      "purge",
      "recover",
      "list",
      "Backup",
      "Restore"
    ]

  }
  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${data.azurerm_client_config.current.object_id}"     
    application_id = "${data.azurerm_client_config.current.client_id}"

    secret_permissions = [
      "set",
      "get",
      "delete",
      "purge",
      "recover",
      "list",
      "Backup",
      "Restore"
    ]
  }
}

resource "random_password" "vm_pass" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "winvm_kv_secret" {
  name         = "winvm-pass"
  value        = "${random_password.vm_pass.result}"
  key_vault_id = "${azurerm_key_vault.kv.id}"
  depends_on = [
    azurerm_key_vault.kv,
    ]
}
#############################################################################
# OUTPUTS
#############################################################################

output "kv_name" {
  value = "${azurerm_key_vault.kv.name}"
}
