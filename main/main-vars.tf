# Any code, applications, scripts, templates, proofs of concept, documentation
# and other items provided by AWS under this SOW are “AWS Content,” as defined
# in the Agreement, and are provided for illustration purposes only. All such
# AWS Content is provided solely at the option of AWS, and is subject to the terms
# of the Addendum and the Agreement. Customer is solely responsible for using,
# deploying, testing, and supporting any code and applications provided by AWS
# under this SOW.

#--------------------------------------------
# Fixed Variables
#--------------------------------------------
# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-1"
}


variable "vpc" {
  type        = "string"
  description = "VPC ID"
}

variable "public_subnet_id_1" {
  type        = "string"
  description = "Public Subnet Id 1"
}

variable "public_subnet_id_2" {
  type        = "string"
  description = "Public Subnet Id 2"
}

variable "private_subnet_id_1" {
  type        = "string"
  description = "Private Subnet Id 1"
}

variable "private_subnet_id_2" {
  type        = "string"
  description = "Private Subnet Id 2"
}
variable "db_username" {
  type        = "string"
  description = "RDS DB username"
}

variable "db_password" {
  type        = "string"
  description = "RDS DB password"
}

variable "aws_access_key" {
  default     = ""
  description = "the users aws access key"
}

variable "aws_secret_key" {
  default     = ""
  description = "the users aws secret key"
}
