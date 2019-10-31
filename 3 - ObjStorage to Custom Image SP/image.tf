
locals {
  instance_id = ["${var.instance_name}"]
  instance_name = ["${var.instance_name}"]
  time = timestamp()
}




resource "oci_objectstorage_preauthrequest" "test_preauthenticated_request" {
    provider = oci.us
    #Required
    access_type = "ObjectReadWrite"
    bucket = "bucket-name"
    name = "${var.instance_name}"
    namespace = "namespace-name"
    time_expires = "${timeadd(local.time, "4h")}"

    #Optional
    object = "${var.instance_name}"
}




resource "oci_core_image" "test_image" {
    count = length(local.instance_id)
    #Required
    compartment_id = "${data.oci_identity_compartments.test_compartments.compartments[0].id}"
    #Optional
    display_name = element(local.instance_name, count.index)
    image_source_details {
        source_type = "objectStorageUri"
        source_uri = "https://objectstorage.us-ashburn-1.oraclecloud.com${oci_objectstorage_preauthrequest.test_preauthenticated_request.access_uri}"
    }

    depends_on = [oci_objectstorage_preauthrequest.test_preauthenticated_request]
}
