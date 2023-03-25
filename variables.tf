variable "region_1_name" {
  description = "Region 1 name"

  default = "us-east-1"
}

variable "project" {
  description = "Project name"

  default = "mack-aws-with-workspaces"
}

variable "cidr_block" {
  description = "Base CIDR for VPC"

  default = "172.26.0.0/16"
}
