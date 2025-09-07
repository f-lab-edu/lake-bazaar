
variable "project_id" {
  description = "GCP 프로젝트 ID"
  type        = string
}

variable "region" {
  description = "GCP 리전 (예: asia-northeast3)"
  type        = string
}

variable "zone" {
  description = "GCP 존 (예: asia-northeast3-a)"
  type        = string
}

variable "gcp_credentials_file" {
  description = "GCP 서비스 계정 키 파일 경로"
  type        = string
}

variable "ssh_public_key_abs_path" {
  description = "SSH 공개키 절대경로 (예: /home/you/.ssh/id_ed25519.pub)"
  type        = string
}
