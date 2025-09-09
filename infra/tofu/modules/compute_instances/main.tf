# 가용도메인 조회 (춘천 AD 1개)
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

locals {
  ad_name = data.oci_identity_availability_domains.ads.availability_domains[0].name
}

# 최신 Ubuntu 이미지
data "oci_core_images" "ubuntu" {
  compartment_id           = var.compartment_id
  operating_system         = var.os
  operating_system_version = var.os_version
  shape                    = var.shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "vm" {
  availability_domain = local.ad_name
  compartment_id      = var.compartment_id
  display_name        = var.display_name
  shape               = var.shape

  # A1 Flex일 때만 적용
  dynamic "shape_config" {
    for_each = var.shape == "VM.Standard.A1.Flex" ? [1] : []
    content {
      ocpus         = var.ocpus
      memory_in_gbs = var.memory_in_gbs
    }
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
    hostname_label   = var.hostname_label
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }
}

# 공인 IP
data "oci_core_vnic_attachments" "va" {
  compartment_id = var.compartment_id
  instance_id    = oci_core_instance.vm.id
}

data "oci_core_vnic" "primary" {
  vnic_id = data.oci_core_vnic_attachments.va.vnic_attachments[0].vnic_id
}
