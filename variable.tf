variable "resource_group_name" {
}

variable "vnet_name" {
}

variable "subnet_name" {
}

variable "nsg_name" {
}

variable "security_rules" {
}

variable "location" {
}

/* Variable used for all objects */
variable "tags" {
}

variable "default_network_rule" {
}

variable "ip_rules" {
  type    = map(string)
  default = {}
}

variable "service_endpoints" {
  type    = map(string)
  default = {}
}

variable "stg_name" {
}

variable "account_tier" {
}

variable "account_replication_type" {
}

variable "stgcnt_name" {
}


#############################################

variable "kvname" {
}

variable "kvsname" {
}

#############################################
