variable "vpc_cidr" {
    type        = string
    description = "VPC CIDR block"
    default     = "10.0.0.0/16"
}

variable "environment" {
    type        = string
    description = "Environment name for resource tagging"
    default     = "dev"
}

variable "aws_region" {
    type        = string
    description = "AWS region"
    default     = "us-east-1"
}

variable "az_a" {
    type        = string
    description = "Availability Zone A"
    default     = "us-east-1a"
}

variable "az_b" {
    type        = string
    description = "Availability Zone B"
    default     = "us-east-1b"
}

variable "ami_name_filter" {
    type = string
    description = "AMI name filter pattern"
    default = "al2023-ami-*-x86_64"
}

variable "ami_owner" {
    type = string
    description = "AMI owner (AWS account ID or alias)"
    default = "amazon"
}

variable "instance_type" {
    type = string
    description = "EC2 instance type"
    default = "t3.micro"
}