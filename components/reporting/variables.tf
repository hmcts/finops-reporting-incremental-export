variable "environment" {
  type    = string
  default = "sbox"
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "account_replication_type" {
  type    = string
  default = "ZRS"
}

variable "account_kind" {
  type    = string
  default = "StorageV2"
}


variable "product" {
  type    = string
  default = "finops-reporting"
}

variable "env" {}
variable "builtFrom" {}