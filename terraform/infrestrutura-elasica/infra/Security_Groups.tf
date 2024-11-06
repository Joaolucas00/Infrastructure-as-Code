resource "aws_security_group" "ssh_access" {
    name = var.security_group

    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }
    egress {
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }

    tags = {
      "Name" = "ssh_access"
    }
}