resource "null_resource" "deploy_baseos_to_master1" {
  depends_on = [
    google_compute_instance.master1,
    google_compute_instance.master2,
    google_compute_instance.worker1,
    google_compute_instance.worker2,
    google_compute_instance.worker3
  ]

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_abs_path)
    host        = google_compute_instance.master1.network_interface[0].access_config[0].nat_ip
    timeout     = "5m"
  }


  provisioner "file" {
    source      = "${path.module}/bootstrap_master1.sh"
    destination = "/home/${var.ssh_user}/bootstrap_master1.sh"
  }

  provisioner "file" {
    source      = var.ssh_private_key_abs_path
    destination = "/tmp/ssh_key"
  }

  # Clean pre-existing ansible dir to avoid stale files, then recreate
  provisioner "remote-exec" {
    inline = [
      "rm -rf ~/ansible",
      "mkdir -p ~/ansible"
    ]
  }

  # Copy .env from repo root to master1 home so deploy script and Ansible can source it
  provisioner "file" {
    source      = "${path.root}/../../../../.env"
    destination = "/home/${var.ssh_user}/.env"
  }

  provisioner "file" {
  source      = "${path.root}/../../../ansible"
    destination = "/home/${var.ssh_user}/ansible"
  }

  # Generate dynamic inventory on remote using known IPs
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/ansible/inventories/prod"
    ]
  }

  provisioner "file" {
    content = <<-EOT
      [masters]
      master1 ansible_host=${google_compute_instance.master1.network_interface[0].access_config[0].nat_ip}
      master2 ansible_host=${google_compute_instance.master2.network_interface[0].access_config[0].nat_ip}

      [workers]
      worker1 ansible_host=${google_compute_instance.worker1.network_interface[0].access_config[0].nat_ip}
      worker2 ansible_host=${google_compute_instance.worker2.network_interface[0].access_config[0].nat_ip}
      worker3 ansible_host=${google_compute_instance.worker3.network_interface[0].access_config[0].nat_ip}
    EOT
    destination = "/home/${var.ssh_user}/ansible/inventories/prod/hosts.ini"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/bootstrap_master1.sh",
      "chmod 600 /tmp/ssh_key",
  "bash -lc 'set -a; [ -f ~/.env ] && . ~/.env || true; set +a; ANSIBLE_REMOTE_USER=${var.ssh_user} SSH_USER=${var.ssh_user} ~/deploy_baseos_to_master1.sh ${google_compute_instance.master1.network_interface[0].access_config[0].nat_ip} /tmp/ssh_key'"
    ]
  }
}
