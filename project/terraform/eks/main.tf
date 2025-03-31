terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    name = "eks-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  map_public_ip_on_launch = true
  for_each                = { for idx, cidr in var.public_subnet_cidrs : idx => cidr }
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = each.value
  availability_zone       = element(var.availability_zones, each.key)
  tags = {
    name                                        = "eks-public-subnet-${each.key + 1}"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each          = { for idx, cidr in var.private_subnet_cidrs : idx => cidr }
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = each.value
  availability_zone = element(var.availability_zones, each.key)
  tags = {
    name                                        = "eks-private-subnet-${each.key + 1}"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rt_as" {
  for_each       = aws_subnet.public_subnets
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = each.value.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = values(aws_subnet.public_subnets)[0].id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_rt_as" {
  for_each       = aws_subnet.private_subnets
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = each.value.id
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = concat(
      values(aws_subnet.public_subnets)[*].id,
      values(aws_subnet.private_subnets)[*].id
    )
  }
}

resource "aws_iam_role" "eks_node_group_role" {
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy_1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy_2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy_3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy_4" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy_5" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy_6" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  role      = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy_7" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role      = aws_iam_role.eks_node_group_role.name
}



data "aws_eks_addon_version" "aws_ebs_csi_driver_version" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = aws_eks_cluster.eks_cluster.version
  most_recent        = true
}

#OIDC provider + IAM role for service account for aws-load-balancer-controller

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list   = ["sts.amazonaws.com"]
  thumbprint_list  = ["0E5107483589D91041A8733FBCF0E964152D1E90"]  # Corrected Thumbprint
  url              = "https://oidc.eks.eu-west-3.amazonaws.com/id/DB22D5C778EDEDFF78AE9F06B91CD992"
}


resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/iam-policy.json")
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "aws-load-balancer-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${aws_iam_openid_connect_provider.eks.url}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
  role       = aws_iam_role.aws_load_balancer_controller.name
}





#EKS ADD-ON CONFIGURATION

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "aws-ebs-csi-driver"
  addon_version = data.aws_eks_addon_version.aws_ebs_csi_driver_version.version
  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [ 
    #aws_eks_node_group.verne_mq,
    #aws_eks_node_group.redis,
    #aws_eks_node_group.mysql,
    #aws_eks_node_group.monitoring
    aws_eks_node_group.kafka]

}

resource "aws_security_group" "eks_cluster" {
  vpc_id = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.eks_vpc.cidr_block]  # Allow traffic from within the VPC
  }
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.eks_vpc.cidr_block]  # Allow traffic from within the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_node_communication" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_cluster.id
}

resource "aws_launch_template" "eks_launch_template" {
  name_prefix   = "eks-node-template"
  instance_type = "t3.medium"
  #image_id      = "ami-0c280fc9833c6b0cf"


  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

   block_device_mappings {
     device_name = "/dev/xvda"
     ebs {
       volume_size = 100
       volume_type           = "gp3"
       delete_on_termination = false
     }
   }

  key_name = var.key_name  

}

#resource "aws_eks_node_group" "monitoring" {
#  cluster_name    = aws_eks_cluster.eks_cluster.name
#  node_group_name = "eks-monitoring"
#  node_role_arn   = aws_iam_role.eks_node_group_role.arn
#  subnet_ids      = values(aws_subnet.private_subnets)[*].id
#
#  scaling_config {
#    min_size     = 1
#    max_size     = 1
#    desired_size = 1
#  }
#
#  launch_template {
#    id      = aws_launch_template.eks_launch_template.id
#    version = aws_launch_template.eks_launch_template.latest_version
#  }
#
#  depends_on = [ 
#    aws_iam_role_policy_attachment.eks_worker_policy_1,
#    aws_iam_role_policy_attachment.eks_worker_policy_2,
#    aws_iam_role_policy_attachment.eks_worker_policy_3,
#    aws_iam_role_policy_attachment.eks_worker_policy_4,
#    aws_iam_role_policy_attachment.eks_worker_policy_5,
#    aws_iam_role_policy_attachment.eks_worker_policy_6
#   ]
#}
#
#
resource "aws_eks_node_group" "kafka" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-kafka"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = values(aws_subnet.private_subnets)[*].id

  scaling_config {
    min_size     = 1
    max_size     = 1
    desired_size = 1
  }
  
  launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = aws_launch_template.eks_launch_template.latest_version
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.eks_worker_policy_1,
    aws_iam_role_policy_attachment.eks_worker_policy_2,
    aws_iam_role_policy_attachment.eks_worker_policy_3,
    aws_iam_role_policy_attachment.eks_worker_policy_4,
    aws_iam_role_policy_attachment.eks_worker_policy_5,
    aws_iam_role_policy_attachment.eks_worker_policy_6,
    aws_iam_role_policy_attachment.eks_worker_policy_7
   ]
}
#
#resource "aws_eks_node_group" "redis" {
#  cluster_name    = aws_eks_cluster.eks_cluster.name
#  node_group_name = "eks-redis"
#  node_role_arn   = aws_iam_role.eks_node_group_role.arn
#  subnet_ids      = values(aws_subnet.private_subnets)[*].id
#
#  scaling_config {
#    min_size     = 1
#    max_size     = 1
#    desired_size = 1
#  }
#
#  launch_template {
#    id      = aws_launch_template.eks_launch_template.id
#    version = aws_launch_template.eks_launch_template.latest_version
#  }
#
#  depends_on = [ 
#    aws_iam_role_policy_attachment.eks_worker_policy_1,
#    aws_iam_role_policy_attachment.eks_worker_policy_2,
#    aws_iam_role_policy_attachment.eks_worker_policy_3,
#    aws_iam_role_policy_attachment.eks_worker_policy_4,
#    aws_iam_role_policy_attachment.eks_worker_policy_5
#   ]
#}
#

