resource "aws_key_pair" "deployer" {
  key_name   = "mackenzie"
  public_key = trimspace(tls_private_key.this.public_key_openssh)
}