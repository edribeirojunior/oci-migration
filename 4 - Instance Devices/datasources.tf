
data "oci_identity_compartments" "test_compartments" {
    provider = oci.us
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
    provider = oci.us
    #Required
    compartment_id = "${data.oci_identity_compartments.test_compartments.compartments[0].id}"
    
    filter {
        name = "display_name"
        values = ["${var.names}"]
        regex = true
    }
}

data "oci_core_instance_devices" "test_instance_devices" {
    provider = oci.us
    count = length(local.instances_id)
    #Required
    instance_id = "${local.instances_id[count.index]}"

}