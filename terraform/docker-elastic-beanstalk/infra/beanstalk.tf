resource "aws_elastic_beanstalk_application" "beanstalk_application" {
  name = "beanstalk_application"
  description = var.description_beanstalk
}

resource "aws_elastic_beanstalk_environment" "beanstalk_environment" {
  name = var.beanstalk_environment_name
  application = aws_elastic_beanstalk_application.beanstalk_application.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.8 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.max
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_ec2_profile.name
  }

}

resource "aws_elastic_beanstalk_application_version" "default" {
  depends_on = [ aws_elastic_beanstalk_environment.beanstalk_environment, aws_elastic_beanstalk_application.beanstalk_application, aws_s3_object.docker.id ]
  name = var.beanstalk_environment_name
  application = var.beanstalk_environment_name
  description = var.description_beanstalk
  bucket = aws_s3_bucket.beanstalk_s3_deploy.id
  key = aws_s3_object.docker.id
}