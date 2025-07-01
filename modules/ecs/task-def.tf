resource "aws_ecs_task_definition" "task_def" {
  family                = var.app_name
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 256
  memory = 512

  execution_role_arn = module.ecs_task_execution_role.iam_role_arn
  task_role_arn = module.ecs_task_role.iam_role_arn

  container_definitions = jsonencode([
    {
      name  = var.app_name
      image = "nginx:latest" # Replace with your container image
      portMappings = [
        {
          name = "nginx-80"
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"

        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/${var.app_name}-logs"

  tags = {
    Application = "shared-app"
  }
}