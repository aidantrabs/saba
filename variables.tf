/*
 *
 * @desc: root modules variables
 *
 */

# ------------------------------------------------------------------------------
# general
# ------------------------------------------------------------------------------

variable "environment" {
    type        = string
    description = "Environment name (dev, staging, prod)"
    default     = "dev"
}

variable "aws_region" {
    type        = string
    description = "AWS region for deployment"
    default     = "us-east-1"
}

# ------------------------------------------------------------------------------
# networking
# ------------------------------------------------------------------------------

variable "vpc_cidr" {
    type        = string
    description = "CIDR block for the VPC"
    default     = "10.0.0.0/16"
}

variable "az_a" {
    type        = string
    description = "First availability zone"
    default     = "us-east-1a"
}

variable "az_b" {
    type        = string
    description = "Second availability zone"
    default     = "us-east-1b"
}

# ------------------------------------------------------------------------------
# bastion
# ------------------------------------------------------------------------------

variable "instance_type" {
    type        = string
    description = "EC2 instance type for bastion host"
    default     = "t3.micro"
}

variable "public_key_path" {
    type        = string
    description = "Path to SSH public key for bastion access"
    default     = "~/.ssh/bastion-key.pub"
}

variable "allowed_ssh_cidr" {
    type        = string
    description = "CIDR block allowed to SSH to bastion (restrict in production)"
    default     = "0.0.0.0/0"
}
