variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}

variable "internal" {
  description = "Is the ALB internal input true or if the ALB is internet-facing input false"
  type        = bool
}

variable "security_group_name" {
  description = "The name of the security group to associate with the ALB"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the subnets are located"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB, true or false"
  type        = bool
}

variable "tags" {
  description = "A map of tags to assign to the ALB"
  type        = map(string)
  default     = {
    Environment = "production"
    Name        = "my-app-alb"
  }
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate for the HTTPS listener"
  type        = string
}

variable "ssl_policy" {
  description = "The SSL policy for the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}