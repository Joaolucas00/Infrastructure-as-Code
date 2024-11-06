resource "aws_security_group" "security_group_application_loadbalancer" {
  name = "application_loadbalancer"
  vpc_id = module.vpc.vpc_id # aws_vpc.vpc_ecs.id 
}

resource "aws_security_group_rule" "ingress_security_group_rule_application_loadbalancer" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 0.0.0.0 - 255.255.255.255
    security_group_id = aws_security_group.security_group_application_loadbalancer.id
}

resource "aws_security_group_rule" "egress_security_group_rule_application_loadbalancer" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1" # qualquer protocolo
    cidr_blocks = ["0.0.0.0/0"] # 0.0.0.0 - 255.255.255.255
    security_group_id = aws_security_group.security_group_application_loadbalancer.id
}

resource "aws_security_group" "security_group_private_subnet" {
  name = "security_group_private_subnet"
  vpc_id = module.vpc.vpc_id # aws_vpc.vpc_ecs.id
}

resource "aws_security_group_rule" "ingress_security_group_rule_private_subnet_ecs" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    source_security_group_id = aws_security_group.security_group_application_loadbalancer.id
    security_group_id = aws_security_group.security_group_private_subnet.id
}

resource "aws_security_group_rule" "egress_security_group_rule_private_subnet_ecs" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.security_group_private_subnet.id
}