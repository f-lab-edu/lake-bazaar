
variable "region" {
  description = "GCP 리전 (예: us-central1)"
  type        = string
  default     = "us-central1"
}

variable "public_subnet_cidr" {
  description = "VPC 서브넷 CIDR"
  type        = string
  default     = "10.0.1.0/24"
}


variable "ssh_source_cidrs" {
  description = "허용할 SSH 소스 CIDR"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


variable "internal_cidr" {
  description = "클러스터 내부 통신 허용 CIDR (예: 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}


variable "service_ports" {
  description = "클러스터 서비스별 허용 포트 목록"
  type        = list(number)
  default     = [
    2181,   # Zookeeper
    2888,   # Zookeeper
    3888,   # Zookeeper
    9870,   # Hadoop NN
    9864,   # Hadoop DN
    8088,   # YARN RM
    8042,   # YARN NM
    18080,  # Spark History
    10020,  # MapReduce JHS
    10000,  # HiveServer2
    9083,   # Hive Metastore
    8080,   # Airflow
    3306    # MySQL
    13562   # 추가 포트
  ]
}
