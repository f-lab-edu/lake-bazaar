
resource "google_compute_network" "vpc" {
  name                    = "lake-bazzar-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public" {
  name          = "lake-bazzar-public-subnet"
  ip_cidr_range = var.public_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

# SSH (22) 외부 허용
resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = var.ssh_source_cidrs
  target_tags   = ["lake-bazzar-node"]
}

# 클러스터 내부 서비스 포트 (내부 통신만 허용)
resource "google_compute_firewall" "internal_services" {
  name    = "allow-internal-services"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = [for p in var.service_ports : tostring(p)]
  }
  source_ranges = [var.internal_cidr]
  target_tags   = ["lake-bazzar-node"]
}

# 모든 인스턴스의 아웃바운드 허용
resource "google_compute_firewall" "egress_all" {
  name    = "allow-egress-all"
  network = google_compute_network.vpc.name
  direction = "EGRESS"
  allow {
    protocol = "all"
  }
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["lake-bazzar-node"]
}
