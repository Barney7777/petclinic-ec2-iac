locals {
  project_name = var.project_name
  environment  = var.environment
  region       = var.region
}

# Create vpc
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
    source = "../modules/ec2"
    region = local.region
    vpc_id       = module.vpc.vpc_id
    ec2_security_group_id = module.sg.ec2_security_group_id
  
}

