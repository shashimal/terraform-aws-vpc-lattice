variable "name" {
  type        = string
  description = "VPC name"
}

variable "cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
}

variable "database_subnets" {
  type        = list(string)
  description = "Database subnets"
  default = []
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable Nat Gateway"
}

variable "single_nat_gateway" {
  type        = bool
  description = "Single Nat Gateway "
}

variable "public_subnet_tags" {
  description = "Public subnet tags"
  type = map(string)
  default = {}
}

variable "private_subnet_tags" {
  description = "Private subnet tags"
  type = map(string)
  default = {}
}