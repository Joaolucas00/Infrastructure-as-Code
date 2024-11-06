module "aws_dev_ec2" {
    source = "../../infra"
    ec2_type = ""
    region_aws = ""
    ssh_key = ""
    security_group = ""
    autoscaling_group_name = ""
    autoscaling_group_min = 0
    autoscaling_group_max = 1
    is_production = false
}

#output "IP" {
#  value = module.aws_dev_ec2.IP_public
#}