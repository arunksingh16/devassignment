resource "azurerm_resource_group" "rg_main" {
  name     = var.resource_group_name
  location = var.location
}


resource "azurerm_virtual_network" "vnet_main" {
  name                = "${var.prefix}-network"
  location            = "${azurerm_resource_group.rg_main.location}"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "DEV"
  }
}

resource "azurerm_subnet" "subnet-1" {
  name                 = "${var.subnet_1}"
  resource_group_name  = "${azurerm_resource_group.rg_main.name}"
  virtual_network_name = "${var.prefix}-network"
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [
    azurerm_virtual_network.vnet_main,
    ]
}

resource "azurerm_subnet" "subnet-2" {
  name                 = "${var.subnet_2}"
  resource_group_name  = "${azurerm_resource_group.rg_main.name}"
  virtual_network_name = "${var.prefix}-network"
  address_prefixes     = ["10.0.2.0/24"]
  depends_on = [
    azurerm_virtual_network.vnet_main,
    azurerm_subnet.subnet-1
    ]

}

resource "azurerm_network_security_group" "http_port" {
  name                = "${var.prefix}-nsg"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"
  location            = "${azurerm_resource_group.rg_main.location}"

  security_rule {
    name                       = "http_port"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "https_port"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [
    azurerm_virtual_network.vnet_main,
    azurerm_subnet.subnet-1,
    azurerm_subnet.subnet-2
    ]
}

resource "azurerm_network_interface" "nic1" {
  name                = "${var.prefix}-nic-1"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"
  location            = "${azurerm_resource_group.rg_main.location}"

  ip_configuration {
    name                          = "${var.prefix}-nic-ip-1"
    subnet_id                     = "${azurerm_subnet.subnet-1.id}"
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_virtual_network.vnet_main,
    azurerm_subnet.subnet-1,
    azurerm_subnet.subnet-2
    ]
}

resource "azurerm_network_interface" "nic2" {
  name                = "${var.prefix}-nic-2"
  resource_group_name = "${azurerm_resource_group.rg_main.name}"
  location            = "${azurerm_resource_group.rg_main.location}"

  ip_configuration {
    name                          = "${var.prefix}-nic-ip-2"
    subnet_id                     = "${azurerm_subnet.subnet-2.id}"
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_virtual_network.vnet_main,
    azurerm_subnet.subnet-1,
    azurerm_subnet.subnet-2
    ]
}

resource "azurerm_subnet_network_security_group_association" "nsg-subnet-1" {
  subnet_id                 = "${azurerm_subnet.subnet-1.id}"
  network_security_group_id = "${azurerm_network_security_group.http_port.id}"
  depends_on = [
    azurerm_virtual_network.vnet_main,
    azurerm_subnet.subnet-1,
    azurerm_subnet.subnet-2,
    azurerm_network_security_group.http_port
    ]
}

resource "azurerm_subnet_network_security_group_association" "nsg-subnet-2" {
  subnet_id                 = "${azurerm_subnet.subnet-2.id}"
  network_security_group_id = "${azurerm_network_security_group.http_port.id}"
  depends_on = [
    azurerm_virtual_network.vnet_main,
    azurerm_subnet.subnet-1,
    azurerm_subnet.subnet-2,
    azurerm_network_security_group.http_port
    ]
}


#############################################################################
# OUTPUTS
#############################################################################


output "network_name" {
  description = "The name of the network."
  value       = "${azurerm_virtual_network.vnet_main.name}"

}