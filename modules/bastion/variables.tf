/*
 *
 * @desc: Bastion Module Variables
 *
 */

variable "environment" {
    type        = string
    description = "Environment name for resource tagging"
}

variable "vpc_id" {
    type        = string
    description = "ID of the VPC to deploy into"
}

variable "subnet_id" {
    type        = string
    description = "ID of the public subnet for the bastion host"
}

variable "instance_type" {
    type        = string
    description = "EC2 instance type"
    default     = "t3.micro"
}

variable "public_key_path" {
    type        = string
    description = "Path to the SSH public key file"
    default     = "~/.ssh/bastion-key.pub"
}

variable "allowed_ssh_cidr" {
    type        = string
    description = "CIDR block allowed to SSH (restrict in production)"
    default     = "0.0.0.0/0"
}

variable "ami_name_filter" {
    type        = string
    description = "AMI name filter pattern"
    default     = "al2023-ami-*-x86_64"
}

variable "ami_owner" {
    type        = string
    description = "AMI owner account ID or alias"
    default     = "amazon"
}
