resource "aws_iam_role" "role_ecs" {
  name = "${var.role_iam}_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "ec2.amazonaws.com", 
            "ecs-tasks.amazonaws.com"
            ]
        }
      },
    ]
  })

}

resource "aws_iam_role_policy" "ecs_ecr_role_policy" {
  name = "ecs_ecr_role_policy"
  role = aws_iam_role.role_ecs.id


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "perfil" {
  name = "${var.perfil_iam}_perfil"
}