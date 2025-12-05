# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "wu-alb-sg"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "wu-alb-sg"
    Environment = var.environment_tag
  }
}

# EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "wu-ec2-sg"
  description = "EC2 security group for Beanstalk"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ALB to reach EC2 on port 80"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "wu-ec2-sg"
    Environment = var.environment_tag
  }
}
