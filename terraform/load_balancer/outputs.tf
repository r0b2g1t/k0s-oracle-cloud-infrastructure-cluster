output "load_balancer_ip" {
  value = oci_load_balancer_load_balancer.k0s_load_balancer.ip_address_details[0]["ip_address"]
}
