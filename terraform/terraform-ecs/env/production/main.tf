module "production" {
    source = "../../infra"
    repository_name = ""
    perfil_iam = ""
    role_iam = ""
    cluster_name_ecs = ""
}

output "IP_loadbalancer_dns_name" {
  value = module.production.IP_lb_dns_name
}