resource "aws_key_pair" "deployer" {
  key_name   = "keypair-mackenzie-${terraform.workspace}"
  public_key = trimspace(tls_private_key.this.public_key_openssh)

  tags = local.tags
}