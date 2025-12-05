# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "wu-app-vpc"
    Environment = var.environment_tag
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "wu-igw"
    Environment = var.environment_tag
  }
}

# Public Subnets (2 AZs)
resource "aws_subnet" "public" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidrs[count.index]

  availability_zone = "${var.region}${substr("ab", count.index, 1)}"

  map_public_ip_on_launch = true

  tags = {
    Name        = "wu-pub-sn-${count.index + 1}"
    Environment = var.environment_tag
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "wu-public-rt"
    Environment = var.environment_tag
  }
}

# Route: 0.0.0.0/0 -> IGW
resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate route table with public subnets
resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
