variable "vpc_cidr" {
    type = string
    description = "VPC CIDR blcok"
    default = "10.0.0.0/16"
}

variable "environment" {
    type = string
    description = "Environment (Resource naming / tags)"
    default = "dev"
}

variable "aws_region" {
    type = string
    description = "AWS provider region"
    default = "us-east-1"
}