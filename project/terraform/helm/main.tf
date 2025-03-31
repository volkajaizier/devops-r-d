
resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.aws_lb_controller_role_arn
    }
  }
  automount_service_account_token = true

  depends_on = [null_resource.wait_for_eks]
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = var.eks_cluster_name
}

resource "null_resource" "wait_for_eks" {
  depends_on = [data.aws_eks_cluster_auth.eks_cluster]

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region eu-west-3 --name ${var.eks_cluster_name}
      echo "Waiting for EKS API to become available..."
      sleep 60
    EOT
  }
}



resource "helm_release" "aws_load_balancer_controller" {
  depends_on = [ null_resource.wait_for_eks ]

  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.5.3"

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws_load_balancer_controller.metadata[0].name
  }
}