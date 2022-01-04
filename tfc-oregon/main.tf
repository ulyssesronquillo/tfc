terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# use tfc profile. set region to oregon.

provider "aws" {
  profile = "tfc"
  region  = "us-west-2"
}

# create a vpc

resource "aws_vpc" "livestream-vpc" {
  cidr_block       = "10.0.0.0/21"
  instance_tenancy = "default"
  tags = {
    Name = "livestream"
  }
}

# create 4 subnets

resource "aws_subnet" "livestream-subnet-2a" {
  vpc_id                  = aws_vpc.livestream-vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "livestream-10.0.0.0-us-west-2a"
  }
}

resource "aws_subnet" "livestream-subnet-2b" {
  vpc_id                  = aws_vpc.livestream-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "livestream-10.0.0.0-us-west-2b"
  }
}

resource "aws_subnet" "livestream-subnet-2c" {
  vpc_id                  = aws_vpc.livestream-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "livestream-10.0.1.0-us-west-2c"
  }
}

resource "aws_subnet" "livestream-subnet-2d" {
  vpc_id                  = aws_vpc.livestream-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2d"
  map_public_ip_on_launch = true
  tags = {
    Name = "livestream-10.0.2.0-us-west-2d"
  }
}

# create internet gateway

resource "aws_internet_gateway" "livestream-igw" {
  vpc_id = aws_vpc.livestream-vpc.id
  tags = {
    Name = "livestream-internet-gateway"
  }
}

# create default route to internet

resource "aws_default_route_table" "livestream-rt" {
  default_route_table_id = aws_vpc.livestream-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.livestream-igw.id
  }
  tags = {
    Name = "livestream-route-table"
  }
}

# create web security group

resource "aws_security_group" "livestream-web-server-sg" {
  name        = "livestream-web-server-sg"
  description = "allow ssh and web ports"
  vpc_id      = aws_vpc.livestream-vpc.id

  ingress {
    description = "ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "ALL"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "livestream-web-server-sg"
  }
}

# create load balancer

resource "aws_lb" "livestream-web-lb" {
  name               = "livestream-web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.livestream-web-server-sg.id]
  subnets            = [aws_subnet.livestream-subnet-2b.id, aws_subnet.livestream-subnet-2c.id, aws_subnet.livestream-subnet-2d.id]
  enable_http2       = false
  tags = {
    Name = "livestream-web-lb"
  }
}

# create target group

resource "aws_lb_target_group" "livestream-web-tg" {
  name     = "livestream-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.livestream-vpc.id
  health_check {
    interval            = 30
    path                = "/index.html"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# create listener

resource "aws_lb_listener" "livestream-web-listener" {
  load_balancer_arn = aws_lb.livestream-web-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.livestream-web-tg.arn
  }
}

# create launch configuration

resource "aws_launch_configuration" "livestream-web-launch-config" {
  name                 = "livestream-web-launch-config-1.4"
  image_id             = "ami-044142955eba675a6"
  instance_type        = "t2.micro"
  spot_price           = "0.0035"
  key_name             = "tfc-oregon"
  iam_instance_profile = "arn:aws:iam::944550773739:instance-profile/machinerole"
  security_groups      = [aws_security_group.livestream-web-server-sg.id]
  lifecycle {
    create_before_destroy = false
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 8
    volume_type           = "gp2"
  }
}

# create autoscaling group

resource "aws_autoscaling_group" "livestream-web-asg" {
  name                      = "livestream-web-asg"
  launch_configuration      = aws_launch_configuration.livestream-web-launch-config.name
  min_size                  = 3
  max_size                  = 3
  desired_capacity          = 3
  vpc_zone_identifier       = [aws_subnet.livestream-subnet-2b.id, aws_subnet.livestream-subnet-2c.id, aws_subnet.livestream-subnet-2d.id]
  health_check_type         = "EC2"
  health_check_grace_period = 15
  default_cooldown          = 15
  target_group_arns         = [aws_lb_target_group.livestream-web-tg.arn]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "livestream-web"
    propagate_at_launch = true
  }
}

# create wowza security group

resource "aws_security_group" "livestream-wowza-server-sg" {
  name        = "livestream-wowza-server-sg"
  description = "allow wowza ports"
  vpc_id      = aws_vpc.livestream-vpc.id

  ingress {
    description = "ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "wowza"
    from_port   = 1935
    to_port     = 1935
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
  ingress {
    description = "rtsp"
    from_port   = 554
    to_port     = 554
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "wowza-dashboard"
    from_port   = 8086
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "ALL"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "livestream-wowza-server-sg"
  }
}

# launch wowza server

resource "aws_instance" "wowza" {
  ami             = "ami-04df41bee5e5c12a2"
  key_name        = "tfc-oregon"
  instance_type   = "c5.2xlarge"
  subnet_id       = aws_subnet.livestream-subnet-2a.id
  security_groups = [aws_security_group.livestream-wowza-server-sg.id]
  private_ip      = "10.0.4.100"
  tags = {
    Name = "Wowza-Streaming-Engine"
  }
}

# create cloud switcher security group

resource "aws_security_group" "livestream-switcher-server-sg" {
  name        = "livestream-switcher-server-sg"
  description = "allow switcher ports"
  vpc_id      = aws_vpc.livestream-vpc.id

  ingress {
    description = "ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "wowza"
    from_port   = 1935
    to_port     = 1935
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "rdp"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "rtsp"
    from_port   = 554
    to_port     = 554
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "ALL"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "livestream-switcher-server-sg"
  }
}

# launch cloud switcher

resource "aws_instance" "switcher" {
  ami             = "ami-00353d5edb960c71f"
  key_name        = "tfc-oregon"
  instance_type   = "c5.2xlarge"
  subnet_id       = aws_subnet.livestream-subnet-2a.id
  security_groups = [aws_security_group.livestream-switcher-server-sg.id]
  tags = {
    Name = "Cloud-Switcher"
  }
}

# create elastic ips and associate them to instances

resource "aws_eip" "switcher-eip" {
  instance = aws_instance.switcher.id
  vpc      = true
  tags = {
    Name = "switcher.thefatherscall.org"
  }
}

resource "aws_eip" "wowza-eip" {
  instance = aws_instance.wowza.id
  vpc      = true
  tags = {
    Name = "wowza.thefatherscall.org"
  }
}

# update dns records

resource "aws_route53_record" "wowza" {
  zone_id         = "Z16AGEC3IMI3R8"
  name            = "wowza.thefatherscall.org"
  type            = "A"
  ttl             = "60"
  allow_overwrite = true
  records         = [aws_eip.wowza-eip.public_ip]
}

resource "aws_route53_record" "switcher" {
  zone_id         = "Z16AGEC3IMI3R8"
  name            = "switcher.thefatherscall.org"
  type            = "A"
  ttl             = "60"
  allow_overwrite = true
  records         = [aws_eip.switcher-eip.public_ip]
}

resource "aws_route53_record" "web" {
  zone_id         = "Z16AGEC3IMI3R8"
  name            = "live.thefatherscall.org"
  type            = "A"
  allow_overwrite = true
  alias {
    name                   = aws_lb.livestream-web-lb.dns_name
    zone_id                = aws_lb.livestream-web-lb.zone_id
    evaluate_target_health = true
  }
}

output "wowza-ip-address" {
  value       = aws_route53_record.wowza.records
  description = "wowza ip address"
}

output "switcher-ip-address" {
  value       = aws_route53_record.switcher.records
  description = "switcher ip address"
}

output "elb-dns" {
  value       = aws_lb.livestream-web-lb.dns_name
  description = "elb dns name"
}
