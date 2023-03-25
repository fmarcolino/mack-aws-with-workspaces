resource "aws_db_subnet_group" "main" {
  name       = "mydb"
  subnet_ids = values(aws_subnet.private).*.id

  tags = {
    Name = "rds-subnetgroup-${terraform.workspace}"
  }
}

resource "aws_db_instance" "main" {
  allocated_storage        = local.rds.disk_size
  backup_retention_period  = terraform.workspace == "prd" ? 30 : 7
  db_subnet_group_name     = aws_db_subnet_group.main.name
  engine                   = "mysql"
  engine_version           = "8"
  identifier               = "rds-mysql-${terraform.workspace}"
  instance_class           = "db.t2.micro"
  multi_az                 = local.rds.multi_az
  db_name                  = "mydb"
  password                 = "admin123"
  publicly_accessible      = false
  storage_encrypted        = true
  storage_type             = "gp2"
  username                 = "mydb"
  backup_window            = "22:00-23:00"
  maintenance_window       = "Sat:00:00-Sat:03:00"
  vpc_security_group_ids   = [aws_security_group.main["database"].id]

  auto_minor_version_upgrade = false
}

resource "aws_db_instance" "replica" {
  count = terraform.workspace == "prd" ? 1 : 0

  allocated_storage        = local.rds.disk_size
  backup_retention_period  = terraform.workspace == "prd" ? 30 : 7
  db_subnet_group_name     = aws_db_subnet_group.main.name
  engine                   = "mysql"
  engine_version           = "8"
  identifier               = "rds-mysqlreplica-${terraform.workspace}"
  instance_class           = "db.t2.micro"
  multi_az                 = local.rds.multi_az
  db_name                  = "mydb"
  password                 = "admin123"
  publicly_accessible      = false
  storage_encrypted        = true
  storage_type             = "gp2"
  username                 = "mydb"
  backup_window            = "22:00-23:00"
  maintenance_window       = "Sat:00:00-Sat:03:00"
  vpc_security_group_ids   = [aws_security_group.main["database"].id]

  replicate_source_db        = aws_db_instance.main.id
  auto_minor_version_upgrade = false
}
