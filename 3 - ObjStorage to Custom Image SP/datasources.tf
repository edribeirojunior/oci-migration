
data "oci_identity_compartments" "test_compartments" {
    #Required
    compartment_id = "${var.tenancy_ocid}"
    access_level              = "ANY"
    compartment_id_in_subtree = true

    filter {
        name = "state"
        values = ["ACTIVE"]
    }

    filter {
        name = "name"
        values = ["${var.compartment_name}"]
    }
}
