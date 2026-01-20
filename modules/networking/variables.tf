/*
 *
 * @desc: networking module variables
 *
 */

variable "environment" {
    type        = string
    description = "Environment name for resource tagging"
}

variable "vpc_cidr" {
    type        = string
    description = "CIDR block for the VPC"
}

variable "az_a" {
    type        = string
    description = "First availability zone"
}

variable "az_b" {
    type        = string
    description = "Second availability zone"
}

variable "public_subnet_a_cidr" {
    type        = string
    description = "CIDR block for public subnet A"
    default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
    type        = string
    description = "CIDR block for public subnet B"
    default     = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
    type        = string
    description = "CIDR block for private subnet A"
    default     = "10.0.10.0/24"
}

variable "private_subnet_b_cidr" {
    type        = string
    description = "CIDR block for private subnet B"
    default     = "10.0.20.0/24"
}
