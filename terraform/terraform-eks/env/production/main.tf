module "production" {
    source = "../../infra"
    repository_name = ""
    eks_cluster_name = ""
    
}

output "IP_loadbalancer_dns" {
  value = module.production.IP_loadbalancer
}