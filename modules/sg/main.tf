# create security group for the application load balancer
resource "aws_security_group" "alb_security_group" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

# Security group for ec2
resource "aws_security_group" "ec2_security_group" {
  name        = "${var.project_name}-${var.environment}-ec2-sg"
  vpc_id      = var.vpc_id
  description = "security group for VPC Endpoints"

  # Allow inbound HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from VPC"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-sg"
  }
}
# if you want to create an EC2 instance in a private subnet and connect to it using AWS Systems Manager (SSM), 
# you will need to set up VPC endpoints for SSM. 
# This is necessary because instances in a private subnet do not have direct access to the internet, 
# so they cannot reach the SSM service endpoints without a VPC endpoint.

# create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "enable mysql/aurora access on port 3306"
  vpc_id      = var.vpc_id

  ingress {
    description     = "mysql/aurora access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  # ingress {
  # description = "mysql/aurora access"
  # from_port   = 3306
  # to_port     = 3306
  # protocol    = "tcp"
  # cidr_blocks = [aws_subnet.private_subnet_az1.cidr_block, aws_subnet.private_subnet_az2.cidr_block]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-db-sg"
  }
}