# Create the subnet group for the RDS instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "${var.project_name}-${var.environment}-database-subnets"
  subnet_ids  = [var.private_data_subnet_az1_id, var.private_data_subnet_az2_id]
  description = "subnets for database instance"

  tags = {
    Name = "${var.project_name}-${var.environment}-database-subnets"
  }
}

#  create the rds database instance or restored from db snapshots
resource "aws_db_instance" "database_instance" {
  engine                 = var.database_instance_engine
  engine_version         = var.database_instance_engine_version
  multi_az               = var.database_instance_multi_az
  identifier             = var.database_instance_identifier
  username               = var.database_instance_username
  password               = var.database_instance_password
  instance_class         = var.database_instance_instance_class
  allocated_storage      = var.database_instance_allocated_storage
  storage_encrypted       = var.database_instance_storage_encrypted
  publicly_accessible    = var.database_instance_publicly_accessible
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [var.database_security_group_id]
  availability_zone      = var.database_instance_az
  db_name                = var.database_instance_db_name
  skip_final_snapshot    = var.database_instance_skip_final_snapshot
  
  tags = {
    Name = "${var.project_name}-${var.environment}-rds-instance"
  }
}
