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

  vpc_lattice_configurations {
    port_name        = "nginx-80"
    role_arn         = module.ecs_infrastructure_role.iam_role_arn
    target_group_arn = var.vpc_lattice_target_group_arn
  }
}