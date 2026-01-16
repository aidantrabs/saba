resource "aws_security_group" "bastion_sg" {
    name        = "${var.environment}-bastion-sg"
    description = "Security group for bastion host"
    vpc_id      = aws_vpc.main.id

    tags = {
        Name        = "${var.environment}-bastion-sg"
        Environment = var.environment
    }

    # allow inbound SSH(port 22) from anywhere (0.0.0.0/0) - in prod you'd restrict this to your IP
    ingress {
        description      = "SSH from anywhere"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]      
        ipv6_cidr_blocks = ["::/0"]
    }      
    
    # allow all outbound traffic (this is default behavior, but be explicit)
    egress {
        description      = "Allow all outbound traffic"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_key_pair" "bastion_pk" {
    key_name   = "bastion-key"
    public_key = file("~/.ssh/bastion-key.pub")
}

data "aws_ami" "this" {
    most_recent = true
    owners = [var.ami_owner]

    filter {
        name = "name"
        values = [var.ami_name_filter]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "ec2" {
    ami = data.aws_ami.this.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.public_a.id
    vpc_security_group_ids = [ aws_security_group.bastion_sg.id ]
    key_name = aws_key_pair.bastion_pk.key_name
    associate_public_ip_address = true
    
    tags = {
        Name = "${var.environment}-bastion"
    } 
}
