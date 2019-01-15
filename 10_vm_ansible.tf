// NOTE: Step 10 is to create my Ansible Controller Machine
locals {
  virtual_machine_name_ansible = "${var.ansible}"
}
resource "azurerm_network_interface" "ansible" {
  name                    = "${var.ansible}-nic"
  location                = "${var.azlocation}"
  resource_group_name     = "${var.RG_Network}"
  internal_dns_name_label = "${local.virtual_machine_name_ansible}"
  network_security_group_id = "${azurerm_network_security_group.Default.id}"
  depends_on              = ["azurerm_subnet.Server"]

  ip_configuration {
    name                          = "ansible"
    subnet_id                     = "${azurerm_subnet.Server.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "172.31.2.21"
    public_ip_address_id          = "${azurerm_public_ip.ansible.id}"
  }
}
resource "azurerm_public_ip" "ansible" {
  name                         = "${var.ansible}-pip"
  location                     = "${var.azlocation}"
  resource_group_name          = "${var.RG_Network}"
  public_ip_address_allocation = "Dynamic"
  depends_on                   = ["azurerm_subnet.Server"]
}
resource "azurerm_virtual_machine" "ansible" {
  name                          = "${local.virtual_machine_name_ansible}"
  location                      = "${var.azlocation}"
  resource_group_name           = "${var.RG_Compute}"
  vm_size                       = "Standard_D2s_v3"
  network_interface_ids         = ["${element(azurerm_network_interface.ansible.*.id, count.index)}"]
  delete_os_disk_on_termination = true
  depends_on                    = ["azurerm_network_interface.ansible"]


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.ansible}-root"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    vhd_uri           = "${azurerm_storage_account.storlrs.primary_blob_endpoint}vhds/${var.ansible}-root.vhd"
  }
    boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.storlrsdiag.primary_blob_endpoint}"
  }

  os_profile {
    computer_name  = "${var.ansible}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    connection {
      user     = "${var.admin_username}"
      password = "${var.admin_password}"
    }

    inline = [
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt-get update -y",
      "sudo apt-get install ansible -y",
      "sudo apt-get upgrade -y",
      "sudo apt-get install htop -y",
      "sudo reboot",
    ]
  }

}
