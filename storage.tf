
terraform {  

    backend "azurerm" {    
        resource_group_name  = "rgTest01"
        storage_account_name = "stgtest01lcabreraa78"
        container_name       = "stgcnttest01"
        key = "terraform.tfstate"
    }
}
