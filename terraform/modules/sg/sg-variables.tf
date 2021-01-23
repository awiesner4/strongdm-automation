variable "sg_name" {}
variable "vpc_id" {}
variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "72.92.255.186/32"
      description = "al.wiesner home"
    },
    {
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "strongDM client access"
    }
  ]
}
variable "global_tags" {}