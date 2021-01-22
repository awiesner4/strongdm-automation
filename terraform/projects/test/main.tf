provider "sdm" {}

resource "sdm_node" "gateway" {
  gateway {
    name = "strongDM-Gateway"
    listen_address = "0.0.0.0:5000"
    bind_address = "0.0.0.0:5000"
  }
}

output "gateways" {
  value = sdm_node.gateway
}