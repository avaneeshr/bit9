# Any code, applications, scripts, templates, proofs of concept, documentation
# and other items provided by AWS under this SOW are “AWS Content,” as defined
# in the Agreement, and are provided for illustration purposes only. All such
# AWS Content is provided solely at the option of AWS, and is subject to the terms
# of the Addendum and the Agreement. Customer is solely responsible for using,
# deploying, testing, and supporting any code and applications provided by AWS
# under this SOW.

#--------------------------------------------------------------
# This module creates EC2 instances
#--------------------------------------------------------------

variable "private_subnet_id_1" {}
variable "private_subnet_id_2" {}
variable "ec2_sg" {}

# Create key pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "active" {
  key_name   = "bit9_active_ec2_keypair"
  public_key = "${tls_private_key.example.public_key_openssh}"
}
resource "aws_key_pair" "standby" {
  key_name   = "bit9_standby_ec2_keypair"
  public_key = "${tls_private_key.example.public_key_openssh}"
}

# Create Active EC2 instances
resource "aws_instance" "ec2-active" {
    ami = "ami-0327667c" # MS Windows Server 2016 Base
    instance_type = "t1.micro"
    #availability_zone = "${}"
    subnet_id = "${var.private_subnet_id_1}"
    vpc_security_group_ids = ["${var.ec2_sg}"]
    key_name = "${aws_key_pair.active.key_name}"

    tags {
        Name = "Active EC2"
        Owner = "Dev"
    }
}

# Create Standby EC2 instances
resource "aws_instance" "ec2-standby" {
    ami = "ami-0327667c" # MS Windows Server 2016 Base
    instance_type = "m4.xlarge"
    #availability_zone = ""
    subnet_id = "${var.private_subnet_id_2}"
    vpc_security_group_ids = ["${var.ec2_sg}"]
    key_name = "${aws_key_pair.standby.key_name}"

    tags {
        Name = "Standby EC2"
        Owner = "Dev"
    }
}

# Outputs
output "active_ec2_id" {
  value = "${aws_instance.ec2-active.id}"
}
output "standby_ec2_id" {
  value = "${aws_instance.ec2-standby.id}"
}
output "active_ec2_ip" {
  value = "${aws_instance.ec2-active.public_ip}"
}
output "standby_ec2_ip" {
  value = "${aws_instance.ec2-standby.public_ip}"
}
