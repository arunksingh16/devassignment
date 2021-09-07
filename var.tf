#############################################################################
# VARIABLES
#############################################################################

variable "resource_group_name" {
  type = string
  default = "rg-tf-test"
}

variable "prefix" {
  description = "The prefix used for all resources in this example"
  default = "dev"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "subnet_1" {
  type    = string
  default = "subnet1"
}

variable "subnet_2" {
  type    = string
  default = "subnet2"
}

variable "winvmsize" {
  type    = string
  default = "Standard_B2s"
}

variable "ARM_SUBSCRIPTION_ID" {
    type        = string
    description = "ARM_SUBSCRIPTION_ID"
}
variable "ARM_TENANT_ID" {
    type        = string
    description = "ARM_TENANT_ID"
}
variable "ARM_CLIENT_ID" {
    type        = string
    description = "ARM_CLIENT_ID"
}
variable "ARM_CLIENT_SECRET" {
    type        = string
    description = "ARM_CLIENT_SECRET"
}