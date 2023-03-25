resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge({
    Name = "network-vpc-${terraform.workspace}"
  }, local.tags)
}
