variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.16.0.0/16"
}

variable "subnet_cidr_blocks" {
  description = "The CIDR blocks for the subnets"
  type        = list(string)
  default     = ["10.16.1.0/24", "10.16.2.0/24", "10.16.3.0/24"]
}

variable "availability_zones" {
  description = "The availability zones for the subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "ssh_public_key_path" {
  description = "The path to the public SSH key file"
  type        = string
  default     = "/home/ssm-user/.ssh/eks_ssh_key.pub"
}

variable "general_purpose_desired_size" {
  description = "The desired size of the general-purpose node group"
  type        = number
}

variable "general_purpose_max_size" {
  description = "The maximum size of the general-purpose node group"
  type        = number
}

variable "general_purpose_min_size" {
  description = "The minimum size of the general-purpose node group"
  type        = number
}

variable "system_desired_size" {
  description = "The desired size of the system node group"
  type        = number
}

variable "system_max_size" {
  description = "The maximum size of the system node group"
  type        = number
}

variable "system_min_size" {
  description = "The minimum size of the system node group"
  type        = number
}

variable "cluster_admin_arn" {
  description = "The ARN of the IAM role or user for cluster admin access"
  type        = string
}