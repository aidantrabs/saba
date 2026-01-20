/*
 *
 * @desc: root modules
 *        orchestrates the deployment of a production-ready AWS VPC
 *        with networking infrastructure and a bastion host
 *
 */

module "networking" {
    source = "./modules/networking"

    environment = var.environment
    vpc_cidr    = var.vpc_cidr
    az_a        = var.az_a
    az_b        = var.az_b
}

module "bastion" {
    source = "./modules/bastion"

    environment      = var.environment
    vpc_id           = module.networking.vpc_id
    subnet_id        = module.networking.public_subnet_a_id
    instance_type    = var.instance_type
    public_key_path  = var.public_key_path
    allowed_ssh_cidr = var.allowed_ssh_cidr
}
