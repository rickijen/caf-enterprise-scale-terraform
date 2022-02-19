#
# subscriptions
#
variable "subscription_id_identity" {
  type    = string
  default = "xxx"
}

variable "subscription_id_management" {
  type    = string
  default = "xxx"
}

variable "subscription_id_connectivity" {
  type    = string
  default = "xxx"
}

#
# Management Group root id & name
#
variable "root_id" {
  type    = string
  default = "redondo"
}

variable "root_name" {
  type    = string
  default = "Redondo Beach"
}

#
# Alert
#
variable "security_alerts_email_address" {
  type    = string
  default = "my_valid_security_contact@replace_me" # Replace this value with your own email address.
}

#
# Log retention in days
#
variable "log_retention_in_days" {
  type    = number
  default = 50
}

#
# Connectivity
#
variable "deploy_connectivity_resources" {
  type    = bool
  default = true
}

variable "connectivity_resources_location" {
  type    = string
  default = "westus2"
}

variable "connectivity_resources_location_paired" {
  type    = string
  default = "westcentralus"
}

variable "connectivity_resources_tags" {
  type = map(string)
  default = {
    resource_type = "connectivity"
  }
}

#
# Identity
#
variable "deploy_identity_resources" {
  type    = bool
  default = true
}

#
# Management
#
variable "deploy_management_resources" {
  type    = bool
  default = true
}

variable "management_resources_location" {
  type    = string
  default = "westus2"
}

variable "management_resources_tags" {
  type = map(string)
  default = {
    resource_type = "management"
  }
}
