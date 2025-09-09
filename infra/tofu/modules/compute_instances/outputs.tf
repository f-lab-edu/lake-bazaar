output "public_ip" { value = data.oci_core_vnic.primary.public_ip_address }
output "private_ip" { value = data.oci_core_vnic.primary.private_ip_address }
