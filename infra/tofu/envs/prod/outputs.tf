
output "master1_public_ip" {
  value = google_compute_instance.master1.network_interface[0].access_config[0].nat_ip
}
output "master2_public_ip" {
  value = google_compute_instance.master2.network_interface[0].access_config[0].nat_ip
}
output "worker1_public_ip" {
  value = google_compute_instance.worker1.network_interface[0].access_config[0].nat_ip
}
output "worker2_public_ip" {
  value = google_compute_instance.worker2.network_interface[0].access_config[0].nat_ip
}
output "worker3_public_ip" {
  value = google_compute_instance.worker3.network_interface[0].access_config[0].nat_ip
}
