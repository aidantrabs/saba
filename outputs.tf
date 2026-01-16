output "vpc_id" {
    description = "ID of the VPC"
    value       = aws_vpc.main.id
}

output "public_subnet_a_id" {
    description = "ID of public subnet A"
    value       = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
    description = "ID of public subnet B"
    value       = aws_subnet.public_b.id
}

output "private_subnet_a_id" {
    description = "ID of private subnet A"
    value       = aws_subnet.private_a.id
}

output "private_subnet_b_id" {
    description = "ID of private subnet B"
    value       = aws_subnet.private_b.id
}

output "nat_gateway_id_a" {
    description = "ID of the NAT Gateway (private a)"
    value       = aws_nat_gateway.nat_a.id
}

output "nat_gateway_id_b" {
    description = "ID of the NAT Gateway (private b)"
    value       = aws_nat_gateway.nat_b.id
}

output "internet_gateway_id" {
    description = "ID of the Internet Gateway"
    value       = aws_internet_gateway.main.id
}

output "bastion_public_ip" {
    description = "Public IP of the bastion host"
    value       = aws_instance.ec2.public_ip
}