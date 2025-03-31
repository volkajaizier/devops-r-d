variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "subnets" {
  description = "List of subnets with their CIDRs"
  type = list(object({
    name = string
    cidr = string
    az = string
  }))
}

resource "aws_subnet" "cloud_subnet" {
  for_each = {for subnet in var.subnets : subnet.name => subnet}

  vpc_id = var.vpc_id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true
  tags = {
    Name = each.key
  }
}

output "subnet_ids" {
  value = values(aws_subnet.cloud_subnet)[*].id
}