#resource "aws_db_subnet_group" "mysql" {
#  name       = "mysql-subnet-group"
#  description = "MySQL RDS subnet group"
#  subnet_ids = values(aws_subnet.private_subnets)[*].id
#}
#
#resource "aws_db_instance" "mysql" {
#  allocated_storage    = 20
#  storage_type         = "gp2"
#  engine               = "mysql"
#  engine_version       = "8.0.34"
#  instance_class       = "db.t3.micro"
#  db_name              = "cp_cms"
#  username             = "admin"
#  password             = "admin123"
#  publicly_accessible  = false
#  skip_final_snapshot  = true
#  backup_retention_period = 7
#  vpc_security_group_ids = [aws_security_group.eks_cluster.id]
#  db_subnet_group_name = aws_db_subnet_group.mysql.name
#
#  depends_on = [ aws_eks_addon.aws_ebs_csi_driver ]
#  
#}
#
#resource "aws_db_instance" "timescaledb" {
#  allocated_storage       = 20
#  storage_type            = "gp2"
#  engine                  = "postgres"
#  engine_version          = "12.20"  # Use a compatible PostgreSQL version with TimescaleDB
#  instance_class          = "db.t3.micro"
#  db_name                 = "pointgrab_db"
#  username                = "pgadmin"
#  password                = "admin123"
#  publicly_accessible     = false
#  skip_final_snapshot     = true
#  backup_retention_period = 7
#  vpc_security_group_ids  = [aws_security_group.eks_cluster.id]
#  db_subnet_group_name    = aws_db_subnet_group.mysql.name
#
#  depends_on = [aws_eks_addon.aws_ebs_csi_driver]
#}
#
#resource "aws_eks_node_group" "mysql" {
#  cluster_name    = aws_eks_cluster.eks_cluster.name
#  node_group_name = "eks-mysql"
#  node_role_arn   = aws_iam_role.eks_node_group_role.arn
#  subnet_ids      = values(aws_subnet.private_subnets)[*].id
#
#  scaling_config {
#    min_size     = 1
#    max_size     = 1
#    desired_size = 1
#  }
#
#  launch_template {
#    id      = aws_launch_template.eks_launch_template.id
#    version = aws_launch_template.eks_launch_template.latest_version
#  }
#
#  depends_on = [ 
#    aws_iam_role_policy_attachment.eks_worker_policy_1,
#    aws_iam_role_policy_attachment.eks_worker_policy_2,
#    aws_iam_role_policy_attachment.eks_worker_policy_3,
#    aws_iam_role_policy_attachment.eks_worker_policy_4,
#    aws_iam_role_policy_attachment.eks_worker_policy_5
#   ]
#}
#
#resource "aws_eks_node_group" "tsdb" {
#  cluster_name    = aws_eks_cluster.eks_cluster.name
#  node_group_name = "eks-tsdb"
#  node_role_arn   = aws_iam_role.eks_node_group_role.arn
#  subnet_ids      = values(aws_subnet.private_subnets)[*].id
#
#  scaling_config {
#    min_size     = 1
#    max_size     = 2
#    desired_size = 1
#  }
#
#  instance_types = ["t3.medium"]
#
#  remote_access {
#    ec2_ssh_key = var.key_name
#  }
#}
#
#resource "aws_eks_node_group" "verne_mq" {
#  cluster_name    = aws_eks_cluster.eks_cluster.name
#  node_group_name = "eks-verne-mq"
#  node_role_arn   = aws_iam_role.eks_node_group_role.arn
#  subnet_ids      = values(aws_subnet.public_subnets)[*].id
#
#  scaling_config {
#    min_size     = 1
#    max_size     = 1
#    desired_size = 1
#  }
#
#  launch_template {
#    id      = aws_launch_template.eks_launch_template.id
#    version = aws_launch_template.eks_launch_template.latest_version
#  }
#
#  depends_on = [ 
#    aws_iam_role_policy_attachment.eks_worker_policy_1,
#    aws_iam_role_policy_attachment.eks_worker_policy_2,
#    aws_iam_role_policy_attachment.eks_worker_policy_3,
#    aws_iam_role_policy_attachment.eks_worker_policy_4,
#    aws_iam_role_policy_attachment.eks_worker_policy_5
#   ]
#}
#
#resource "aws_eks_node_group" "elasticsearch" {
#  cluster_name    = aws_eks_cluster.eks_cluster.name
#  node_group_name = "eks-elasticsearch"
#  node_role_arn   = aws_iam_role.eks_node_group_role.arn
#  subnet_ids      = values(aws_subnet.public_subnets)[*].id
#
#  scaling_config {
#    min_size     = 1
#    max_size     = 1
#    desired_size = 1
#  }
#
#  instance_types = ["t3.medium"]
#
#  remote_access {
#    ec2_ssh_key = var.key_name
#  }
#}
#
#resource "aws_eks_node_group" "cp_cms" {
#  cluster_name    = aws_eks_cluster.eks_cluster.name
#  node_group_name = "eks-cp_cms"
#  node_role_arn   = aws_iam_role.eks_node_group_role.arn
#  subnet_ids      = values(aws_subnet.private_subnets)[*].id
#
#  scaling_config {
#    min_size     = 1
#    max_size     = 1
#    desired_size = 1
#  }
#
#  instance_types = ["t3.medium"]
#
#  remote_access {
#    ec2_ssh_key = var.key_name
#  }
#}
#