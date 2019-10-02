provider "azurerm" {}

resource "azurerm_resource_group" "rg" {
  name = "LabRouting"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "Labvnet"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space       = ["10.99.0.0/16"]
  location            = "East US"
}

resource "azurerm_route_table" "DMZ1RT" {
  name                = "DMZ1RT"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name           = "internal"
    address_prefix = "10.99.0.0/16"
    next_hop_type  = "vnetlocal"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "OnPrem2"
    address_prefix = "10.2.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "OnPrem5"
    address_prefix = "10.5.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  }

  resource "azurerm_route_table" "DMZ2RT" {
  name                = "DMZ2RT"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name           = "DMZ1"
    address_prefix = "10.99.11.0/24"
    next_hop_type  = "vnetlocal"
  }
  route {
    name           = "DMZ3"
    address_prefix = "10.99.13.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "DMZ2"
    address_prefix = "10.99.12.0/24"
    next_hop_type  = "vnetlocal"
  }
  route {
    name           = "OnPrem"
    address_prefix = "10.2.0.0/16"
     next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "OnPrem5"
    address_prefix = "10.5.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  }
  
  resource "azurerm_route_table" "DMZ3RT" {
  name                = "DMZ3RT"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name           = "DMZ1"
    address_prefix = "10.99.11.0/24"
     next_hop_type  = "vnetlocal"
  }
  route {
    name           = "DMZ2"
    address_prefix = "10.99.12.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "DMZ3"
    address_prefix = "10.99.13.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "OnPrem"
    address_prefix = "10.2.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "OnPrem5"
    address_prefix = "10.5.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  }  
  
  resource "azurerm_route_table" "GWRT" {
  name                = "GWRT"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name           = "DMZ1"
    address_prefix = "10.99.11.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.0.10"
  }
  route {
    name           = "DMZ2"
    address_prefix = "10.99.12.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.0.10"
  }
  route {
    name           = "DMZ3"
    address_prefix = "10.99.13.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.0.10"
  }
  
  }  
  
resource "azurerm_subnet" "External_subnet"  {
    name           = "External"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.0.0/24"
  }

resource "azurerm_subnet" "Gateway_subnet"  { 
    name           = "GatewaySubnet"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.100.0/24"
route_table_id = "${azurerm_route_table.GWRT.id}"
  }

resource "azurerm_subnet" "Internal_subnet"   {
    name           = "Internal"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.1.0/24"
  }
resource "azurerm_subnet" "DMZ1_subnet"  {
    name           = "DMZ1"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.11.0/24"
	route_table_id = "${azurerm_route_table.DMZ1RT.id}"
  }
resource "azurerm_subnet" "DMZ2_subnet"  {
    name           = "DMZ2"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.12.0/24"
	route_table_id = "${azurerm_route_table.DMZ2RT.id}"
  }
resource "azurerm_subnet" "DMZ3_subnet" {
    name           = "DMZ3"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.13.0/24"
	route_table_id = "${azurerm_route_table.DMZ3RT.id}"
  }

resource "azurerm_public_ip" "gwpublicip" {
    name                         = "CHKPPublicIP"
    location                     = "${azurerm_resource_group.rg.location}"
    resource_group_name          = "${azurerm_resource_group.rg.name}"
    public_ip_address_allocation = "dynamic"
}
  
resource "azurerm_network_interface" "gwexternal" {
    name                = "gatewayexternal"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    enable_ip_forwarding = "true"
	ip_configuration {
        name                          = "gwexternalConfiguration"
        subnet_id                     = "${azurerm_subnet.External_subnet.id}"
        private_ip_address_allocation = "Static"
		private_ip_address = "10.99.0.10"
        primary = true
		public_ip_address_id = "${azurerm_public_ip.gwpublicip.id}"
    }

}

resource "azurerm_network_interface" "gwinternal" {
    name                = "gatewayinternal"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    enable_ip_forwarding = "true"
    ip_configuration {
        name                          = "gwinternalConfiguration"
        subnet_id                     = "${azurerm_subnet.Internal_subnet.id}"
        private_ip_address_allocation = "Static"
		private_ip_address = "10.99.1.10"
    }
}

resource "azurerm_network_interface" "ubuntuDMZ1" {
    name                = "ubuntuDMZ1"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "ubuntuDMZ1Configuration"
        subnet_id                     = "${azurerm_subnet.DMZ1_subnet.id}"
        private_ip_address_allocation = "Static"
		private_ip_address = "10.99.11.10"
    }
}
resource "azurerm_network_interface" "ubuntuDMZ2" {
    name                = "ubuntuDMZ2"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "ubuntuDMZ2Configuration"
        subnet_id                     = "${azurerm_subnet.DMZ2_subnet.id}"
        private_ip_address_allocation = "Static"
		private_ip_address = "10.99.12.10"
    }
}
resource "azurerm_network_interface" "ubuntuDMZ2b" {
    name                = "ubuntuDMZ2b"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "ubuntuDMZ2bConfiguration"
        subnet_id                     = "${azurerm_subnet.DMZ2_subnet.id}"
        private_ip_address_allocation = "Static"
		private_ip_address = "10.99.12.20"
    }
}
resource "azurerm_network_interface" "ubuntuDMZ3a" {
    name                = "ubuntuDMZ3a"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "ubuntuDMZ3aConfiguration"
        subnet_id                     = "${azurerm_subnet.DMZ3_subnet.id}"
        private_ip_address_allocation = "Static"
		private_ip_address = "10.99.13.10"
    }
}
resource "azurerm_network_interface" "ubuntuDMZ3b" {
    name                = "ubuntuDMZ3b"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "ubuntuDMZ3bConfiguration"
        subnet_id                     = "${azurerm_subnet.DMZ3_subnet.id}"
        private_ip_address_allocation = "Static"
		private_ip_address = "10.99.13.20"
    }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.rg.name}"
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.rg.name}"
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

}

