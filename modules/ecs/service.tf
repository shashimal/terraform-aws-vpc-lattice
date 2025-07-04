resource "aws_ecs_service" "service" {
  name = var.app_name
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  launch_type     = "FARGATE"
  desired_count = var.desired_count

  network_configuration {
    subnets = var.private_subnets
    assign_public_ip = false
    security_groups = var.security_group_ids
  }

  dynamic "vpc_lattice_configurations" {
    for_each = length(var.vpc_lattice_configurations) != 0 ? [true]: []

    content {
      port_name        = var.vpc_lattice_configurations["port_name"]
      role_arn         = module.ecs_infrastructure_role.iam_role_arn
      target_group_arn = var.vpc_lattice_configurations["target_group_arn"]
    }
  }
}