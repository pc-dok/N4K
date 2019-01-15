// NOTE: This step is to create my Jumping Host or Bastion Server
locals {
  virtual_machine_name_jh = "${var.jh}"
  virtual_machine_fqdn_jh = "${var.jh}.${var.active_directory_domain}"
  custom_data_params_jh   = "Param($RemoteHostName = \"${local.virtual_machine_fqdn_jh}\", $ComputerName = \"${local.virtual_machine_name_jh}\")"
  custom_data_content_jh  = "${local.custom_data_params_jh} ${file("${path.module}/files/winrm.ps1")}"
}
resource "azurerm_network_interface" "jh" {
  name                      = "${var.jh}-nic"
  location                  = "${var.azlocation}"
  resource_group_name       = "${var.RG_Network}"
  internal_dns_name_label   = "${local.virtual_machine_name_jh}"
  network_security_group_id = "${azurerm_network_security_group.Default.id}"
  depends_on                = ["azurerm_subnet.Clients"]

  ip_configuration {
    name                          = "jh"
    subnet_id                     = "${azurerm_subnet.Clients.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "172.31.1.11"
    public_ip_address_id          = "${azurerm_public_ip.pip.id}"
  }
}
resource "azurerm_public_ip" "pip" {
  name                         = "${var.jh}-pip"
  location                     = "${var.azlocation}"
  resource_group_name          = "${var.RG_Network}"
  public_ip_address_allocation = "Dynamic"
  depends_on              = ["azurerm_subnet.Clients"]
}
resource "azurerm_virtual_machine" "jumping-host" {
  name                          = "${local.virtual_machine_name_jh}"
  location                      = "${var.azlocation}"
  resource_group_name           = "${var.RG_Compute}"
  vm_size                       = "Standard_D2s_v3"
  network_interface_ids         = ["${element(azurerm_network_interface.jh.*.id, count.index)}"]
  delete_os_disk_on_termination = true
  depends_on                    = ["azurerm_network_interface.jh"]

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.virtual_machine_name_jh}-C"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    vhd_uri           = "${azurerm_storage_account.storlrs.primary_blob_endpoint}vhds/${var.jh}-C.vhd"
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.storlrsdiag.primary_blob_endpoint}"
  }

  os_profile {
    computer_name  = "${local.virtual_machine_name_jh}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    custom_data    = "${local.custom_data_content_jh}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true

    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
    }

    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = "${file("${path.module}/files/FirstLogonCommands.xml")}"
    }
  }
}