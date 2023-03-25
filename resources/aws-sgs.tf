resource "aws_security_group" "main" {
  for_each = toset(["web_instances", "database"])

  name        = "sgroup-${each.key}-${terraform.workspace}"
  description = "${var.project} SG ${each.key}"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project} SG ${each.key}"
  }
}
