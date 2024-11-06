resource "aws_lb" "loadbalancer_ecs" {
  name = "loadbalancer-ecs"
  security_groups = [ aws_security_group.security_group_application_loadbalancer.id ]
  subnets = module.vpc.public_subnets # [aws_subnet.rede_publica_a.id, aws_subnet.rede_publica_b.id] 
}

resource "aws_lb_listener" "loadbalancer_ecs_listener_http" {
    load_balancer_arn = aws_lb.loadbalancer_ecs.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.loadbalancer_ecs_target_group.arn
    }
}

resource "aws_lb_target_group" "loadbalancer_ecs_target_group" {
  name = "ecs-target-group"
  port = 80
  target_type = "ip"
  protocol = "HTTP"
  vpc_id = module.vpc.vpc_id # aws_vpc.vpc_ecs.id
}

output "IP_lb_dns_name" {
  value = aws_lb.loadbalancer_ecs.dns_name
}