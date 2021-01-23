provider "sdm" {
}
terraform {
  required_providers {
    sdm = {
      source  = "strongdm/sdm"
      version = "~> 1.0"
    }
  }
}
//resource "sdm_resource" "eks-cluster" {
//  name = "${var.custOrAcct}-${var.dataOrControl}-${var.cluster_name}-${var.region}"
//  endpoint = var.cluster_endpoint
//  access_key = var.access_key
//  secret_access_key = var.secret_key
//  certificate_authority = var.certificate_authority
//  region = var.region
//  cluster_name = var.cluster_name
//  role_arn = var.role_arn
//}

resource "sdm_resource" "eks-cluster" {
  count = length(var.eks-clusters)

  amazon_eks {
    name                  = var.eks-clusters[count.index].strongdm_name
    endpoint              = var.eks-clusters[count.index].cluster_endpoint
    access_key            = var.eks-clusters[count.index].access_key
    secret_access_key     = var.eks-clusters[count.index].secret_key
    region                = var.eks-clusters[count.index].region
    cluster_name          = var.eks-clusters[count.index].cluster_name
    role_arn              = var.eks-clusters[count.index].role_arn
    certificate_authority = file("${path.module}/cert_auth.pem")

    # var.eks-clusters[count.index].certificate_authority
  }
}

#
