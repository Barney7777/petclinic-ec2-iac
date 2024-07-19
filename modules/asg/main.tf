# use data source to get a registered amazon linux 2 ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["ec2-instance-ami-*"]
  }

  #   filter {
  #     name   = "tag:Environment"
  #     values = ["dev"]
  #   }

  #   filter {
  #     name   = "tag:CreatedBy"
  #     values = ["Packer"]
  #   }
}

# create a launch template
resource "aws_launch_template" "app_launch_template" {
  name          = "${var.project_name}-${var.environment}-launch-template"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.app_launch_template_instance_type
  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }
  #   user_data              = base64encode(templatefile("userdata.sh", { mysql_url = aws_db_instance.database_instance.endpoint }))
  vpc_security_group_ids = [var.alb_security_group_id]
  lifecycle {
    create_before_destroy = true
  }
  description = "launch template for asg"
  monitoring {
    enabled = true
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-launch-template"
  }
}

# create auto scaling group
resource "aws_autoscaling_group" "auto_scaling_group" {
  name                = "${var.project_name}-${var.environment}-asg"
  vpc_zone_identifier = [var.private_app_subnet_az1_id, var.private_app_subnet_az2_id]
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  force_delete        = true
  depends_on          = [var.alb_arn]
  target_group_arns   = [var.alb_target_group_arn]
  health_check_type   = var.asg_health_check_type

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest" # if we have mutiple version of template, we use the latest one
  }
  lifecycle {
    ignore_changes = [target_group_arns]
  }
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-asg"
    propagate_at_launch = true # if asg create ec2, it will tag this name to the server
  }
}

# scale up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project_name}-${var.environment}-asg-scale-up"
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.name
  adjustment_type        = var.asg_scale_up_adjustment_type
  scaling_adjustment     = var.asg_scale_up_scaling_adjustment  #increasing instance by #
  cooldown               = var.asg_scale_up_cooldown_time
  policy_type            = var.asg_scale_up_policy_type
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-asg-scale-up-alarm"
  alarm_description   = var.scale_up_alarm_description
  comparison_operator = var.scale_up_alarm_comparison_operator
  evaluation_periods  = var.scale_up_alarm_evaluation_periods
  metric_name         = var.scale_up_alarm_metric_name
  namespace           = var.scale_up_alarm_namespace
  period              = var.scale_up_alarm_period
  statistic           = var.scale_up_alarm_statistic
  threshold           = var.scale_up_alarm_threshold # New instance will be created once CPU utilization is higher than 30 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.auto_scaling_group.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

# scale down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project_name}-${var.environment}-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.name
  adjustment_type        = var.scale_down_adjustment_type
  scaling_adjustment     = var.scale_down_scaling_adjustment # decreasing instance by #
  cooldown               = var.scale_down_cooldown_time
  policy_type            = var.scale_down_policy_type
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-asg-scale-down-alarm"
  alarm_description   = var.scale_down_alarm_description
  comparison_operator = var.scale_down_alarm_comparison_operator
  evaluation_periods  = var.scale_down_alarm_evaluation_periods
  metric_name         = var.scale_down_alarm_metric_name
  namespace           = var.scale_down_alarm_namespace
  period              = var.scale_down_alarm_period
  statistic           = var.scale_down_alarm_statistic
  threshold           = var.scale_down_alarm_threshold # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.auto_scaling_group.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}

resource "aws_autoscaling_notification" "webserver_asg_notifications" {
  group_names = [aws_autoscaling_group.auto_scaling_group.name] #asg group name

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = var.user_updates_arn #sns topic arn
}