output "instances" {
  value       = oci_core_image.test_image.*.id
}