# Any code, applications, scripts, templates, proofs of concept, documentation
# and other items provided by AWS under this SOW are “AWS Content,” as defined
# in the Agreement, and are provided for illustration purposes only. All such
# AWS Content is provided solely at the option of AWS, and is subject to the terms
# of the Addendum and the Agreement. Customer is solely responsible for using,
# deploying, testing, and supporting any code and applications provided by AWS
# under this SOW.

#--------------------------------------------------------------
# This module creates the security groups for ALB, EC2 and RDS
#--------------------------------------------------------------

variable "vpc" {}

# SG for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb sg"
  description = "Allow HHTP and HTTPS"
  vpc_id      = "${var.vpc}"

  ingress {
    description = "HTTP"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = ""
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg"
  }
}

# SG for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2 sg"
  description = "Allow RDP and ALB SG"
  vpc_id      = "${var.vpc}"

  ingress {
    description = "RDP"
    from_port   = "3389"
    to_port     = "3389"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "HTTPS"
    from_port       = "443"
    to_port         = "443"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb_sg.id}"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

# SG for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds sg"
  description = "Allow MYSQL (3306)"
  vpc_id      = "${var.vpc}"

  ingress {
    description     = "SQL Server RDS"
    from_port       = "1433"
    to_port         = "1433"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ec2_sg.id}"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Outputs
output "security_group_alb" {
  value = "${aws_security_group.alb_sg.id}"
}

output "security_group_ec2" {
  value = "${aws_security_group.ec2_sg.id}"
}

output "security_group_rds" {
  value = "${aws_security_group.rds_sg.id}"
}
