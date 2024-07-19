# environment Variables
variable "project_name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

#launch template variables 
variable "app_launch_template_instance_type" {
  description = "ec2 instance type"
  type        = string
}

variable "ec2_instance_profile_name" {
    description = "ec2 instance profile name"
    type        = string
}

variable "alb_security_group_id" {
    description = "alb security group id"
    type        = string
}


variable "private_app_subnet_az1_id" {
    description = "private app subnet az1 id"
    type        = string
}

variable "private_app_subnet_az2_id" {
    description = "private app subnet az2 id"
    type        = string  
}

variable "desired_capacity" {
  description = "desired capacity"
  type        = string
}

variable "max_size" {
  description = "max size"
  type        = string
}

variable "min_size" {
  description = "min size"
  type        = string
}

variable "alb_arn" {
    description = "alb arn"
    type        = string
}

variable "alb_target_group_arn" {
    description = "alb target group arn"
    type        = string
}

variable "asg_health_check_type" {
    description = "asg health check type"
    type        = string  
}

# scale up policy
variable "asg_scale_up_adjustment_type" {
    description = "asg scale up adjustment type"
    type        = string
}

variable "asg_scale_up_scaling_adjustment" {
    description = "asg scale up scaling adjustment"
    type        = string
}

variable "asg_scale_up_cooldown_time" {
    description = "asg scale up cooldown time"
    type        = string
}

variable "asg_scale_up_policy_type" {
    description = "asg scale up policy type"
    type        = string
}

# scale up alarm
variable "scale_up_alarm_description" {
    description = "scale up alarm description"
    type        = string
}
  
variable "scale_up_alarm_comparison_operator" {
    description = "scale up alarm comparison operator"
    type        = string
}
  
variable "scale_up_alarm_evaluation_periods" {
    description = "scale up alarm evaluation periods"
    type        = string
}
  
variable "scale_up_alarm_metric_name" {
    description = "scale up alarm metric name"
    type        = string
}
  
variable "scale_up_alarm_namespace" {
    description = "scale up alarm namespace"
    type        = string
}

variable "scale_up_alarm_period" {
    description = "scale up alarm period"
    type        = string
}

variable "scale_up_alarm_statistic" {
    description = "scale up alarm statistic"
    type        = string
}

variable "scale_up_alarm_threshold" {
    description = "scale up alarm threshold"
    type        = string
}

# scale down policy
variable "scale_down_adjustment_type" {
    description = "scale down adjustment type"
    type        = string
}
  
variable "scale_down_scaling_adjustment" {
    description = "scale down scaling adjustment"
    type        = string
}

variable "scale_down_cooldown_time" {
    description = "scale down cooldown time"
    type        = string
}
  
variable "scale_down_policy_type" {
    description = "scale down policy type"
    type        = string
}

# scale down alarm 
variable "scale_down_alarm_description" {
    description = "scale down alarm description"
    type        = string
}

variable "scale_down_alarm_comparison_operator" {
    description = "scale down alarm comparison operator"
    type        = string
}


variable "scale_down_alarm_evaluation_periods" {
    description = "scale down evaluation periods"
    type        = string
}
  
variable "scale_down_alarm_metric_name" {
    description = "scale down metric name"
    type        = string
}

variable "scale_down_alarm_namespace" {
    description = "scale down alarm namespace"
    type        = string
}
  
variable "scale_down_alarm_period" {
    description = "scale down adjustment period"
    type        = string
}
  
variable "scale_down_alarm_statistic" {
    description = "scale down alarm statistic"
    type        = string
}
 
variable "scale_down_alarm_threshold" {
    description = "scale down alarm threshold"
    type        = string
}

variable "user_updates_arn" {
    description = "user updates arn"
    type        = string
}