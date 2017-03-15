variable "az_tenant_id" {}
variable "az_client_id" {}
variable "az_client_secret" {}
variable "az_subscription_id" {}
variable "admin_password" {}
variable "location" {
  default = "South Central US"
}
variable "public_key_file" {
  default = "~/asuna-azure.pub"
}
variable "admin_username" {
  default = "asuna"
}
variable "master_count" {
  default = 1
}
variable "agent_count" {
  default = 3
}
variable "agent_size" {
  default = "Standard_A4_v2"
}
