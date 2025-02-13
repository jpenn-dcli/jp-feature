region            = "us-east-2"
alb_name          = ""
vpc_id            = "vpc-0a9803293dbe65f32" # Replace with your VPC ID
subnet_ids        = ["subnet-", "subnet-"]
enable_deletion_protection = false # true or false
internal          = "" # Is the ALB internal input true or if the ALB is internet-facing input false
security_group_name = ""

tags = {
  Name = "ALB"
  Project = ""
}
