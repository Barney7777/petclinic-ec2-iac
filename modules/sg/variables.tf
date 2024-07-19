# environment Variables
variable "project_name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

# sg variables
variable "vpc_id" {
    description = "vpc id"
    type        = string
}