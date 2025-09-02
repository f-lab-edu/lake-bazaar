provider "oci" {
  region              = var.region             # 기본값 ap-chuncheon-1
  config_file_profile = "DEFAULT"              # ~/.oci/config 의 섹션명
}

module "network" {
  source         = "../../modules/network"
  compartment_id = var.compartment_ocid
}

locals {
  ssh_key = chomp(file(var.ssh_public_key_abs_path))
}

module "compute" {
  source         = "../../modules/compute_instances"
  tenancy_ocid   = var.tenancy_ocid
  compartment_id = var.compartment_ocid
  subnet_id      = module.network.public_subnet_id
  shape          = var.shape
  # ocpus            = var.a1flex_ocpus
  # memory_in_gbs    = var.a1flex_memory_gb
  display_name        = "dev-vm-1"
  hostname_label      = "devvm1"
  ssh_authorized_keys = local.ssh_key
}

