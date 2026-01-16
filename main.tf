/*
 *
 * @desc: VPC resources
 *
 */
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    tags = {
        Name        = "${var.environment}-vpc"
        Environment = var.environment
    }
}

/*
 *
 * @desc: Internet Gateway (IGW)
 *
 */
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name        = "${var.environment}-igw"
        Environment = var.environment
    }
}

/*
 *
 * @desc: Subnets (public)
 *
 */
resource "aws_subnet" "public_a" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = var.az_a

    tags = {
        Name        = "${var.environment}-public-a"
        Environment = var.environment
    }
}

resource "aws_subnet" "public_b" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = var.az_b

    tags = {
        Name        = "${var.environment}-public-b"
        Environment = var.environment
    }
}

/*
 *
 * @desc: Subnets (private)
 *
 */
resource "aws_subnet" "private_a" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.10.0/24"
    availability_zone = var.az_a

    tags = {
        Name        = "${var.environment}-private-a"
        Environment = var.environment
    }
}

resource "aws_subnet" "private_b" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.20.0/24"
    availability_zone = var.az_b

    tags = {
        Name        = "${var.environment}-private-b"
        Environment = var.environment
    }
}

/*
 *
 * @desc: Elastic IPs (EIPs) for NAT Gateways
 *
 */
resource "aws_eip" "nat_a" {
    domain = "vpc"

    tags = {
        Name        = "${var.environment}-nat_a-eip"
        Environment = var.environment
    }
}

resource "aws_eip" "nat_b" {
    domain = "vpc"

    tags = {
        Name        = "${var.environment}-nat_b-eip"
        Environment = var.environment
    }
}

/*
 *
 * @desc: NAT Gateways
 *
 */
resource "aws_nat_gateway" "nat_a" {
    allocation_id = aws_eip.nat_a.id
    subnet_id     = aws_subnet.public_a.id

    tags = {
        Name        = "${var.environment}-nat_a"
        Environment = var.environment
    }

    depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "nat_b" {
    allocation_id = aws_eip.nat_b.id
    subnet_id = aws_subnet.public_b.id

    tags = {
        Name = "${var.environment}-nat_b"
        Environment = var.environment
    }

    depends_on = [aws_internet_gateway.main]
}

/*
 *
 * @desc: Public Route Table - routes to IGW
 *
 */
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

/*
 *
 * @desc: Private Route Tables - routes to NAT Gateway
 *
 */
resource "aws_route_table" "private_a" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_a.id
    }

    tags = {
        Name        = "${var.environment}-rt-private_a"
        Environment = var.environment
    }
}

resource "aws_route_table" "private_b" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_b.id
    }

    tags = {
        Name = "${var.environment}-rt-private_b"
        Environment = var.environment
    }
}

/*
 *
 * @desc: Route Table Associations
 *
 */
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