variable "alb_name" {
  description = "The name of the ALB"
  type        = string
  default = "value"
}

variable "internal" {
  description = "If the ALB internal input true or if the ALB is internet-facing input false"
  type        = bool
  default = true
}

variable "security_group_name" {
  description = "The name of the security group to associate with the ALB"
  type        = string
  default = "default"
}

variable "vpc_id" {
  description = "The ID of the VPC where the subnets are located"
  type        = string
  default = "value"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB, true or false"
  type        = bool
  default     = true
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
  default     = ""
}

variable "ssl_policy" {
  description = "The SSL policy for the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable  "subnet_ids" {
  description = "Id number of subnet"
  type = list(string)
  default = ["subnet-05d7139419a1fce1d", "subnet-0a00fd7e3c4bf56c8"]
}

variable "region" {
  description = "Account region"
  type        = string
}