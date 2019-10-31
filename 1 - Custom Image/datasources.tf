
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

data "oci_core_instances" "test_instances" {
    #Required
    compartment_id = "${data.oci_identity_compartments.test_compartments.compartments[0].id}"
    
    filter {
        name = "display_name"
        values = ["${var.instance_name}"]
        regex = true
    }
}
