
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  credentials = file(var.gcp_credentials_file)
}

resource "google_compute_instance" "master1" {
  name         = "master1"
  machine_type = "e2-standard-2"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-balanced"
    }
  }
  scheduling {
    preemptible       = true
    automatic_restart = false
  on_host_maintenance = "TERMINATE"
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
  ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_abs_path)}"
    startup-script = <<-EOT
      #!/bin/bash
      apt-get update
      apt-get install -y ansible
    EOT
  }
}

resource "google_compute_instance" "master2" {
  name         = "master2"
  machine_type = "e2-standard-2"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-balanced"
    }
  }
  scheduling {
    preemptible       = true
    automatic_restart = false
  on_host_maintenance = "TERMINATE"
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
  ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_abs_path)}"
  }
}

resource "google_compute_instance" "worker1" {
  name         = "worker1"
  machine_type = "e2-standard-2"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-balanced"
    }
  }
  scheduling {
    preemptible       = true
    automatic_restart = false
  on_host_maintenance = "TERMINATE"
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
  ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_abs_path)}"
  }
}

resource "google_compute_instance" "worker2" {
  name         = "worker2"
  machine_type = "e2-small"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-balanced"
    }
  }
  scheduling {
    preemptible       = true
    automatic_restart = false
  on_host_maintenance = "TERMINATE"
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
  ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_abs_path)}"
  }
}

resource "google_compute_instance" "worker3" {
  name         = "worker3"
  machine_type = "e2-small"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-balanced"
    }
  }
  scheduling {
    preemptible       = true
    automatic_restart = false
  on_host_maintenance = "TERMINATE"
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "chanyong:${file(var.ssh_public_key_abs_path)}"
  }
}

# 내부 통신 방화벽: VPC 내부에서 SSH/ICMP 허용
resource "google_compute_firewall" "lb_allow_internal_ssh" {
  name    = "lb-allow-internal-ssh"
  network = "default"
  direction     = "INGRESS"
  source_ranges = ["10.128.0.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "lb_allow_internal_icmp" {
  name    = "lb-allow-internal-icmp"
  network = "default"
  direction     = "INGRESS"
  source_ranges = ["10.128.0.0/20"]
  allow {
    protocol = "icmp"
  }
}

