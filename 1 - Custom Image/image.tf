
locals {
  instance_id = data.oci_core_instances.test_instances.instances.*.id
  instance_name = data.oci_core_instances.test_instances.instances.*.display_name
}

resource "oci_core_image" "image" {
    count = length(local.instance_id)
    #Required
    compartment_id = "${data.oci_identity_compartments.test_compartments.compartments[0].id}"
    instance_id = element(local.instance_id, count.index)
    display_name = element(local.instance_name, count.index)

}
