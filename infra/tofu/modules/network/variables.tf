variable "compartment_id" {
  type = string
}

variable "vcn_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "ssh_source_cidrs" {
  description = "허용할 SSH 소스 CIDR"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
