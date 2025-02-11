module "eks_cluster" {
  source = "./eks-module"

  region       = "us-east-1"
  cluster_name = "my-eks-cluster"
  vpc_id       = "vpc-0123456789abcdef0"
  subnet_ids   = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]

  kubernetes_version          = "1.32"
  general_purpose_desired_size = 2
  general_purpose_max_size     = 3
  general_purpose_min_size     = 1
  system_desired_size          = 1
  system_max_size              = 2
  system_min_size              = 1

  cluster_admin_arn = "arn:aws:iam::123456789012:user/admin"
}

output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}