resource "null_resource" "deploy_baseos_to_master1" {
  depends_on = [
    google_compute_instance.master1,
    google_compute_instance.master2,
    google_compute_instance.worker1,
    google_compute_instance.worker2,
    google_compute_instance.worker3
  ]

  provisioner "local-exec" {
    command = <<EOT
      bash ./deploy_baseos_to_master1.sh ${google_compute_instance.master1.network_interface[0].access_config[0].nat_ip} ${var.ssh_private_key_abs_path}
    EOT
  }
}
