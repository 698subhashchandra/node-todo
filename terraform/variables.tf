variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0866a3c8686eaeeba"
}

variable "subnet_id" {
  type = string
  default = "subnet-09e1de95b467ec86b"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.medium"
}