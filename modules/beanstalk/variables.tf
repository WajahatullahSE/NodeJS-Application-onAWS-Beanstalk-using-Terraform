variable "region"            { type = string }
variable "app_name"          { type = string }
variable "env_name"          { type = string }
variable "environment_tag"   { type = string }

variable "s3_bucket"         { type = string }
variable "s3_key"            { type = string }

variable "alb_sg_id"         { type = string }
variable "ec2_sg_id"         { type = string }

variable "public_subnets"    { type = list(string) }

variable "service_role_arn"  { type = string }
variable "instance_profile"  { type = string }
variable "keypair"           { type = string }

variable "instance_types"    { type = list(string) }
variable "min_size"          { type = number }
variable "max_size"          { type = number }
