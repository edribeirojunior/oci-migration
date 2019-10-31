provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "ocid1.user.oc1.."
  fingerprint = ""
  private_key_path = ""
  region = "us-ashburn-1"
}
