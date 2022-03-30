resource_group_name = "rgTest01"
location            = "eastus"
tags                = { Name = "Luis Cabrera Aldui" }

vnet_name   = "vnTest01"
subnet_name = "subTest01"
nsg_name    = "nsgTest01"

security_rules = [
  {
    name                       = "AllowHTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "AllowHTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

stg_name                 = "stgtest01lcabreraa78"
account_tier             = "Standard"
account_replication_type = "LRS"

default_network_rule = "allow"
stgcnt_name          = "stgcnttest01"

kvname  = "kvtest01lcabreraa78"
kvsname = "kvstest01lcabreraa78"
