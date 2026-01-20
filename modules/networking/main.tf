/*
 *
 * @desc: networking module
 *        creates a production-ready VPC with public/private subnets,
 *        NAT Gateways for high availability, and proper routing
 *
 */

# ------------------------------------------------------------------------------
# VPC
# ------------------------------------------------------------------------------

resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name        = "${var.environment}-vpc"
        Environment = var.environment
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name        = "${var.environment}-igw"
        Environment = var.environment
    }
}

# ------------------------------------------------------------------------------
# subnets
# ------------------------------------------------------------------------------

resource "aws_subnet" "public_a" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_a_cidr
    availability_zone       = var.az_a
    map_public_ip_on_launch = true

    tags = {
        Name        = "${var.environment}-public-a"
        Environment = var.environment
        Tier        = "public"
    }
}

resource "aws_subnet" "public_b" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_b_cidr
    availability_zone       = var.az_b
    map_public_ip_on_launch = true

    tags = {
        Name        = "${var.environment}-public-b"
        Environment = var.environment
        Tier        = "public"
    }
}

resource "aws_subnet" "private_a" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_subnet_a_cidr
    availability_zone = var.az_a

    tags = {
        Name        = "${var.environment}-private-a"
        Environment = var.environment
        Tier        = "private"
    }
}

resource "aws_subnet" "private_b" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_subnet_b_cidr
    availability_zone = var.az_b

    tags = {
        Name        = "${var.environment}-private-b"
        Environment = var.environment
        Tier        = "private"
    }
}

# ------------------------------------------------------------------------------
# NAT gateways (one per AZ for high availability)
# ------------------------------------------------------------------------------

resource "aws_eip" "nat_a" {
    domain = "vpc"

    tags = {
        Name        = "${var.environment}-nat-a-eip"
        Environment = var.environment
    }

    depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "nat_b" {
    domain = "vpc"

    tags = {
        Name        = "${var.environment}-nat-b-eip"
        Environment = var.environment
    }

    depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "nat_a" {
    allocation_id = aws_eip.nat_a.id
    subnet_id     = aws_subnet.public_a.id

    tags = {
        Name        = "${var.environment}-nat-a"
        Environment = var.environment
    }

    depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "nat_b" {
    allocation_id = aws_eip.nat_b.id
    subnet_id     = aws_subnet.public_b.id

    tags = {
        Name        = "${var.environment}-nat-b"
        Environment = var.environment
    }

    depends_on = [aws_internet_gateway.main]
}

# ------------------------------------------------------------------------------
# route tables
# ------------------------------------------------------------------------------

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name        = "${var.environment}-rt-public"
        Environment = var.environment
    }
}

resource "aws_route_table" "private_a" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_a.id
    }

    tags = {
        Name        = "${var.environment}-rt-private-a"
        Environment = var.environment
    }
}

resource "aws_route_table" "private_b" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_b.id
    }

    tags = {
        Name        = "${var.environment}-rt-private-b"
        Environment = var.environment
    }
}

# ------------------------------------------------------------------------------
# route table associations
# ------------------------------------------------------------------------------

resource "aws_route_table_association" "public_a" {
    subnet_id      = aws_subnet.public_a.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
    subnet_id      = aws_subnet.public_b.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
    subnet_id      = aws_subnet.private_a.id
    route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
    subnet_id      = aws_subnet.private_b.id
    route_table_id = aws_route_table.private_b.id
}
