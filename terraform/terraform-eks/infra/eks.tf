module "eks" {
  source = "terraform-aws-modules/eks/aws"
  
  cluster_name = var.eks_cluster_name
  cluster_version = "1.31"
  cluster_endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id 
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    eks_node_group = {
      min_size     = 1
      max_size     = 4
      desired_size = 3
      vpc_security_group_ids = [ aws_security_group.security_group_eks_ssh_cluster.id ]
      instance_types = ["t2.micro"]
    }
  }
}