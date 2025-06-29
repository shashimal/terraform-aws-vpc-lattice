terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}
resource "aws_ecs_cluster" "cluster" {
  name = "shared-app-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name = aws_ecs_cluster.cluster.name
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 100
  }
}