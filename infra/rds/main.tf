//variable "name_prefix" {}
//variable "common_tags" {}
//variable "subnet_ids" {}
//variable "quizzer_sg_id" {}
//variable "vpc_id" {}
//
//resource "aws_db_instance" "postgres-db" {
//  identifier                = "${var.name_prefix}-postgres"
//  allocated_storage         = 5
//  backup_retention_period   = 2
//  backup_window             = "01:00-01:30"
//  maintenance_window        = "sun:03:00-sun:03:30"
//  multi_az                  = true
//  engine                    = "postgres"
//  engine_version            = "12.5"
//  instance_class            = "db.t2.micro"
//  name                      = "db_quizzer"
//  username                  = "postgres"
//  password                  = "12345678"
//  port                      = "5432"
//  db_subnet_group_name      = aws_db_subnet_group.postgres-db-subnet-group.id
//  vpc_security_group_ids    = [aws_security_group.rds-sg.id, var.quizzer_sg_id]
//  skip_final_snapshot       = true
//  final_snapshot_identifier = "postgres-final"
//  publicly_accessible       = true
//  tags = merge(var.common_tags, {
//    Name = "${var.name_prefix}-postgres-db"
//  })
//}
//
//resource "aws_db_subnet_group" "postgres-db-subnet-group" {
//  name = "${var.name_prefix}-postgres-db-subnet-group"
//  subnet_ids = var.subnet_ids
//  tags = var.common_tags
//}
//
//resource "aws_security_group" "rds-sg" {
//  name   = "${var.name_prefix}-rds-sg"
//  vpc_id = var.vpc_id
//
//  ingress {
//    protocol        = "tcp"
//    from_port       = 5432
//    to_port         = 5432
//    cidr_blocks     = ["0.0.0.0/0"]
//    security_groups = [var.quizzer_sg_id]
//  }
//
//  egress {
//    from_port   = 0
//    to_port     = 65535
//    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//  tags = var.common_tags
//}
//
//
//output "postgres_endpoint" {
//  value = aws_db_instance.postgres-db.endpoint
//}
