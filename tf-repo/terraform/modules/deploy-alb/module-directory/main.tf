# Fetch the security group by name
data "aws_security_group" "selected" {
  name = var.security_group_name
}

# Fetch the subnets by VPC ID using the updated data source
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# ACM Module to fetch or create the certificate
module "acm_module" {
  source = "../modules/acm"
  # Add any required variables for the ACM module here
}

# Create the ALB
resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.selected.id]
  subnets            = data.aws_subnets.selected.ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

# HTTP Listener (Port 80)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener (Port 443)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = module.acm_module.certificate_arn # reference the output from another module

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}
