# EB Application
resource "aws_elastic_beanstalk_application" "this" {
  name        = var.app_name
  description = "Elastic Beanstalk Node.js Application"

  tags = {
    Name        = var.app_name
    Environment = var.environment_tag
  }
}

# EB Application Version
resource "aws_elastic_beanstalk_application_version" "version" {
  #name        = "${var.app_name}-v3"       #initial version
  name        = "${var.app_name}-v4"        #new version
  application = aws_elastic_beanstalk_application.this.name
  bucket      = var.s3_bucket
  key         = var.s3_key

  tags = {
    #Name        = "${var.app_name}-v3"
    Name        = "${var.app_name}-v4"      #new version
    Environment = var.environment_tag
  }
}

# EB Environment
resource "aws_elastic_beanstalk_environment" "env" {
  name                = var.env_name
  application         = aws_elastic_beanstalk_application.this.name
  version_label       = aws_elastic_beanstalk_application_version.version.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.7.0 running Node.js 24"

  # Configuration
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_types[0]
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.min_size
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.max_size
  }

  # Assign security groups
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.ec2_sg_id
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "SecurityGroups"
    value     = var.alb_sg_id
  }

  # Subnets for ALB and EC2 instances
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.public_subnets)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.public_subnets)
  }

  # IAM roles
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.service_role_arn
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.instance_profile
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = var.keypair
  }

  tags = {
    Name        = var.env_name
    Environment = var.environment_tag
  }
}
