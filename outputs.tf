output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "alb_security_group" {
  value = module.security.alb_sg_id
}

output "ec2_security_group" {
  value = module.security.ec2_sg_id
}

output "beanstalk_url" {
  value = module.beanstalk.environment_url
}
