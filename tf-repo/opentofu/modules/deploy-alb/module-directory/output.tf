# Output the ALB DNS name
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}

# Output the ALB ARN
output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.this.arn
}

# Output the ALB Zone ID
output "alb_zone_id" {
  description = "The canonical hosted zone ID of the Application Load Balancer"
  value       = aws_lb.this.zone_id
}

# Output the HTTP Listener ARN
output "http_listener_arn" {
  description = "The ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

# Output the HTTPS Listener ARN
output "https_listener_arn" {
  description = "The ARN of the HTTPS listener"
  value       = aws_lb_listener.https.arn
}

# Output the Security Group ID
output "security_group_id" {
  description = "The ID of the security group associated with the ALB"
  value       = data.aws_security_group.selected.id
}

# Output the Subnet IDs
output "subnet_ids" {
  description = "The IDs of the subnets associated with the ALB"
  value       = data.aws_subnets.selected.ids
}