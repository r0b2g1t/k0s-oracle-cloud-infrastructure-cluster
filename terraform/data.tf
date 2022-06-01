data "template_file" "k0s_config" {
  template = templatefile("services/traefik/config.tpl",
  {
    load_balancer_ip = module.load_balancer.load_balancer_ip
  })
}