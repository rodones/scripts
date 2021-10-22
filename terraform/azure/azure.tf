terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

resource "random_pet" "server" {}

variable "arm_client_id" {
  type = string
}
variable "arm_tenant_id" {
  type = string
}
variable "arm_subscription_id" {
  type = string
}
variable "arm_client_certificate_path" {
  type = string
}
variable "arm_client_certificate_password" {
  type = string
}
variable "arm_username" {
  type = string
}
variable "arm_ssh_key_pvt" {
  type = string
}
variable "arm_ssh_key_pub" {
  type = string
}

provider "azurerm" {
  features {}

  client_id                   = var.arm_client_id
  tenant_id                   = var.arm_tenant_id
  subscription_id             = var.arm_subscription_id
  client_certificate_path     = var.arm_client_certificate_path
  client_certificate_password = var.arm_client_certificate_password
}

resource "azurerm_resource_group" "server" {
  name     = "colmap-resources"
  location = "South Central US"
  #   location = "East US"
}

resource "azurerm_virtual_network" "server" {
  name                = "colmap-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.server.location
  resource_group_name = azurerm_resource_group.server.name
}

resource "azurerm_subnet" "server" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.server.name
  virtual_network_name = azurerm_virtual_network.server.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "server" {
  name                = "server-nic"
  location            = azurerm_resource_group.server.location
  resource_group_name = azurerm_resource_group.server.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.server.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "server" {
  name                = random_pet.server.id
  resource_group_name = azurerm_resource_group.server.name
  location            = azurerm_resource_group.server.location
  #   size                = "Standard_B1ls"
  size           = "Standard_NV12s_v3"
  admin_username = var.arm_username
  network_interface_ids = [
    azurerm_network_interface.server.id,
  ]

  admin_ssh_key {
    username   = var.arm_username
    public_key = file(var.arm_ssh_key_pub)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  provisioner "local-exec" {
    when    = create
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.arm_username} -i '${self.public_ip_address},' --private-key ${var.arm_ssh_key_pvt} -e 'pub_key=${var.arm_ssh_key_pub}' ../../ansible/nvidia-docker.yml"
  }

  #   provisioner "local-exec" {
  #     when    = create
  #     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u rodones -i '${self.public_ip_address},' --private-key ${var.arm_ssh_key_pvt} -e 'pub_key=${var.arm_ssh_key_pub}' ../../ansible/init.yml"
  #   }
}

output "host" {
  value = azurerm_linux_virtual_machine.server.public_ip_address
}
output "username" {
  value = var.arm_username
}

/*
https://azure.microsoft.com/tr-tr/pricing/details/virtual-machines/linux/

= South Central US =
Standard_NV12s_v3    : USD 1.368 -> USD 0.28728
Standard_NV24s_v3    : USD 2.736 -> USD 0.57456
Standard_NV48s_v3    : USD 5,472 -> USD 1.14912
= West US =
NV4as_v4    : USD ?
NV8as_v4    : USD ?
NV16as_v4   : USD ?
NV32as_v4   : USD ?
*/
