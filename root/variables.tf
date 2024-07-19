# environment variables
variable "region" {}
variable "project_name" {}
variable "environment" {}

# VPC variables
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_app_subnet_az1_cidr" {}
variable "private_app_subnet_az2_cidr" {}
variable "private_data_subnet_az1_cidr" {}
variable "private_data_subnet_az2_cidr" {}

# acm variables
variable "subdomain_name" {}
variable "hosted_zone_name" {}

# route53 variables
variable "record_name" {}

# alb variables
variable "target_type" {}
variable "health_check_path" {}
variable "alb_http_listener_type" {}
variable "alb_https_listener_ssl_policy" {}
variable "alb_https_listener_type" {}

# sns topic variables
variable "operator_email" {
  description = "a valid email address"
  type        = string
}

# asg variables
variable "app_launch_template_instance_type" {}
variable "desired_capacity" {}
variable "max_size" {}
variable "min_size" {}
variable "asg_health_check_type" {}
variable "asg_scale_up_adjustment_type" {}
variable "asg_scale_up_scaling_adjustment" {}
variable "asg_scale_up_cooldown_time" {}
variable "asg_scale_up_policy_type" {}
variable "scale_up_alarm_description" {}
variable "scale_up_alarm_comparison_operator" {}
variable "scale_up_alarm_evaluation_periods" {}
variable "scale_up_alarm_metric_name" {}
variable "scale_up_alarm_namespace" {}
variable "scale_up_alarm_period" {}
variable "scale_up_alarm_statistic" {}
variable "scale_up_alarm_threshold" {}
variable "scale_down_adjustment_type" {}
variable "scale_down_scaling_adjustment" {}
variable "scale_down_cooldown_time" {}
variable "scale_down_policy_type" {}
variable "scale_down_alarm_description" {}
variable "scale_down_alarm_comparison_operator" {}
variable "scale_down_alarm_evaluation_periods" {}
variable "scale_down_alarm_metric_name" {}
variable "scale_down_alarm_namespace" {}
variable "scale_down_alarm_period" {}
variable "scale_down_alarm_statistic" {}
variable "scale_down_alarm_threshold" {}
