variable "compartment_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "shape" {
  type    = string
  default = "VM.Standard.E2.1.Micro"
}

variable "tenancy_ocid" {
  type = string
}

variable "ocpus" {
  type    = number
  default = 1
}

variable "memory_in_gbs" {
  type    = number
  default = 6
}

variable "display_name" {
  type    = string
  default = "dev-vm-1"
}

variable "hostname_label" {
  type    = string
  default = "devvm1"
}

variable "ssh_authorized_keys" {
  type = string
}

variable "os" {
  type    = string
  default = "Canonical Ubuntu"
}

variable "os_version" {
  type    = string
  default = "22.04"
}
