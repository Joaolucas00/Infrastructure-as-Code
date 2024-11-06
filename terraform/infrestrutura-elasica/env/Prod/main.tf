module "aws_dev_ec2_prod" {
    source = "../../infra"
    ec2_type = ""
    region_aws = ""
    ssh_key = ""
    security_group = ""
    autoscaling_group_name = ""
    autoscaling_group_min = 1
    autoscaling_group_max = 10
    is_production = true
}

#output "IP" {
#  value = module.aws_dev_ec2_prod.IP_public
#}