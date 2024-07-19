locals {
  project_name = var.project_name
  environment  = var.environment
  region       = var.region
}

module "vpc" {
  source                       = "../modules/vpc"
  project_name                 = local.project_name
  environment                  = local.environment
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

module "nat-gateway" {
  source                    = "../modules/nat-gateway"
  project_name              = local.project_name
  environment               = local.environment
  public_subnet_az1_id      = module.vpc.public_subnet_az1_id
  public_subnet_az2_id      = module.vpc.public_subnet_az2_id
  vpc_id                    = module.vpc.vpc_id
  private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id = module.vpc.private_app_subnet_az2_id
  igw_id                    = module.vpc.igw_id
}

module "sg" {
  source       = "../modules/sg"
  project_name = local.project_name
  environment  = local.environment
  vpc_id       = module.vpc.vpc_id
}

module "iam" {
  source       = "../modules/iam"
  project_name = local.project_name
  environment  = local.environment
}

module "ec2" {
  source                = "../modules/ec2"
  region                = local.region
  vpc_id                = module.vpc.vpc_id
  ec2_security_group_id = module.sg.ec2_security_group_id
}

module "acm" {
  source           = "../modules/acm"
  hosted_zone_name = var.hosted_zone_name
  subdomain_name   = var.subdomain_name
}

module "route53" {
  source                             = "../modules/route53"
  hosted_zone_name                   = module.acm.hosted_zone_name
  record_name                        = var.record_name
  application_load_balancer_dns_name = module.alb.application_load_balancer_dns_name
  application_load_balancer_zone_id  = module.alb.application_load_balancer_zone_id
}

module "alb" {
  source                        = "../modules/alb"
  project_name                  = local.project_name
  environment                   = local.environment
  alb_security_group_id         = module.sg.alb_security_group_id
  public_subnet_az1_id          = module.vpc.public_subnet_az1_id
  public_subnet_az2_id          = module.vpc.public_subnet_az2_id
  target_type                   = var.target_type
  vpc_id                        = module.vpc.vpc_id
  health_check_path             = var.health_check_path
  alb_http_listener_type        = var.alb_http_listener_type
  acm_certificate_arn           = module.acm.acm_certificate_arn
  alb_https_listener_ssl_policy = var.alb_https_listener_ssl_policy
  alb_https_listener_type       = var.alb_https_listener_type
}

module "sns" {
  source         = "../modules/sns"
  operator_email = var.operator_email
}

module "asg" {
  source                               = "../modules/asg"
  project_name                         = local.project_name
  environment                          = local.environment
  app_launch_template_instance_type    = var.app_launch_template_instance_type
  ec2_instance_profile_name            = module.iam.ec2_instance_profile_name
  alb_security_group_id                = module.sg.alb_security_group_id
  private_app_subnet_az1_id            = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id            = module.vpc.private_app_subnet_az2_id
  desired_capacity                     = var.desired_capacity
  max_size                             = var.max_size
  min_size                             = var.min_size
  depends_on                           = [module.alb]
  alb_arn                              = module.alb.alb_arn
  alb_target_group_arn                 = module.alb.alb_target_group_arn
  asg_health_check_type                = var.asg_health_check_type
  asg_scale_up_adjustment_type         = var.asg_scale_up_adjustment_type
  asg_scale_up_scaling_adjustment      = var.asg_scale_up_scaling_adjustment
  asg_scale_up_cooldown_time           = var.asg_scale_up_cooldown_time
  asg_scale_up_policy_type             = var.asg_scale_up_policy_type
  scale_up_alarm_description           = var.scale_up_alarm_description
  scale_up_alarm_comparison_operator   = var.scale_up_alarm_comparison_operator
  scale_up_alarm_evaluation_periods    = var.scale_up_alarm_evaluation_periods
  scale_up_alarm_metric_name           = var.scale_up_alarm_metric_name
  scale_up_alarm_namespace             = var.scale_up_alarm_namespace
  scale_up_alarm_period                = var.scale_up_alarm_period
  scale_up_alarm_statistic             = var.scale_up_alarm_statistic
  scale_up_alarm_threshold             = var.scale_up_alarm_threshold
  scale_down_adjustment_type           = var.scale_down_adjustment_type
  scale_down_scaling_adjustment        = var.scale_down_scaling_adjustment
  scale_down_cooldown_time             = var.scale_down_cooldown_time
  scale_down_policy_type               = var.scale_down_policy_type
  scale_down_alarm_description         = var.scale_down_alarm_description
  scale_down_alarm_comparison_operator = var.scale_down_alarm_comparison_operator
  scale_down_alarm_evaluation_periods  = var.scale_down_alarm_evaluation_periods
  scale_down_alarm_metric_name         = var.scale_down_alarm_metric_name
  scale_down_alarm_namespace           = var.scale_down_alarm_namespace
  scale_down_alarm_period              = var.scale_down_alarm_period
  scale_down_alarm_statistic           = var.scale_down_alarm_statistic
  scale_down_alarm_threshold           = var.scale_down_alarm_threshold
  user_updates_arn                     = module.sns.user_updates_arn
}

module "rds" {
  source                                = "../modules/rds"
  project_name                          = local.project_name
  environment                           = local.environment
  private_data_subnet_az1_id            = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id            = module.vpc.private_data_subnet_az2_id
  database_instance_engine              = var.database_instance_engine
  database_instance_engine_version      = var.database_instance_engine_version
  database_instance_multi_az            = var.database_instance_multi_az
  database_instance_identifier          = var.database_instance_identifier
  database_instance_username            = var.database_instance_username
  database_instance_password            = var.database_instance_password
  database_instance_instance_class      = var.database_instance_instance_class
  database_instance_az                  = var.database_instance_az
  database_instance_db_name             = var.database_instance_db_name
  database_instance_skip_final_snapshot = var.database_instance_skip_final_snapshot
  database_security_group_id            = module.sg.database_security_group_id
  database_instance_allocated_storage   = var.database_instance_allocated_storage
  database_instance_publicly_accessible = var.database_instance_publicly_accessible
  database_instance_storage_encrypted   = var.database_instance_storage_encrypted
  depends_on                            = [module.vpc]
}