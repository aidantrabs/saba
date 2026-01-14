resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "${var.environment}-vpc"
        Environment = var.environment
    }
}

resource "aws_subnet" "main" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "${var.environment}-vpc"
        Environment = var.environment
    }
}