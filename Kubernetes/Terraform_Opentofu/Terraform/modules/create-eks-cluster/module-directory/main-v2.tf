provider "aws" {
  region = var.region
}

# Create the VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

# Create Subnets
resource "aws_subnet" "eks_subnets" {
  count                   = length(var.subnet_cidr_blocks)
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.cluster_name}-subnet-${count.index}"
  }
}

# Create the EKS Cluster IAM Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# Attach Recommended Policies to the EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

# Create the EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = aws_subnet.eks_subnets[*].id
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSVPCResourceController,
  ]
}

# Create a Security Group for the EKS Cluster
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to specific IPs in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-eks-cluster-sg"
  }
}

# Create the EKS Node IAM Role
resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach Recommended Policies to the EKS Node Role
resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

# Create SSH Key for Node Group Access
resource "aws_key_pair" "eks_ssh_key" {
  key_name   = "eks_ssh_key"
  public_key = file(var.ssh_public_key_path) # Path to the public key file
}

# Create General Purpose Node Pool
resource "aws_eks_node_group" "general_purpose_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-general-purpose-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.eks_subnets[*].id

  scaling_config {
    desired_size = var.general_purpose_desired_size
    max_size     = var.general_purpose_max_size
    min_size     = var.general_purpose_min_size
  }

  instance_types = ["t3.medium"]

  # Ensure the node group can join the cluster
  remote_access {
    ec2_ssh_key = aws_key_pair.eks_ssh_key.key_name
  }

  tags = {
    Name = "${var.cluster_name}-general-purpose-node-group"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy,
  ]
}

# Create System Node Pool
resource "aws_eks_node_group" "system_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-system-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.eks_subnets[*].id

  scaling_config {
    desired_size = var.system_desired_size
    max_size     = var.system_max_size
    min_size     = var.system_min_size
  }

  instance_types = ["t3.medium"]

  # Ensure the node group can join the cluster
  remote_access {
    ec2_ssh_key = aws_key_pair.eks_ssh_key.key_name
  }

  tags = {
    Name = "${var.cluster_name}-system-node-group"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy,
  ]
}

# Allow Cluster Administrator Access
resource "aws_eks_access_entry" "cluster_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = var.cluster_admin_arn

  # Ensure the principal_arn is in the correct format
  lifecycle {
    precondition {
      condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/", var.cluster_admin_arn))
      error_message = "The principal_arn must be a valid IAM role ARN."
    }
  }

  depends_on = [aws_eks_cluster.eks_cluster]
}