resource "aws_security_group" "security_group_eks_ssh_cluster" {
  name = "eks_ssh_cluster"
  vpc_id = module.vpc.vpc_id 
}

resource "aws_security_group_rule" "ingress_security_group_rule_eks_ssh_cluster" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 0.0.0.0 - 255.255.255.255
    security_group_id = aws_security_group.security_group_eks_ssh_cluster.id
}

resource "aws_security_group_rule" "egress_security_group_rule_eks_ssh_cluster" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1" # qualquer protocolo
    cidr_blocks = ["0.0.0.0/0"] # 0.0.0.0 - 255.255.255.255
    security_group_id = aws_security_group.security_group_eks_ssh_cluster.id
}

resource "aws_security_group" "security_group_private_subnet" {
  name = "security_group_private_subnet"
  vpc_id = module.vpc.vpc_id # aws_vpc.vpc_ecs.id
}

resource "aws_security_group_rule" "ingress_security_group_rule_private_subnet_eks" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    source_security_group_id = aws_security_group.security_group_eks_ssh_cluster.id
    security_group_id = aws_security_group.security_group_private_subnet.id
}

resource "aws_security_group_rule" "egress_security_group_rule_private_subnet_eks" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.security_group_private_subnet.id
}