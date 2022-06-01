locals {
  k0s_tmpl = {
    apiVersion = "k0sctl.k0sproject.io/v1beta1"
    kind       = "cluster"
    spec = {
      hosts = [
        for host in concat(
          module.compute.controller,
          module.compute.worker) : {
          ssh = {
            address = host.private_ip
            user    = "ubuntu"
            keyPath = "~/.ssh/id_rsa"
            bastion = {
              address = module.compute.controller[0].public_ip
              user = "ubuntu"
              keyPath = "~/.ssh/id_rsa"
            }
          }
          hooks = {
            apply = {
              after = [
                "sudo chmod 644 /etc/environment"
              ]
            }
          }
          environment = { 
            ETCD_UNSUPPORTED_ARCH = host.freeform_tags["role"] == "controller" ? "arm64" : "amd64"
          }
          role = host.freeform_tags["role"]
        }
      ]
      k0s = {
        config = {
          spec = {
            api = {
              sans = [
                module.compute.controller[0].public_ip
              ]
            }
            extensions = {
              helm = {
                repositories = [
                  {
                  name = "traefik"
                  url = "https://helm.traefik.io/traefik"
                  }
                ]
                charts = [
                  {
                    name = "traefik"
                    chartname = "traefik/traefik"
                    version = "10.20.0"
                    namespace = "traefik-system"
                    values =  yamldecode(data.template_file.k0s_config.template)
                  }
                ]
              }
            }
          }
        }
      }
    }
  }
}

output "k0s_cluster" {
  value = yamlencode(local.k0s_tmpl)
}