locals {
  app_name = "ecs-lattice"

  #VPC
  azs              = ["ap-southeast-1a", "ap-southeast-1b"]
  cidr             = "10.0.0.0/16"
  private_subnets  = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets   = ["10.0.64.0/19", "10.0.96.0/19"]
  database_subnets = ["10.0.128.0/19", "10.0.160.0/19"]
}

################################################################################
# Setup a VPC
################################################################################
module "vpc" {
  source = "../modules/vpc"

  name               = "${local.app_name}-vpc"
  azs                = local.azs
  cidr               = local.cidr
  private_subnets    = local.private_subnets
  public_subnets     = local.public_subnets
  database_subnets   = local.database_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
}

module "ecs" {
  source = "../modules/ecs"
  app_name = local.app_name
  private_subnets = module.vpc.private_subnets
  security_group_ids = [module.service_sg.security_group_id]
  vpc_lattice_configurations = {
    port_name        = "nginx-80"
    target_group_arn = aws_vpclattice_target_group.target_group.arn
  }
}

module "service_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = ">= 5.0"

  name   = "${local.app_name}-servcie-sg"
  vpc_id = module.vpc.vpc_id

  ingress_prefix_list_ids = [data.aws_ec2_managed_prefix_list.vpc_lattice.id]

  #ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "https-443-tcp",
    "http-80-tcp"
  ]

  egress_rules = ["all-all"]
}

module "service_network_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = ">= 5.0"

  name   = "${local.app_name}-servcie-sg"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "https-443-tcp",
    "http-80-tcp"
  ]

  egress_rules = ["all-all"]
}