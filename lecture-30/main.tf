module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = "10.0.0.0/16"
}

module "subnets" {
    source = "./modules/subnet"
    vpc_id = module.vpc.vpc_id
    subnets = [{
        name = "public-subnet-1"
        cidr = "10.0.1.0/24"
        az = "eu-west-3a"
    },
    {
        name = "private-subnet-1"
        cidr = "10.0.2.0/24"
        az = "eu-west-3a"
    }
    
    ]
}

module "public_instance" {
    source = "./modules/ec2"
    subnet_id = module.subnets.subnet_ids[0]
    ami_id = "ami-07dc1ccdcec3b4eab"
    instance_type = "t2.micro"
}

module "private_instance" {
    source = "./modules/ec2"
    subnet_id = module.subnets.subnet_ids[1]
    ami_id = "ami-07dc1ccdcec3b4eab"
    instance_type = "t2.micro"
}

resource "aws_vpc" "imported" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_instance" "imported" {
  instance_type = "t2.micro"
  ami = "ami-07dc1ccdcec3b4eab"
}