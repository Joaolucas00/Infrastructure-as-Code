terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
    # required_version = ">= 1.2.0"
}

provider "aws" {
  region = ""
}

data "aws_eks_cluster" "default" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  host = data.aws_eks_cluster.default
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.default.token
}