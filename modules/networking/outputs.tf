/*
 *
 * @desc: networking module outputs
 *
 */

output "vpc_id" {
    description = "ID of the VPC"
    value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
    description = "CIDR block of the VPC"
    value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
    description = "List of public subnet IDs"
    value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "private_subnet_ids" {
    description = "List of private subnet IDs"
    value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "public_subnet_a_id" {
    description = "ID of public subnet A"
    value       = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
    description = "ID of public subnet B"
    value       = aws_subnet.public_b.id
}

output "internet_gateway_id" {
    description = "ID of the Internet Gateway"
    value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
    description = "List of NAT Gateway IDs"
    value       = [aws_nat_gateway.nat_a.id, aws_nat_gateway.nat_b.id]
}
