module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  cluster_name = var.cluster_name_ecs
#  fargate_capacity_providers = {
#    FARGATE = {
#      default_capacity_provider_strategy = {
#        weight = 50
#      }
#    }
#  }
}

resource "aws_ecs_task_definition" "reactapp-organo" {
  family                   = "reactapp"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256 # 1024 -> 1 cpu; 256 -> 0.25 cpu ou 1/4 cpu; 512 -> 0.5 cpu ou 1/2 cpu
  memory                   = 512
  execution_role_arn       = aws_iam_role.role_ecs.arn
  container_definitions = jsonencode(
    [
      {
        "name"      = "production"
        "image"     = " < ecr repo > "
        "cpu"       = 256
        "memory"    = 512
        "essential" = true
        "portMappings" = [
          {
            "containerPort" = 80
            "hostPort"      = 80
          }
        ]
      }
    ]
  )
}

resource "aws_ecs_service" "reactapp-organo-ecs-service" {
  name            = "reactapp-organo-ecs-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.reactapp-organo.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.loadbalancer_ecs_target_group.arn
    container_name   = "production"
    container_port   = 80
  }

  network_configuration {
      subnets = module.vpc.private_subnets # [ aws_subnet.rede_privada_a.id, aws_subnet.rede_privada_b.id ]  
      security_groups = [aws_security_group.security_group_private_subnet.id ]
  }

  capacity_provider_strategy {
      capacity_provider = "FARGATE"
      weight = 1 #100/100 -> porcertagem, capacidade dentro do fargate
  }
}