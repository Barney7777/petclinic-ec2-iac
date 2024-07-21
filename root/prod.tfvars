# environment Variables
project_name = "petclinic"
environment  = "prod"
region       = "ap-southeast-2"

# VPC variables
vpc_cidr                     = "166.166.0.0/16"
public_subnet_az1_cidr       = "166.166.0.0/24"
public_subnet_az2_cidr       = "166.166.1.0/24"
private_app_subnet_az1_cidr  = "166.166.2.0/24"
private_app_subnet_az2_cidr  = "166.166.3.0/24"
private_data_subnet_az1_cidr = "166.166.4.0/24"
private_data_subnet_az2_cidr = "166.166.5.0/24"

# acm variable
hosted_zone_name = "barneywang.click"
subdomain_name   = "barneywang.click"

# route53 variables
record_name = "*"

# alb variables
target_type                   = "instance"
health_check_path             = "/"
alb_http_listener_type        = "redirect"
alb_https_listener_ssl_policy = "ELBSecurityPolicy-2016-08"
alb_https_listener_type       = "forward"

# sns topic variables
operator_email = "wangyaxu7@gmail.com"

# asg variables
app_launch_template_instance_type    = "t2.micro"
desired_capacity                     = "1"
max_size                             = "2"
min_size                             = "1"
asg_health_check_type                = "EC2" # or ALB
asg_scale_up_adjustment_type         = "ChangeInCapacity"
asg_scale_up_scaling_adjustment      = "1" #increasing instance by 1 
asg_scale_up_cooldown_time           = "300"
asg_scale_up_policy_type             = "SimpleScaling"
scale_up_alarm_description           = "asg-scale-up-cpu-alarm"
scale_up_alarm_comparison_operator   = "GreaterThanOrEqualToThreshold"
scale_up_alarm_evaluation_periods    = "2"
scale_up_alarm_metric_name           = "CPUUtilization"
scale_up_alarm_namespace             = "AWS/EC2"
scale_up_alarm_period                = "120"
scale_up_alarm_statistic             = "Average"
scale_up_alarm_threshold             = "70"
scale_down_adjustment_type           = "ChangeInCapacity"
scale_down_scaling_adjustment        = "-1" # decreasing instance by 1 
scale_down_cooldown_time             = "300"
scale_down_policy_type               = "SimpleScaling"
scale_down_alarm_description         = "asg-scale-down-cpu-alarm"
scale_down_alarm_comparison_operator = "LessThanOrEqualToThreshold"
scale_down_alarm_evaluation_periods  = "2"
scale_down_alarm_metric_name         = "CPUUtilization"
scale_down_alarm_namespace           = "AWS/EC2"
scale_down_alarm_period              = "120"
scale_down_alarm_statistic           = "Average"
scale_down_alarm_threshold           = "5" # Instance will scale down when CPU utilization is lower than 5 %

# database variables
database_instance_engine         = "mysql"
database_instance_engine_version = "8.0.34"
database_instance_multi_az       = false // true, Amazon RDS automatically creates a standby replica of your database instance in a different Availability Zone within the same AWS region.
database_instance_identifier     = "petclinic"
# database_instance_username            = "petclinic"
# database_instance_password            = "petclinic"
database_instance_instance_class      = "db.t3.micro"
database_instance_az                  = "ap-southeast-2a"
database_instance_db_name             = "petclinic"
database_instance_skip_final_snapshot = true // don't create snapshot when deleting database
database_instance_allocated_storage   = 20
database_instance_publicly_accessible = false //false: only in the same vpc can access rds
database_instance_storage_encrypted   = false
