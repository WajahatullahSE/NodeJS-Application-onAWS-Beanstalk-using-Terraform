# VPC Module
module "vpc" {
  source               = "./modules/vpc"
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  environment_tag      = var.environment_tag
}

# Security Module
module "security" {
  source          = "./modules/security"
  vpc_id          = module.vpc.vpc_id
  environment_tag = var.environment_tag
}

# Elastic Beanstalk Module
module "beanstalk" {
  source            = "./modules/beanstalk"

  region            = var.region
  app_name          = var.app_name
  env_name          = var.env_name
  environment_tag   = var.environment_tag

  s3_bucket         = var.s3_bucket
  s3_key            = var.s3_key

  alb_sg_id         = module.security.alb_sg_id
  ec2_sg_id         = module.security.ec2_sg_id

  public_subnets    = module.vpc.public_subnet_ids

  service_role_arn  = var.service_role_arn
  instance_profile  = var.instance_profile
  keypair           = var.keypair

  instance_types    = var.instance_types
  min_size          = var.min_size
  max_size          = var.max_size
}
