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



# M1: NameNode, ResourceManager, ZK, JournalNode, ZKFC (A1 Flex)
module "compute_m1" {
  source         = "../../modules/compute_instances"
  tenancy_ocid   = var.tenancy_ocid
  compartment_id = var.compartment_ocid
  subnet_id      = module.network.public_subnet_id
  shape          = "VM.Standard.A1.Flex"
  ocpus          = 1
  memory_in_gbs  = 1
  display_name        = "M1"
  hostname_label      = "m1"
  ssh_authorized_keys = local.ssh_key
}

# M2: NameNode, ResourceManager, ZK, JournalNode, ZKFC (A1 Flex)
module "compute_m2" {
  source         = "../../modules/compute_instances"
  tenancy_ocid   = var.tenancy_ocid
  compartment_id = var.compartment_ocid
  subnet_id      = module.network.public_subnet_id
  shape          = "VM.Standard.A1.Flex"
  ocpus          = 1
  memory_in_gbs  = 1
  display_name        = "M2"
  hostname_label      = "m2"
  ssh_authorized_keys = local.ssh_key
}

# C1: ZK, JournalNode, JobHistory, Airflow, Spark History, HAProxy, DataNode, NodeManager (A1 Flex)
# module "compute_c1" {
#   source         = "../../modules/compute_instances"
#   tenancy_ocid   = var.tenancy_ocid
#   compartment_id = var.compartment_ocid
#   subnet_id      = module.network.public_subnet_id
#   shape          = "VM.Standard.A1.Flex"
#   ocpus          = 1
#   memory_in_gbs  = 1
#   display_name        = "C1"
#   hostname_label      = "c1"
#   ssh_authorized_keys = local.ssh_key
# }

# D1: HiveServer2, Spark Worker, DataNode, NodeManager (E2 Micro)
module "compute_d1" {
  source         = "../../modules/compute_instances"
  tenancy_ocid   = var.tenancy_ocid
  compartment_id = var.compartment_ocid
  subnet_id      = module.network.public_subnet_id
  shape          = "VM.Standard.E2.1.Micro"
  memory_in_gbs  = 1
  display_name        = "D1"
  hostname_label      = "d1"
  ssh_authorized_keys = local.ssh_key
}

# D2: Hive Metastore, Spark Worker, DataNode, NodeManager (E2 Micro)
module "compute_d2" {
  source         = "../../modules/compute_instances"
  tenancy_ocid   = var.tenancy_ocid
  compartment_id = var.compartment_ocid
  subnet_id      = module.network.public_subnet_id
  shape          = "VM.Standard.E2.1.Micro"
  memory_in_gbs  = 1
  display_name        = "D2"
  hostname_label      = "d2"
  ssh_authorized_keys = local.ssh_key
}

