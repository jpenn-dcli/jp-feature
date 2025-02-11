output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_node_group_names" {
  description = "The names of the EKS node groups"
  value = [
    aws_eks_node_group.general_purpose_node_group.node_group_name,
    aws_eks_node_group.system_node_group.node_group_name
  ]
}

output "eks_ssh_key_name" {
  description = "The name of the SSH key used for node group access"
  value       = aws_key_pair.eks_ssh_key.key_name
}