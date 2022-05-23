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
              before = [
                "sudo chmod 666 /etc/environment"
              ]
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
    }
  }
}

output "k0s_cluster" {
  value = yamlencode(local.k0s_tmpl)
}