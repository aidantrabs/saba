terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
}

# configuration for the AWS provider
provider "aws" {
    region = "us-east-1"
}