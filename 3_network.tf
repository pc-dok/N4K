// NOTE: This Step is creating my LAN Segment with 4 Subnets
resource "azurerm_virtual_network" "main" {
  name                = "${var.vnet}"
  address_space       = ["172.31.0.0/16"]
  location            = "${var.azlocation}"
  resource_group_name = "${var.RG_Network}"
 // dns_servers         = ["172.31.2.11", "172.31.2.12", "8.8.8.8"] // activate when needed
  depends_on          = ["azurerm_resource_group.Network"]
}

resource "azurerm_subnet" "Clients" {
  name                 = "Clients"
  resource_group_name  = "${var.RG_Network}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "172.31.1.0/24"
}

resource "azurerm_subnet" "Server" {
  name                 = "Server"
  resource_group_name  = "${var.RG_Network}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "172.31.2.0/24"
}
resource "azurerm_subnet" "Netscaler" {
  name                 = "Netscaler"
  resource_group_name  = "${var.RG_Network}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "172.31.3.0/24"
}
resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${var.RG_Network}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "172.31.4.0/24"
}

# ************************** NETWORK SECURITY GROUPS - NSG **************************** #
resource "azurerm_network_security_group" "Default" {
  name                = "Default_NSG"
  location            = "${azurerm_resource_group.Network.location}"
  resource_group_name = "${azurerm_resource_group.Network.name}"

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

security_rule {
    name                       = "AllowHTTPS"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

security_rule {
    name                       = "AllowRDP"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}