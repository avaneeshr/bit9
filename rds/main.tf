# Any code, applications, scripts, templates, proofs of concept, documentation
# and other items provided by AWS under this SOW are “AWS Content,” as defined
# in the Agreement, and are provided for illustration purposes only. All such
# AWS Content is provided solely at the option of AWS, and is subject to the terms
# of the Addendum and the Agreement. Customer is solely responsible for using,
# deploying, testing, and supporting any code and applications provided by AWS
# under this SOW.

#--------------------------------------------------------------
# This module creates a MS-SQL RDS
#--------------------------------------------------------------

variable private_subnet_id_1 {}
variable private_subnet_id_2 {}
variable rds_sg {}
variable "username" {}
variable "password" {}

# Create RDS instance
resource "aws_db_instance" "master-rds" {

  depends_on                = ["aws_db_subnet_group.default_rds_mssql"]
  identifier                = "dev-mssql"
  allocated_storage         = "30"
  license_model             = "license-included"
  storage_type              = "gp2"
  engine                    = "sqlserver-se"
  engine_version            = "12.00.4422.0.v1"
  instance_class            = "db.m1.small" # change instance class
  multi_az                  = "true"
  username                  = "${var.username}"
  password                  = "${var.password}"
  vpc_security_group_ids    = ["${var.rds_sg}"]
  db_subnet_group_name      = "${aws_db_subnet_group.default_rds_mssql.id}"
  backup_retention_period   = 3
  skip_final_snapshot       = true
  final_snapshot_identifier = "dev-db"
  

  tags = {
      Owner = "owner name"
      Enviroment = "dev"
  }

}
# Subnet group 
resource "aws_db_subnet_group" "default_rds_mssql" {
  name        = "main_subnet_group"
  description = "Our main group of subnets"
  subnet_ids  = ["${var.private_subnet_id_1}", "${var.private_subnet_id_2}"]
}
