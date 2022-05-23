output "controller" {
  value = [
    for controller in oci_core_instance.controller : controller
  ]
  depends_on = [
    oci_core_instance.controller
  ]
}

output "worker" {
  value = [
    for worker in oci_core_instance.worker : worker
    ]
  depends_on = [
    oci_core_instance.worker
  ]
}