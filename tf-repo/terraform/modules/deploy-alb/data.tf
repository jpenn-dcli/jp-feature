data "aws_security_group" "selected" {
  name = "my-security-group"
}

data "aws_subnet_ids" "selected" {
  vpc_id = "vpc-12345678"
}