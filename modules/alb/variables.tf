# environment Variables
variable "project_name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

# alb variables
variable "alb_security_group_id" {
    description = "alb security group id"
    type = string
}

variable "public_subnet_az1_id" {
    description = "public subnet az1 id"
    type = string
}

variable "public_subnet_az2_id" {
    description = "public subnet az2 id"
    type = string
}

variable "target_type" {
    description = "target type"
    type = string
}

variable "vpc_id" {
    description = "vpc id"
    type = string
}

variable "health_check_path" {
    description = "health check path"
    type = string
}

variable "alb_http_listener_type" {
    description = "alb http listener type"
    type = string
}

variable "acm_certificate_arn" {
    description = "acm certificate arn"
    type = string
}

variable "alb_https_listener_ssl_policy" {
    description = "alb https listener ssl policy"
    type = string
}

variable "alb_https_listener_type" {
    description = "alb https listener type"
    type = string
}