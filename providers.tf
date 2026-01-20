/*
 *
 * @desc: aws provider config
 *
 */

provider "aws" {
    region = var.aws_region

    default_tags {
        tags = {
            Project     = "saba"
            ManagedBy   = "terraform"
            Environment = var.environment
        }
    }
}
