# Saba

Production-ready, multi-AZ AWS VPC infrastructure with Terraform.

## Overview

Saba is a modular Terraform project that provisions a secure, highly-available VPC architecture on AWS. It implements AWS best practices for network isolation, redundancy, and secure access patterns commonly used in production environments.

### Key Features

- **Multi-AZ Deployment** - Resources spread across two availability zones for high availability
- **Network Isolation** - Public and private subnet tiers with proper routing
- **Redundant NAT Gateways** - One per AZ to eliminate single points of failure
- **Bastion Host** - Secure jump server for SSH access to private resources
- **Modular Design** - Reusable modules for networking and bastion components
- **LocalStack Support** - Test infrastructure locally without AWS costs

## Architecture

![Architecture Diagram](architecture.png)

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                         VPC                             │
                    │                    10.0.0.0/16                          │
                    │                                                         │
                    │   ┌─────────────────────┐   ┌─────────────────────┐     │
                    │   │   Public Subnet A   │   │   Public Subnet B   │     │
                    │   │    10.0.1.0/24      │   │    10.0.2.0/24      │     │
                    │   │      (AZ-A)         │   │      (AZ-B)         │     │
    Internet ───────┼───│                     │   │                     │     │
        │           │   │  ┌─────┐  ┌─────┐   │   │      ┌─────┐        │     │
        │           │   │  │ NAT │  │Bast-│   │   │      │ NAT │        │     │
        └───────────┼───│  │ GW  │  │ ion │   │   │      │ GW  │        │     │
                    │   │  └──┬──┘  └─────┘   │   │      └──┬──┘        │     │
                    │   └─────┼───────────────┘   └─────────┼───────────┘     │
                    │         │                             │                 │
                    │   ┌─────┴───────────────┐   ┌─────────┴───────────┐     │
                    │   │  Private Subnet A   │   │  Private Subnet B   │     │
                    │   │    10.0.10.0/24     │   │    10.0.20.0/24     │     │
                    │   │      (AZ-A)         │   │      (AZ-B)         │     │
                    │   │                     │   │                     │     │
                    │   │   ┌───────────┐     │   │    ┌───────────┐    │     │
                    │   │   │ App/DB    │     │   │    │ App/DB    │    │     │
                    │   │   │ Servers   │     │   │    │ Servers   │    │     │
                    │   │   └───────────┘     │   │    └───────────┘    │     │
                    │   └─────────────────────┘   └─────────────────────┘     │
                    └─────────────────────────────────────────────────────────┘
```

## Project Structure

```
saba/
├── main.tf                 # Root module - orchestrates child modules
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── versions.tf             # Terraform/provider versions
├── providers.tf            # AWS provider configuration
├── architecture.png        # Infrastructure diagram (generated via inframap)
│
└── modules/
    ├── networking/         # VPC, subnets, NAT gateways, routing
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── bastion/            # Security group, SSH key, EC2 instance
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Usage

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- SSH key pair for bastion access

### Quick Start

```bash
# Clone the repository
git clone https://github.com/aidantrabs/saba.git
cd saba

# Generate SSH key for bastion access
ssh-keygen -t ed25519 -f ~/.ssh/bastion-key -C "bastion"

# Deploy
terraform init
terraform plan
terraform apply
```

### Connect to Bastion

```bash
ssh -i ~/.ssh/bastion-key ec2-user@$(terraform output -raw bastion_public_ip)
```

### Access Private Resources

Use the bastion as a jump host:

```bash
ssh -i ~/.ssh/bastion-key -J ec2-user@<bastion-ip> ec2-user@<private-ip>
```

## Local Development

Test the infrastructure locally using [LocalStack](https://localstack.cloud/) without incurring AWS costs.

### Setup

1. Start LocalStack:
   ```bash
   docker run -d -p 4566:4566 localstack/localstack
   ```

2. Create a local provider override (`providers_override.tf`):
   ```hcl
   provider "aws" {
       region                      = "us-east-1"
       access_key                  = "test"
       secret_key                  = "test"
       skip_credentials_validation = true
       skip_metadata_api_check     = true
       skip_requesting_account_id  = true

       endpoints {
           ec2 = "http://localhost:4566"
           iam = "http://localhost:4566"
           sts = "http://localhost:4566"
       }
   }
   ```

3. Deploy locally:
   ```bash
   terraform init
   terraform apply
   ```

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `environment` | Environment name | `dev` |
| `aws_region` | AWS region | `us-east-1` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `instance_type` | Bastion instance type | `t3.micro` |
| `allowed_ssh_cidr` | CIDR allowed to SSH | `0.0.0.0/0` |

## Outputs

| Output | Description |
|--------|-------------|
| `vpc_id` | VPC identifier |
| `public_subnet_ids` | Public subnet IDs |
| `private_subnet_ids` | Private subnet IDs |
| `bastion_public_ip` | Bastion host IP |
| `nat_gateway_ids` | NAT Gateway IDs |

## Generating Architecture Diagrams

The architecture diagram is generated using [inframap](https://github.com/cycloidio/inframap):

```bash
inframap generate . --raw | dot -Tpng > architecture.png
```

## Security Considerations

- **SSH Access**: Default allows SSH from anywhere (`0.0.0.0/0`). Restrict `allowed_ssh_cidr` to specific IPs in production.
- **IMDSv2**: Bastion requires IMDSv2 for enhanced metadata security.
- **Encryption**: Root volumes are encrypted by default.
- **Private Isolation**: Resources in private subnets have no direct inbound internet access.

## License

MIT
