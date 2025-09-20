variable "ssh_private_key_abs_path" {
  description = "SSH 프라이빗키 절대경로"
  type        = string
}

variable "project_id" {
  description = "GCP 프로젝트 ID"
  type        = string
}

variable "region" {
  description = "GCP 리전"
  type        = string
}

variable "zone" {
  description = "GCP 존"
  type        = string
}

variable "gcp_credentials_file" {
  description = "GCP 자격 증명 파일 경로(선택). 비우면 ADC 사용"
  type        = string
  default     = ""
}

variable "ssh_public_key_abs_path" {
  description = "SSH 공개키 절대경로"
  type        = string
}

variable "ssh_user" {
  description = "프로비저닝/부트스트랩 시 사용할 원격 사용자"
  type        = string
}
