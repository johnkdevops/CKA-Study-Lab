resource "aws_vpc" "cka-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cka-vpc"
  }
}

resource "aws_subnet" "cka-subnet" {
  vpc_id     = aws_vpc.cka-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "cka-subnet"
  }
}

