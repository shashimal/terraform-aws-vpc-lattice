module "ecs_task_execution_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = ">= 5.0"

  create_role = true
  role_requires_mfa = false

  role_name = "${var.app_name}-ecs-task-execution-role"
  trusted_role_services = [
    "ecs-tasks.amazonaws.com"
  ]

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}

module "ecs_task_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = ">= 5.0"

  create_role = true
  role_requires_mfa = false
  role_name = "${var.app_name}-ecs-task-role"
  trusted_role_services = [
    "ecs-tasks.amazonaws.com"
  ]

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

module "ecs_infrastructure_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = ">= 5.0"

  create_role = true
  role_requires_mfa = false
  role_name = "${var.app_name}-ecs-infrastructure-role"
  trusted_role_services = [
    "ecs.amazonaws.com"
  ]

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonECSInfrastructureRolePolicyForVpcLattice",
    aws_iam_policy.ecs_pass_role_policy.arn
  ]
}

resource "aws_iam_policy" "ecs_pass_role_policy" {
  name        = "ECSPassRoleForInfrastructure"
  description = "Allows passing the ecsInfrastructureRole to the ECS service. Required for certain ECS operations."

  policy = data.aws_iam_policy_document.infrastructure_role.json
}