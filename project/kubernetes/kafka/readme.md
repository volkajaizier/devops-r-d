aws s3 mb s3://kafka-access-logs-bucket --region eu-west-3
kubectl create namespace prod
helm install strimzi strimzi/strimzi-kafka-operator -f values.yaml -n prod --version="0.29.0"

kubectl label node ip-10-0-4-176.eu-west-3.compute.internal node=kafka
kubectl apply -f kafka-persistent.yaml -n prod

module "helm" {
  source = "./helm"

  eks_cluster_name      = module.eks.cluster_name
  eks_cluster_endpoint  = module.eks.cluster_endpoint
  eks_cluster_ca        = module.eks.cluster_ca

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  depends_on = [module.eks]
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
  }
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca)
    token                  = data.aws_eks_cluster_auth.eks_cluster.token
  }
}