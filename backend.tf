terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "fmarcolino-terraform-state-files"
    key            = "mack-aws-with-workspaces/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_locks"
  }
}
