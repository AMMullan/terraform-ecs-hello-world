# -----------------------------------------------------------------------------
# AWS Application Load Balancer (ALB)
# -----------------------------------------------------------------------------
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 7.0"

  name = var.name

  load_balancer_type = "application"

  internal = var.internal_alb

  vpc_id          = var.vpc_id
  subnets         = var.subnet_ids
  security_groups = [aws_security_group.hello_frontend.id]

  target_groups = [
    {
      name             = "${var.name}-http"
      backend_protocol = "HTTP"
      backend_port     = var.container_port
      target_type      = "ip"
      health_check = {
        path                = "/"
        healthy_threshold   = 3
        interval            = 60
        unhealthy_threshold = 10
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = merge(var.tags, { "Name" = "${var.name}" })
}
