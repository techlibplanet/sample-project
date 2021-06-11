

variable "network_address_space" {
  default = "10.1.0.0/16"
}
variable "subnet_1_address_space" {
  default = "10.1.0.0/24"
}
variable "subnet_2_address_space" {
  default = "10.1.1.0/24"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.network_address_space
  enable_dns_hostnames = "true"
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

resource "aws_subnet" "subnet-1" {
  cidr_block              = var.subnet_1_address_space
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-subnet-1"
  })
}

resource "aws_subnet" "subnet-2" {
  cidr_block              = var.subnet_2_address_space
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-subnet-2"
  })
}
