#variable "engine_type" {
#  type    = string
#  default = "aurora-mysql"
#}
#
#variable "engine_mode" {
#  type    = string
#  default = "provisioned"
#}
#
#
#variable "backup_retention_period" {
#  type    = number
#  default = null
#}
#
#variable "replication_source_identifier" {
#  type    = string
#  default = null
#}
#
#
#variable "vpc_id" {
#  type = string
#}
#
#variable "engine_version" {
#  type = string
#  default = "8.0.mysql_aurora.3.05.0"
#}
#
#variable "cluster_identifier" {
#  type = string
#}
#
#variable "identifier_prefix" {
#  type = string
#}
#
#variable "skip_final_snapshot" {
#  type    = bool
#  default = true
#}
#
#variable "instance_count" {
#  type    = number
#  default = 2
#}
#
#variable "db_name" {
#  type = string
#  default = null
#}
#
#variable "db_username" {
#  type = string
#  default = null
#  sensitive = true
#}
#
#variable "security_group" {
#  type = set(string)
#  default = null
#}
#
#variable "db_password" {
#  type = string
#  sensitive = true
#  default = null
#}
#
#variable "db_subnet_group_name" {
#  type = string
#  default = null
#}
#
#variable "instance_class" {
#  type = string
#  default = "db.t3.medium"
#}
#
#variable "source_region" {
#  type = string
#  default = null
#}
#
