module "system_on_region_1" {
  source = "./resources"

  project = var.project

  providers = {
    aws = aws.region_1
  }

  cidr_block = var.cidr_block
}
