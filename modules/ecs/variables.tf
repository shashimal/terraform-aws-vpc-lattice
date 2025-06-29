variable "app_name" {
  description = "Application name"
  type = string
}

variable "private_subnets" {
  description = "Private subnets"
  type = list(string)
}

variable "security_group_ids" {
  description = "Security group ids"
  type = list(string)
}

variable "desired_count" {
  description = "Desired task counts"
  type = number
  default = 1
}

variable "vpc_lattice_target_group_arn" {
  description = "VPC Lattice target group arn"
  type = string
}