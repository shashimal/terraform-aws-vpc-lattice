resource "aws_vpclattice_service" "nginx_service" {
  name               = "${local.app_name}-nginx-service"
  auth_type          = "NONE"
  custom_domain_name = "nginx.duleendra.com"
}

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

resource "aws_vpclattice_listener" "listener" {
  name               = "nginx"
  protocol           = "HTTP"
  service_identifier = aws_vpclattice_service.nginx_service.id
  default_action {
    forward {
      target_groups {
        target_group_identifier = aws_vpclattice_target_group.target_group.id
      }
    }
  }
}

resource "aws_vpclattice_listener_rule" "listener_rule" {
  name                = "test"
  listener_identifier = aws_vpclattice_listener.listener.arn
  service_identifier  = aws_vpclattice_service.nginx_service.id
  priority            = 1
  match {
    http_match {
      path_match {
        match {
          exact = "/test"
        }
        case_sensitive = false
      }
    }
  }

  action {
    forward {
      target_groups {
        target_group_identifier = aws_vpclattice_target_group.target_group.id
        weight                  = 1
      }
    }
  }
}

resource "aws_vpclattice_service_network" "shared_network" {
  name      = "shared-app"
  auth_type = "NONE"
}

resource "aws_vpclattice_service_network_service_association" "service_association" {
  service_identifier         = aws_vpclattice_service.nginx_service.id
  service_network_identifier = aws_vpclattice_service_network.shared_network.id
}

resource "aws_vpclattice_service_network_vpc_association" "vpc_association" {
  vpc_identifier             = module.vpc.vpc_id
  service_network_identifier = aws_vpclattice_service_network.shared_network.id
  security_group_ids         = [module.service_network_sg.security_group_id]
}