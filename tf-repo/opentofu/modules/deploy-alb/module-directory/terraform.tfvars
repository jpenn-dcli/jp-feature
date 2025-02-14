region            = "us-east-2"
alb_name          = "test-alb"
certificate_arn   = "arn:aws:acm:us-east-2:577638384428:certificate/ce2363ef-8e23-4e50-98cc-31f381178aa1"
vpc_id            = "vpc-0a9803293dbe65f32" # Replace with your VPC ID
subnet_ids        = ["subnet-05d7139419a1fce1d", "subnet-0a00fd7e3c4bf56c8"]
enable_deletion_protection = false # true or false
internal          = "true" # If the ALB is internal input true or if the ALB is internet-facing input false
security_group_name = "default"

tags = {
  Name = "ALB"
  Project = ""
}