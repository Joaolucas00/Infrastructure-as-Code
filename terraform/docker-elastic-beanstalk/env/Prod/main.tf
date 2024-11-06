module "Production" {
    source = "../../infra"
    ecr_name = ""
    description_beanstalk = ""
    max = 1
    instance_type = ""
    s3_bucket_name = ""
    beanstalk_environment_name = ""
}