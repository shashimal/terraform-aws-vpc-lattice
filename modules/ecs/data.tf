data "aws_region" "current" {}

data "aws_iam_policy_document" "infrastructure_role" {
  statement {
    sid = "infrastructureRole"
    effect = "Allow"
    actions   = ["iam:PassRole"]
    resources = [module.ecs_infrastructure_role.iam_role_arn]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs.amazonaws.com"]
    }
  }
}