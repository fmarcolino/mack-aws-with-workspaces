resource "aws_db_subnet_group" "main" {
  name       = "dbsubnetgroup-mysql-${terraform.workspace}"
  subnet_ids = values(aws_subnet.private).*.id

  tags = merge({
    Name = "dbsubnetgroup-mysql-${terraform.workspace}"
  }, local.tags)
}

resource "aws_db_instance" "main" {
  allocated_storage        = local.rds.disk_size
  backup_retention_period  = terraform.workspace == "prd" ? 30 : 7
  db_subnet_group_name     = aws_db_subnet_group.main.name
  engine                   = "mysql"
  engine_version           = "8.0.32"
  identifier               = "rds-mysql-${terraform.workspace}"
  instance_class           = "db.t3.micro"
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

  skip_final_snapshot        = true
  max_allocated_storage = terraform.workspace == "prd" ? local.rds.disk_size * 100 : 0

  tags = merge({
    Name = "rds-mysql-${terraform.workspace}"
  }, local.tags)
}

resource "aws_db_instance" "replica" {
  count = terraform.workspace == "prd" ? 1 : 0

  allocated_storage        = local.rds.disk_size
  backup_retention_period  = terraform.workspace == "prd" ? 30 : 7
  db_subnet_group_name     = aws_db_subnet_group.main.name
  identifier               = "rds-mysqlreplica-${terraform.workspace}"
  instance_class           = "db.t3.micro"
  publicly_accessible      = false
  storage_encrypted        = true
  storage_type             = "gp2"
  backup_window            = "22:00-23:00"
  maintenance_window       = "Sat:00:00-Sat:03:00"
  vpc_security_group_ids   = [aws_security_group.main["database"].id]

  replicate_source_db        = aws_db_instance.main.id
  auto_minor_version_upgrade = false

  skip_final_snapshot = true
  max_allocated_storage = local.rds.disk_size * 100

  tags = merge({
    Name = "rds-mysqlreplica-${terraform.workspace}"
  }, local.tags)
}
