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

resource "aws_security_group" "eks_cluster" {
  vpc_id = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-monitoring"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = values(aws_subnet.public_subnets)[*].id

  scaling_config {
    min_size     = 1
    max_size     = 1
    desired_size = 1
  }

  instance_types = ["t3.medium"]

  disk_size = 100

  remote_access {
    ec2_ssh_key = var.key_name
  }
}

resource "aws_eks_node_group" "eks_nginx" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-nginx"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = values(aws_subnet.public_subnets)[*].id

  scaling_config {
    min_size     = 1
    max_size     = 1
    desired_size = 1
  }

  instance_types = ["t3.medium"]

  disk_size = 100

  remote_access {
    ec2_ssh_key = var.key_name
  }
  
}
