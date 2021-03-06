# Any code, applications, scripts, templates, proofs of concept, documentation
# and other items provided by AWS under this SOW are “AWS Content,” as defined
# in the Agreement, and are provided for illustration purposes only. All such
# AWS Content is provided solely at the option of AWS, and is subject to the terms
# of the Addendum and the Agreement. Customer is solely responsible for using,
# deploying, testing, and supporting any code and applications provided by AWS
# under this SOW.

#--------------------------------------------------------------
# This module creates all the resources
#--------------------------------------------------------------

module "sg" {
  source = "../sg"

  vpc = "${var.vpc}"
}

module "ec2" {
  source = "../ec2"

  private_subnet_id_1 = "${var.private_subnet_id_1}"
  private_subnet_id_2 = "${var.private_subnet_id_2}"
  ec2_sg = "${module.sg.security_group_ec2}"
}

module "alb" {
  source = "../alb"

  vpc = "${var.vpc}"
  public_subnet_id_1 = "${var.public_subnet_id_1}"
  public_subnet_id_2 = "${var.public_subnet_id_2}"
  alb_sg = "${module.sg.security_group_alb}"
  ec2_active = "${module.ec2.active_ec2_id}"
  ec2_standby = "${module.ec2.standby_ec2_id}"
}

module "rds" {
  source = "../rds"

  private_subnet_id_1 = "${var.public_subnet_id_1}"
  private_subnet_id_2 = "${var.public_subnet_id_2}"
  rds_sg = "${module.sg.security_group_rds}"
  username = "${var.db_username}"
  password = "${var.db_password}"
}


output "sg_alb" {
  value = "${module.sg.security_group_alb}"
}

output "sg_ec2" {
  value = "${module.sg.security_group_ec2}"
}

output "sg_rds" {
  value = "${module.sg.security_group_rds}"
}
