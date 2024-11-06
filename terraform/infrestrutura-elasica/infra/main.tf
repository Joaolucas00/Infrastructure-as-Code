terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
      }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
    region = var.region_aws
}

resource "aws_launch_template" "maquina" {
  image_id = "ami-0ea3c35c5c3284d82" 
  instance_type = var.ec2_type
  key_name = aws_key_pair.chaveSSH.key_name
  security_group_names = [ var.security_group ]
  user_data = var.is_production ? filebase64("ansible.sh") : ""
  tags = {
    Name = "Terraform Ansible"
  }
}

resource "aws_autoscaling_group" "grupo_de_escala" {
  availability_zones = [ "${var.region_aws}a", "${var.region_aws}b" ]
  name = var.autoscaling_group_name
  max_size = var.autoscaling_group_max
  min_size = var.autoscaling_group_min
  target_group_arns = var.is_production ? [ aws_lb_target_group.load_balancer_target_group[0].arn ] : []
  launch_template {
    id = aws_launch_template.maquina.id
    version = "$Latest"
  }
}

resource "aws_lb_target_group" "load_balancer_target_group" {
  name = "defaultTargetGroup"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default_vpc.id
  count = var.is_production ? 1 : 0
}

resource "aws_default_vpc" "default_vpc" {}

resource "aws_lb" "load_balancer" {
  internal = false
  subnets = [ aws_default_subnet.subnet_a.id, aws_default_subnet.subnet_b.id ]
  count = var.is_production ? 1 : 0
}

resource "aws_lb_listener" "entry_lb" {
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.load_balancer_target_group[0].arn
  }
  load_balancer_arn = aws_lb.load_balancer[0].arn
  port = "8000"
  protocol = "HTTP"
  count = var.is_production ? 1 : 0
}

resource "aws_default_subnet" "subnet_a" {
  availability_zone = "${var.region_aws}a"
}

resource "aws_default_subnet" "subnet_b" {
  availability_zone = "${var.region_aws}b"
}

resource "aws_autoscaling_policy" "as_policy" {
  name = "terraform-scaling"
  autoscaling_group_name = aws_autoscaling_group.grupo_de_escala.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  count = var.is_production ? 1 : 0
}

resource "aws_key_pair" "chaveSSH" {
  key_name = var.ssh_key
  public_key = file("${var.ssh_key}.pub")
}



