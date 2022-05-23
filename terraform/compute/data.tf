data "oci_identity_availability_domain" "ad_1" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_identity_availability_domain" "ad_2" {
  compartment_id = var.tenancy_ocid
  ad_number      = 2
}

data "oci_identity_availability_domain" "ad_3" {
  compartment_id = var.tenancy_ocid
  ad_number      = 3
}
