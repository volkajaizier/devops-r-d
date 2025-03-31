output "eks_cluster_endpoint" {
  value       = aws_eks_cluster.eks_cluster.endpoint
  description = "EKS endpoint"
}

output "eks_cluster_ca" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "aws_load_balancer_controller_role_arn" {
  value = aws_iam_role.aws_load_balancer_controller.arn
}