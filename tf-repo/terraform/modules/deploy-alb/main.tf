module "alb" {
  source = "./modules/alb"

  alb_name        = "my-app-alb"
  internal        = false
  security_group_ids = [data.aws_security_group.selected.id]
  subnet_ids      = data.aws_subnet_ids.selected.ids
  enable_deletion_protection = true
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234-5678-90ef-ghij-klmnopqrstuv" # Replace with your ACM certificate ARN
  ssl_policy      = "ELBSecurityPolicy-2016-08"

  tags = {
    Environment = "production"
    Name        = "my-app-alb"
  }
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "https_listener_arn" {
  value = module.alb.https_listener_arn
}