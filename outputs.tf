/*
 *
 * @desc: root module outputs
 *
 */

# ------------------------------------------------------------------------------
# networking
# ------------------------------------------------------------------------------

output "vpc_id" {
    description = "ID of the VPC"
    value       = module.networking.vpc_id
}

output "public_subnet_ids" {
    description = "List of public subnet IDs"
    value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
    description = "List of private subnet IDs"
    value       = module.networking.private_subnet_ids
}

output "nat_gateway_ids" {
    description = "List of NAT Gateway IDs"
    value       = module.networking.nat_gateway_ids
}

# ------------------------------------------------------------------------------
# bastion
# ------------------------------------------------------------------------------

output "bastion_public_ip" {
    description = "Public IP of the bastion host"
    value       = module.bastion.public_ip
}

output "bastion_instance_id" {
    description = "Instance ID of the bastion host"
    value       = module.bastion.instance_id
}
