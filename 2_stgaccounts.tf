// NOTE: Second Step is to create Storage Accounts for my VM´s. I need normal Standard_LRS Storage also a Premium_LRS 
//       and a separate Standard_LRS Storage for my Boot Diagnostics.
resource "azurerm_storage_account" "storlrs" {
  name               = "${var.storlrs}"
  resource_group_name = "${azurerm_resource_group.Storage.name}"
  location                 = "${azurerm_resource_group.Storage.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_account" "storlrsdiag" {
  name                = "${var.storlrsdiag}"
  resource_group_name = "${azurerm_resource_group.Storage.name}"
  location                 = "${azurerm_resource_group.Storage.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_account" "storlrsssd" {
  name                = "${var.storlrsssd}"
  resource_group_name = "${azurerm_resource_group.Storage.name}"
  location                 = "${azurerm_resource_group.Storage.location}"
  account_tier             = "Premium"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "vhds" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.Storage.name}"
  storage_account_name  = "${var.storlrs}"
  container_access_type = "blob"
  depends_on = ["azurerm_storage_account.storlrs"]
}
