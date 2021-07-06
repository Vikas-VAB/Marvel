provider "aws" {
   region = "us-east-2"
   access_key = ""
   secret_key = ""
}


resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_vpc" "vpc1" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "vpc1"
  }
}

resource "aws_internet_gateway" "test_gateway" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "test_gateway"
  }
}

resource "aws_route_table" "test_route" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.test_gateway.id
  }

  tags = {
    Name = "test_route"
  }
}

resource "aws_route_table_association" "associate" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.test_route.id
}

resource "aws_security_group" "terra1" {
  name        = "terra1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc1.id

   ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
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
    Name = "terra1"
  }
}

resource "aws_network_interface" "test_interface" {
  subnet_id       = aws_subnet.subnet1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.terra1.id]
}


resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.test_interface.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.test_gateway]
}


resource "aws_instance" "terra2" {
  ami           = "ami-05d72852800cbf29e"
  instance_type = "t2.micro"
  key_name = "Vikasab"
  availability_zone = "us-east-2b"
  user_data = file("user_data.sh")

  network_interface {
     device_index = 0
     network_interface_id = aws_network_interface.test_interface.id
}

  tags = {
    Name = "terra2"
  }
}
