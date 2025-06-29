resource "aws_vpclattice_target_group" "target_group" {
  name = "${local.app_name}-nginx"
  type = "IP"

  config {
    vpc_identifier = module.vpc.vpc_id

    ip_address_type  = "IPV4"
    port             = 80
    protocol         = "HTTP"
    protocol_version = "HTTP1"

    health_check {
      enabled                       = true
      health_check_interval_seconds = 20
      health_check_timeout_seconds  = 10
      healthy_threshold_count       = 7
      unhealthy_threshold_count     = 3

      matcher {
        value = "200-299"
      }

      path             = "/"
      port             = 80
      protocol         = "HTTP"
      protocol_version = "HTTP1"
    }
  }
}