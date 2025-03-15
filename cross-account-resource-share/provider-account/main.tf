locals {
  app_name           = "provider-shared-resource"

  #VPC
  azs              = ["us-east-1a", "us-east-1b"]
  cidr             = "20.0.0.0/16"
  private_subnets  = ["20.0.0.0/19", "20.0.32.0/19"]
  public_subnets   = ["20.0.64.0/19", "20.0.96.0/19"]
  database_subnets = ["20.0.128.0/19", "20.0.160.0/19"]
}

################################################################################
# Setup a VPC
################################################################################
module "vpc" {
  source = "../../modules/vpc"

  name               = "${local.app_name}-vpc"
  azs                = local.azs
  cidr               = local.cidr
  private_subnets    = local.private_subnets
  public_subnets     = local.public_subnets
  database_subnets   = local.database_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
}

################################################################################
# Setup RDS
################################################################################
module "db" {
  source = "../../modules/rds"

  identifier     = "${local.app_name}-db"
  instance_class = "db.t3.micro"

  manage_master_user_password = true
  username                    = "admin"

  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.rds_security_group.security_group_id]
}

################################################################################
# Setup RDS security group
################################################################################
module "rds_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = ">= 5.0"

  name        = "${local.app_name}db-sg"
  description = "RDS security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_cidr_blocks = [
    local.cidr
  ]
}