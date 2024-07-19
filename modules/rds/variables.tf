# environment Variables
variable "project_name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

variable "private_data_subnet_az1_id" {
    description = "private data subnet az1 id"
    type        = string
}
  
variable "private_data_subnet_az2_id" {
    description = "private data subnet az2 id"
    type        = string
}
  
variable "database_instance_engine" {
    description = "database instance engine"
    type        = string
}
  
variable "database_instance_engine_version" {
    description = "database instance engine version"
    type        = string
}
  
variable "database_instance_multi_az" {
    description = "database instance multi az"
    type        = bool
}
  
variable "database_instance_identifier" {
    description = "database instance identifier"
    type        = string 
}

variable "database_instance_username" {
    description = "database instance username"
    type        = string
}

variable "database_instance_password" {
    description = "database instance password"
    type        = string
}
  
variable "database_instance_instance_class" {
    description = "database instance instance class"
    type        = string
}
  
variable "database_instance_az" {
    description = "database instance az"
    type        = string
}
  
variable "database_instance_db_name" {
    description = "database instance db name"
    type        = string
}
  
variable "database_instance_skip_final_snapshot" {
    description = "database instance skip final snapshot"
    type        = bool
}
  
variable "database_security_group_id" {
    description = "database security group id"
    type        = string
}
  
variable "database_instance_allocated_storage" {
    description = "database instance allocated storage"
    type        = number
}
  
variable "database_instance_publicly_accessible" {
    description = "database instance publicly accessible"
    type        = bool
}

variable "database_instance_storage_encrypted" {
    description = "database instance storage encrypted"
    type        = bool
}