variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "name_suffix" { type = string }
variable "app_subnet_id" { type = string }
variable "ssh_allowed_cidrs" { 
  type = list(string) 
  validation {
    condition = length(var.ssh_allowed_cidrs) > 0 && alltrue([
      for c in var.ssh_allowed_cidrs :
      can(cidrhost(c, 0)) && c != "0.0.0.0/0"
    ])
    error_message = "Provide valid CIDRs, and none may be 0.0.0.0/0."
  }
}

