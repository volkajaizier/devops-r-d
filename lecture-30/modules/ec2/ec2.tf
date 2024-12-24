variable "subnet_id" {
  description = "Subnet ID"
  type = string
}

variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t2.micro"
}

variable "ami_id" {
    description = "AMI ID"  
    type =  string
}

resource "aws_instance" "instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_id

    tags = {
        name = "main-instance"
    }
}