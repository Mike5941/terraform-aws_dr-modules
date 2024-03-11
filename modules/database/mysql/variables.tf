variable "db_name" {
  type = string
  default = null
}

variable "db_username" {
  type = string
  sensitive = true
  default = null
}

variable "db_password" {
  type = string
  sensitive = true
  default = null
}

variable "vpc_remote_state_bucket" {
  type = string
}

variable "vpc_remote_state_key" {
  type = string
}

variable "backup_retention_period" {
  description = "Days to retain backups. Must be > 0 to enable replication."
  type        = number
  default     = null
}

variable "replicate_source_db" {
  description = "If specified, replicate the RDS database at the given ARN."
  type        = string
  default     = null
}

locals {
  seoul_region = "ap-northeast-2"
  mysql_port = 3306
}