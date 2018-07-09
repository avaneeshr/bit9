#--------------------------------------------------------------
# This module creates an ALB
#--------------------------------------------------------------

variable "vpc" {}
variable "public_subnet_id_1" {}
variable "public_subnet_id_2" {}
variable "alb_sg" {}
variable "ec2_active" {}
variable "ec2_standby" {}


# Create ALB
resource "aws_alb" "front_alb" {
  name            = "app-load-balancer"
  internal        = false
  security_groups = ["${var.alb_sg}"]
  subnets         = "${list("${var.public_subnet_id_1}", "${var.public_subnet_id_2}")}"
}

resource "aws_alb_target_group" "alb_front_https" {
  name     = "alb-front-https"
  port     = "443"
  protocol = "HTTPS"
  vpc_id          = "${var.vpc}"
  health_check {
    path                = "/healthcheck" # path will need to be modified
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30             # adjust check interval
    timeout             = 5
    matcher             = "200"
  }
}

# Assign EC2 instances
resource "aws_alb_target_group_attachment" "alb_active-ec2_http" {
  target_group_arn = "${aws_alb_target_group.alb_front_https.arn}"
  target_id        = "${var.ec2_active}"
  port             = 80
}

resource "aws_alb_target_group_attachment" "alb_standby-ec2_http" {
  target_group_arn = "${aws_alb_target_group.alb_front_https.arn}"
  target_id        = "${var.ec2_standby}"
  port             = 80
}

# Expose the ALB
resource "aws_alb_listener" "alb_front_https" {
  load_balancer_arn = "${aws_alb.front_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_alb_target_group.alb_front_https.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_front_https.arn}"
    type             = "forward"
  }
}

output "alb_dns" {
  value = "${aws_alb.front_alb.dns_name}"
}
