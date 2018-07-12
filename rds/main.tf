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
  identifier = "dev-mssql-rds"
  allocated_storage = 30 # increase/decrease as required

  engine = "sqlserver-ex"
  engine_version = "14.00.1000.169.v1"
  instance_class = "db.r4.2xlarge" # change class as required
  name = "dev-db" # change name or use variable

  username = "${var.username}"
  password = "${var.password}"
  port = "1433"
  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["${var.rds_sg}"]
  db_subnet_group_name = "${aws_db_subnet_group.default.id}"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window = "03:50-04:20"
  backup_retention_period = "3"
  # Snapshot name upton DB deletion
  final_snapshot_identifier = "dev-db"

  #create_db_parameter_group = false
  license_model = "license_included" # m

  tags = {
      Owner = "owner name"
      Enviroment = "dev"
  }

}
# Subnet group 
resource "aws_db_subnet_group" "default" {
  name        = "main_subnet_group"
  description = "Our main group of subnets"
  subnet_ids  = ["${var.private_subnet_id_1}", "${var.private_subnet_id_2}"]
}
