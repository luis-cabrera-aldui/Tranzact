terraform {
  required_version = ">=1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.65"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

#Create VNET
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

#Create Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage","Microsoft.KeyVault"]
}

#create Network Security Group
resource "azurerm_network_security_group" "nsg_subnet" {
  name                = var.nsg_name
  location            = var.location
  tags                = var.tags
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix

    }
  }
}

#Associate NSG with SubNet
resource "azurerm_subnet_network_security_group_association" "subnet" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_subnet.id
}

#Create Key Vault
resource "azurerm_key_vault" "kv" {
  name = var.kvname
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = "61797349-b8a9-41c6-b3a9-750546633066"
  # tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name = "premium"
  soft_delete_retention_days = 7

  network_acls {
      default_action             = "Deny"
      bypass                     = "AzureServices"
      virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
      ip_rules                   = ["181.65.101.189"]
  }

}

#Create Storage Account
resource "azurerm_storage_account" "stg" {
  name                     = var.stg_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  #enable_https_traffic_only = true
  tags                     = var.tags
}

#Create Container
resource "azurerm_storage_container" "stgcnt" {
  name                  = var.stgcnt_name
  storage_account_name  = azurerm_storage_account.stg.name
  container_access_type = "private"
}

resource "azurerm_storage_account_network_rules" "sanr" {
    storage_account_id = azurerm_storage_account.stg.id
    
    default_action = "Deny"
    ip_rules = ["181.65.101.189"]
    virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
    bypass = ["AzureServices"]
}
