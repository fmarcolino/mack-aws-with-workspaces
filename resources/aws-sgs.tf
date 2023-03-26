resource "aws_security_group" "main" {
  name        = "sgroup-web-main-${terraform.workspace}"
  description = "${var.project} SG web-main"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  dynamic ingress  {
    for_each = [22, 80, 443]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic ingress  {
    for_each = [-1]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = merge({
    Name = "sgroup-main-${terraform.workspace}"
  }, local.tags)
}

resource "aws_security_group" "database" {
  name        = "sgroup-database-${terraform.workspace}"
  description = "${var.project} SG database"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  dynamic ingress  {
    for_each = [3306]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      security_groups = [aws_security_group.main.id]
    }
  }

  tags = merge({
    Name = "sgroup-database-${terraform.workspace}"
  }, local.tags)
}
