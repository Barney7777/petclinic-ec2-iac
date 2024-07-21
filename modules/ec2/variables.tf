# environment variables
variable "region" {
    description = "region"
    type = string
}

# ec2 variables
variable "vpc_id" {
    description = "vpc id"
    type = string
}

variable "ec2_security_group_id" {
    description = "ec2 security group id"
    type = string
}