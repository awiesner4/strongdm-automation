variable "eks-clusters" {}

variable "cluster_endpoint" {
  default = ""
}
variable "cluster_name" {
  default = ""
}

variable "custOrAcct" {
  default = "starburstdata-devops"
}

variable "dataOrControl" {
  default = "control"
}

variable "region" {
  default = "us-east-2"
}

variable "access_key" {
  default = ""
}
variable "secret_key" {
  default = ""
}

variable "certificate_authority" {
  default = ""
}

variable "role_arn" {
  default = ""
}
