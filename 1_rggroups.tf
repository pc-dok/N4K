// NOTE: Create Ressource Groups in Azure , in my Example i have 3 RG´s for Computing,Networking and Storages
resource "azurerm_resource_group" "Compute" {
  name     = "${var.RG_Compute}"
  location = "${var.azlocation}"
  tags {
    environment = "RG3_Compute"
  }
}
resource "azurerm_resource_group" "Network" {
  name     = "${var.RG_Network}"
  location = "${var.azlocation}"
  tags {
    environment = "RG3_Network"
  }
}
resource "azurerm_resource_group" "Storage" {
  name     = "${var.RG_Storage}"
  location = "${var.azlocation}"
  tags {
    environment = "RG3_Storage"
  }
}