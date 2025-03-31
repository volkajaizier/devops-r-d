variable "ami_id" {
  description = "AMI for ec2"
}

variable "instance_type" {
  description = "EC2 type"
  default = "t2.micro"
}

variable "bucket_name" {
  description = "Base name for the S3 bucket"
  type        = string
}