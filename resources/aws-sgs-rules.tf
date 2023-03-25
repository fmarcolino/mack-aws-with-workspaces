resource "aws_security_group_rule" "instances-ssh-all" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main["web_instances"].id
}
resource "aws_security_group_rule" "instances-80-all" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main["web_instances"].id
}
resource "aws_security_group_rule" "instances-443-all" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main["web_instances"].id
}

resource "aws_security_group_rule" "instances-icmp-all" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main["web_instances"].id
}

resource "aws_security_group_rule" "database_by_instances" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.main["database"].id

  source_security_group_id = aws_security_group.main["web_instances"].id
}
