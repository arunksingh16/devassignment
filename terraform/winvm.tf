#############################################################################
# Module for Windows VM Creation
#############################################################################

resource "azurerm_windows_virtual_machine" "winvm-1" {
  name                = "${var.prefix}-win-1"
  location            = "${azurerm_resource_group.rg_main.location}"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"
  size                = "${var.winvmsize}"
  admin_username      = "adminuser"
  admin_password      = "${azurerm_key_vault_secret.winvm_kv_secret.value}"
  network_interface_ids = [
    "${azurerm_network_interface.nic1.id}",
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}


resource "azurerm_windows_virtual_machine" "winvm-2" {
  name                = "${var.prefix}-win-2"
  location            = "${azurerm_resource_group.rg_main.location}"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"
  size                = "${var.winvmsize}"
  admin_username      = "adminuser"
  admin_password      = "${azurerm_key_vault_secret.winvm_kv_secret.value}"
  network_interface_ids = [
    "${azurerm_network_interface.nic2.id}",
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

#############################################################################
# OUTPUTS
#############################################################################


output "winvm-1-name" {
  description = "The name of the winvm."
  value       = "${azurerm_windows_virtual_machine.winvm-1.name}"

}

output "winvm-2-name" {
  description = "The name of the winvm."
  value       = "${azurerm_windows_virtual_machine.winvm-2.name}"

}