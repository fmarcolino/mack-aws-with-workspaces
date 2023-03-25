resource "aws_instance" "web_instances" {
  count = local.web_instances.count

  ami           = local.web_instances.ami_id
  instance_type = local.web_instances.instance_type
  key_name      = aws_key_pair.deployer.key_name

  subnet_id              = values(local.web_instances.public_subnet ? aws_subnet.public : aws_subnet.private)[count.index % local.count_subnets].id
  vpc_security_group_ids = local.web_instances.sg_ids
  user_data = local.web_instances.user_data

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = local.web_instances.disk_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "ec2-web_${count.index + 1}-${terraform.workspace}"
  }
}

resource "aws_instance" "backend_instances" {
  count = local.backend_instances.count

  ami           = local.backend_instances.ami_id
  instance_type = local.backend_instances.instance_type
  key_name      = aws_key_pair.deployer.key_name

  subnet_id              = values(local.backend_instances.public_subnet ? aws_subnet.public : aws_subnet.private)[count.index % local.count_subnets].id
  vpc_security_group_ids = local.backend_instances.sg_ids
  user_data = local.backend_instances.user_data

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = local.backend_instances.disk_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "ec2-backend_${count.index + 1}-${terraform.workspace}"
  }
}
