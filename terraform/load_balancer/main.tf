resource "oci_load_balancer_load_balancer" "k0s_load_balancer" {
  compartment_id             = var.compartment_id
  display_name               = "k0s-load-balancer"
  shape                      = "flexible"
  subnet_ids                 = [var.cluster_subnet_id]

  ip_mode    = "IPV4"
  is_private = true

  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
}

# HTTP 
resource "oci_load_balancer_listener" "k0s_http_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.k0s_http_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.k0s_load_balancer.id
  name                     = "k0s-http-listener"
  port                     = 80
  protocol                 = "HTTP"
}

resource "oci_load_balancer_backend_set" "k0s_http_backend_set" {
  health_checker {
    protocol    = "HTTP"
    port        = 30080
    url_path    = "/ping"
    return_code = 200
  }
  load_balancer_id = oci_load_balancer_load_balancer.k0s_load_balancer.id
  name             = "k0s-http-backend-set"
  policy           = "ROUND_ROBIN"
}

resource "oci_load_balancer_backend" "k0s_http_backend" {
    depends_on = [
      oci_load_balancer_backend_set.k0s_http_backend_set
    ]
  count            = length(var.workers)
  backendset_name  = "k0s-http-backend-set"
  ip_address       = var.workers[count.index].private_ip
  load_balancer_id = oci_load_balancer_load_balancer.k0s_load_balancer.id
  port             = 30080
}