# Create virtual machine
resource "azurerm_virtual_machine" "chkpgw" {
    name                  = "r80dot10"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.gwexternal.id}","${azurerm_network_interface.gwinternal.id}"]
    primary_network_interface_id = "${azurerm_network_interface.gwexternal.id}"
    vm_size               = "Standard_D2_v2_Promo"

    storage_os_disk {
        name              = "R80dot10OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "checkpoint"
        offer     = "check-point-vsec-r80"
        sku       = "sg-byol"
        version   = "latest"
    }

    plan {
        name = "sg-byol"
        publisher = "checkpoint"
        product = "check-point-vsec-r80"
        }
    os_profile {
        computer_name  = "r80dot10"
        admin_username = "azureuser"
        admin_password = "Cpwins1!"
        custom_data =  "#!/bin/bash\nconfig_system -s 'timezone=America/New_York&install_security_gw=true&gateway_daip=false&install_ppak=true&gateway_cluster_member=false&install_security_managment=true&install_mgmt_primary=true&ntp_primary=ntp.checkpoint.com&ntp_primary_version=4&ntp_secondary=ntp2.checkpoint.com&ntp_secondary_version=4&mgmt_admin_radio=gaia_admin&mgmt_gui_clients_radio=any'\nshutdown -r now\n"

    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

}

resource "azurerm_virtual_machine" "ubuntudmz1" {
    name                  = "ubuntudmz1"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.ubuntuDMZ1.id}"]
    vm_size               = "Standard_B1s"

    storage_os_disk {
        name              = "ubuntudmz1disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "dmz1"
        admin_username = "azureuser"
        admin_password = "Cpwins1!"
        
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

}

resource "azurerm_virtual_machine" "ubuntudmz2" {
    name                  = "ubuntudmz2"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.ubuntuDMZ2.id}"]
    vm_size               = "Standard_B1s"

    storage_os_disk {
        name              = "ubuntudmz2disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "dmz2"
        admin_username = "azureuser"
        admin_password = "Cpwins1!"
        
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

}
resource "azurerm_virtual_machine" "ubuntudmz2b" {
    name                  = "ubuntudmz2b"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.ubuntuDMZ2b.id}"]
    vm_size               = "Standard_B1s"

    storage_os_disk {
        name              = "ubuntudmz2bdisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "dmz2b"
        admin_username = "azureuser"
        admin_password = "Cpwins1!"
        
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

}
resource "azurerm_virtual_machine" "ubuntudmz3a" {
    name                  = "ubuntudmz3a"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.ubuntuDMZ3a.id}"]
    vm_size               = "Standard_B1s"

    storage_os_disk {
        name              = "ubuntudmz3adisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "dmz3a"
        admin_username = "azureuser"
        admin_password = "Cpwins1!"
        
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

}
resource "azurerm_virtual_machine" "ubuntudmz3b" {
    name                  = "ubuntudmz3b"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.ubuntuDMZ3b.id}"]
    vm_size               = "Standard_B1s"

    storage_os_disk {
        name              = "ubuntudmz3bdisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "dmz3a"
        admin_username = "azureuser"
        admin_password = "Cpwins1!"
        
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

}

resource "azurerm_local_network_gateway" "drawbridge" {
  name = "drawbridge"
  location = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  gateway_address = "255.254.253.252"
  address_space = ["10.2.0.0/16","10.5.0.0/16"]
}

resource "azurerm_public_ip" "vpngwip" {
  name = "vpngwip"
  location = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vpngw" {
  name = "vpngw"
  location = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  type = "Vpn"
  vpn_type = "PolicyBased"

  active_active = false
  enable_bgp = false
    sku = "Basic"

  ip_configuration {
    public_ip_address_id = "${azurerm_public_ip.vpngwip.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id = "${azurerm_subnet.Gateway_subnet.id}"
  }
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name = "onpremise"
  location = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  type = "IPsec"
  virtual_network_gateway_id = "${azurerm_virtual_network_gateway.vpngw.id}"
  local_network_gateway_id = "${azurerm_local_network_gateway.drawbridge.id}"

  shared_key = "Cpwins1!vpn123"
}




