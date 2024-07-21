variable "hosted_zone_name" {
    description = "hosted zone name"
    type = string
}

variable "record_name" {
    description = "record name"
    type = string
}

variable "application_load_balancer_dns_name" {
    description = "application load balancer dns name"
    type = string
}

variable "application_load_balancer_zone_id" {
    description = "application load balancer zone id"
    type = string
}