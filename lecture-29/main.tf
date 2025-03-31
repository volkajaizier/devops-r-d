resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
    }
}

data "aws_availability_zone" "available" {
  state = "available"
  name = "eu-west-3a"
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24" 
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zone.available.name
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public.id
}

resource "aws_security_group" "my_sg" {
    vpc_id = aws_vpc.my_vpc.id
    description = "Allow SSH, HTTPS"
ingress = [
  {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  },
  {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
]

egress = [
  {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
]
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "public_rt" {
  route_table_id = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "prt" {
  subnet_id =  aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_instance" "public_instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_instance-profile.name
  security_groups = [aws_security_group.my_sg.id]
  key_name = "devops"
}

resource "aws_iam_role" "ec2_role" {
    name = "ec2_s3_access_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "s3_readonly" {
    name = "s3_readonly_policy_attachment"
    roles = [aws_iam_role.ec2_role.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_instance-profile" {
    name = "ec2_intance_profile"
    role = aws_iam_role.ec2_role.name
}

resource "aws_s3_bucket" "my_bucket" {

    bucket = "${var.bucket_name}-${random_id.unique_id.hex}"
    tags = {
    Name = "MyBucket"
  }
}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "random_id" "unique_id" {
  byte_length = 4
}