# environment Variables
variable "project_name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

# nat-gateway Variables
variable "igw_id" {
  description = "igw_id"
  type = string
}

variable "vpc_id" {
  description = "vpc_id"
  type = string
}

variable "public_subnet_az1_id" {
  description = "public_subnet_az1_id"
  type = string
}

variable "public_subnet_az2_id" {
  description = "public_subnet_az2_id"
  type = string
}

variable "private_app_subnet_az1_id" {
  description = "private_subnet_az1_id"
  type = string
}

variable "private_app_subnet_az2_id" {
  description = "private_subnet_az2_id"
  type = string
}

