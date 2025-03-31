variable "aws_region" {
  default     = "eu-west-3"
  description = "AWS region"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "key_name" {
  default = "devops"
}

variable "availability_zones" {
  default = ["eu-west-3a", "eu-west-3b"]
}