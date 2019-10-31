
locals {
    instances_id = data.oci_core_instances.test_instances.instances.*.id
    instances_name = data.oci_core_instances.test_instances.instances.*.display_name
}


