# Fetch the security group by name
data "aws_security_group" "selected" {
  name = var.security_group_name
}

# Fetch the subnets by VPC ID
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

# ALB Module to create the Application Load Balancer
module "alb" {
  source = "./modules/alb"

  alb_name                   = var.alb_name
  internal                   = var.internal
  security_group_ids         = [data.aws_security_group.selected.id]
  subnet_ids                 = data.aws_subnets.selected.ids
  enable_deletion_protection = var.enable_deletion_protection
  certificate_arn            = module.acm_module.certificate_arn  # Use the ACM module's output
  ssl_policy                 = var.ssl_policy

  tags = var.tags
}

# Outputs
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "https_listener_arn" {
  value = module.alb.https_listener_arn
}

output "acm_certificate_arn" {
  value = module.acm_module.certificate_arn
}