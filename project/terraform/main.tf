module "eks" {
  source = "./eks"
}

output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "eks_cluster_ca" {
  value = module.eks.eks_cluster_ca
}

output "aws_load_balancer_controller_role_arn" {
  value = module.eks.aws_load_balancer_controller_role_arn
}

module "helm" {
  source = "./helm"

  eks_cluster_name      = module.eks.eks_cluster_name
  eks_cluster_endpoint  = module.eks.eks_cluster_endpoint
  eks_cluster_ca        = module.eks.eks_cluster_ca

  aws_lb_controller_role_arn = module.eks.aws_load_balancer_controller_role_arn
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = module.eks.eks_cluster_name
}

provider "helm" {
  kubernetes {
    host                   = module.eks.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.eks_cluster_ca)
    token                  = data.aws_eks_cluster_auth.eks_cluster.token
  }

}

provider "kubernetes" {
  host = module.eks.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_cluster_ca)
  token = data.aws_eks_cluster_auth.eks_cluster.token
}

resource "null_resource" "wait_for_eks" {
  depends_on = [data.aws_eks_cluster_auth.eks_cluster]
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}
