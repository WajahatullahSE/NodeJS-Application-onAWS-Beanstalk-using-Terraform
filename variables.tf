variable "region" {
  type = string
}

variable "environment_tag" {
  type = string
}

# VPC
variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

# Beanstalk
variable "app_name" {
  type = string
}

variable "env_name" {
  type = string
}

variable "s3_bucket" {
  type = string
}

variable "s3_key" {
  type = string
}

variable "service_role_arn" {
  type = string
}

variable "instance_profile" {
  type = string
}

variable "keypair" {
  type = string
}

variable "instance_types" {
  type = list(string)
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}
