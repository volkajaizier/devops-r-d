variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "eks_cluster_ca" {
  description = "EKS cluster CA certificate"
  type        = string
}

variable "aws_lb_controller_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller"
  type        = string
}