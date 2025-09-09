variable "region" {
  type    = string
  default = "ap-chuncheon-1"
}

variable "compartment_ocid" {
  type = string
}

variable "tenancy_ocid" {
  type = string
}

variable "ssh_public_key_abs_path" {
  description = "SSH 공개키 절대경로 (예: /home/you/.ssh/id_ed25519.pub)"
  type        = string
}

# 무료 우선: E2 Micro. 부족하면 A1 Flex로 전환.
variable "shape" {
  type    = string
  default = "VM.Standard.E2.1.Micro"
}

# A1 Flex일 때만 사용 (E2 Micro이면 무시)
variable "a1flex_ocpus" {
  type    = number
  default = 1
}

variable "a1flex_memory_gb" {
  type    = number
  default = 6
}
