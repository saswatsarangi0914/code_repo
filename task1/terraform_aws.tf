provider "aws" {
  region                  = var.region
  shared_credentials_file = ""
  profile                 = "saswatAdmin"
}
resource "aws_key_pair" "example" {
  key_name = "examplekey"
  public_key = file("C:/Users/saswat.sarangi/.ssh/id_rsa.pub")
}
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "terraform_vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "gw"
  }
}

resource "aws_subnet" "public_subnet_1"{
  vpc_id  = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2"{
  vpc_id  = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_1"{
  vpc_id  = "${aws_vpc.main.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2"{
  vpc_id  = "${aws_vpc.main.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "private_subnet_2"
  }
}

resource "aws_route_table" "public_route1" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "public_route1"
  }
}

resource "aws_route_table" "private_route1" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "private_route1"
  }
}

resource "aws_route_table_association" "public_route1_as" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route1.id

}
resource "aws_route_table_association" "public_route2_as" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route1.id

}

resource "aws_route_table_association" "private_route1_as" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route1.id
}

resource "aws_route_table_association" "private_route2_as" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route1.id
}


resource "aws_security_group" "sg_lb_external" {
  name        = "allow port 443 and port 80 for frontend"
  description = "allow port 443 and port 80 for frontend"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  }
   ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  }

  tags = {
    Name = "sg_lb_external"
  }
}

resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "allow port 443 and port 80 for frontend"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  }
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  }
   ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  }

  tags = {
    Name = "frontend_sg"
  }
}

resource "aws_lb" "lb_external" {
  name               = "lb-external"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg_lb_external.id}"]
  subnets            = ["${aws_subnet.public_subnet_1.id}","${aws_subnet.public_subnet_2.id}"]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "frontend_group80" {
  name     = "frontend-group80"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
}
resource "aws_lb_target_group" "frontend_group443" {
  name     = "frontend-group443"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "${aws_vpc.main.id}"
}

resource "aws_instance" "frontend_server01" {
  key_name = aws_key_pair.example.key_name
  subnet_id = aws_subnet.public_subnet_1.id
  vpc_security_group_ids =  ["${aws_security_group.frontend_sg.id}"]
  ami           = var.amis[var.region]
  instance_type = "t2.micro"
  associate_public_ip_address = true
}

resource "aws_lb_target_group_attachment" "frontend_lb_att80" {
  target_group_arn = "${aws_lb_target_group.frontend_group80.arn}"
  target_id        = "${aws_instance.frontend_server01.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "frontend_lb_att443" {
  target_group_arn = "${aws_lb_target_group.frontend_group443.arn}"
  target_id        = "${aws_instance.frontend_server01.id}"
  port             = 443
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.lb_external.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.frontend_group80.arn}"
  }
}

