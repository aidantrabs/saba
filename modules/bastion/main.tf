/*
 *
 * @desc: bastion module
 *        creates a secure jump server for SSH access to private resources
 *        includes security group and EC2 instance configuration
 *
 */

# ------------------------------------------------------------------------------
# security group
# ------------------------------------------------------------------------------

resource "aws_security_group" "bastion" {
    name        = "${var.environment}-bastion-sg"
    description = "Security group for bastion host - allows SSH access"
    vpc_id      = var.vpc_id

    tags = {
        Name        = "${var.environment}-bastion-sg"
        Environment = var.environment
    }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
    security_group_id = aws_security_group.bastion.id
    description       = "SSH access"
    from_port         = 22
    to_port           = 22
    ip_protocol       = "tcp"
    cidr_ipv4         = var.allowed_ssh_cidr

    tags = {
        Name = "${var.environment}-bastion-ssh-ingress"
    }
}

resource "aws_vpc_security_group_egress_rule" "all" {
    security_group_id = aws_security_group.bastion.id
    description       = "Allow all outbound traffic"
    ip_protocol       = "-1"
    cidr_ipv4         = "0.0.0.0/0"

    tags = {
        Name = "${var.environment}-bastion-egress"
    }
}

# ------------------------------------------------------------------------------
# SSH key pair
# ------------------------------------------------------------------------------

resource "aws_key_pair" "bastion" {
    key_name   = "${var.environment}-bastion-key"
    public_key = file(var.public_key_path)

    tags = {
        Name        = "${var.environment}-bastion-key"
        Environment = var.environment
    }
}

# ------------------------------------------------------------------------------
# AMI lookup
# ------------------------------------------------------------------------------

data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = [var.ami_owner]

    filter {
        name   = "name"
        values = [var.ami_name_filter]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }
}

# ------------------------------------------------------------------------------
# EC2 instance
# ------------------------------------------------------------------------------

resource "aws_instance" "bastion" {
    ami                         = data.aws_ami.amazon_linux.id
    instance_type               = var.instance_type
    subnet_id                   = var.subnet_id
    vpc_security_group_ids      = [aws_security_group.bastion.id]
    key_name                    = aws_key_pair.bastion.key_name
    associate_public_ip_address = true

    root_block_device {
        volume_type           = "gp3"
        volume_size           = 8
        encrypted             = true
        delete_on_termination = true
    }

    metadata_options {
        http_tokens                 = "required"
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 1
    }

    tags = {
        Name        = "${var.environment}-bastion"
        Environment = var.environment
        Role        = "bastion"
    }
}
