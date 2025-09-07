
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
      size  = 30
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = file(var.ssh_public_key_abs_path)
  }
}

resource "google_compute_instance" "master2" {
  name         = "master2"
  machine_type = "e2-standard-2"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 30
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = file(var.ssh_public_key_abs_path)
  }
}

resource "google_compute_instance" "worker1" {
  name         = "worker1"
  machine_type = "e2-standard-2"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 30
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = file(var.ssh_public_key_abs_path)
  }
}

resource "google_compute_instance" "worker2" {
  name         = "worker2"
  machine_type = "e2-small"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 30
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = file(var.ssh_public_key_abs_path)
  }
}

resource "google_compute_instance" "worker3" {
  name         = "worker3"
  machine_type = "e2-small"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 30
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = file(var.ssh_public_key_abs_path)
  }
}

