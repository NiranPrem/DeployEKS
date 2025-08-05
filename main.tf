provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "myterra1234"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "my-terraform-lock-table"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "terrabuck12345"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  region = "us-east-1"
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "route" {
  route_table_id = aws_route_table.routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gateway.id
}

resource "aws_route_table_association" "association" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.routetable.id
}

resource "aws_security_group" "security_group" {
  name = "newsecurity"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "varia" {
  description = "hlooo"
  type = string
  default = "t3.micro"
}

resource "aws_instance" "linux" {
  count = 2
  ami = "ami-08a6efd148b1f7504"
  instance_type = var.name
  key_name = "linux"
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.security_group.id]
  associate_public_ip_address = true
  availability_zone = "us-east-1b"
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras enable ansible2
    yum clean metadata
    yum install -y ansible
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user
    yum install nginx
    systemctl start nginx
    systemctl enable nginx
    EOF
  tags = {
    name = "Linux-${count.index}"
  }
}

resource "aws_iam_role" "name" {
  name = "niran"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policyattach" {
  role = aws_iam_role.name.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_s3_bucket" "buckets" {
  bucket = "newssssssbucket123455"
}

resource "aws_s3_object" "objectadd" {
  bucket = aws_s3_bucket.buckets.bucket
  source = "./main.txt"
  key = "hlo.txt"
}

resource "aws_instance" "manual" {
  ami = "ami-08a6efd148b1f7504"
  instance_type = "t3.micro"
  key_name = "linux"
  subnet_id = "subnet-0a98764a2f182b706"
  vpc_security_group_ids = ["sg-0dc4ab39e55432e76"]
  associate_public_ip_address = true
  availability_zone = "us-east-1a"
}

resource "aws_s3_bucket" "bucketsin" {
  for_each = {
    logs = "newbucjdkfnk"
    backup = "bhbfebfuebfb"
  }
  bucket = each.value
}

output "buckeach" {
  value = {
    for name, bucketsss in aws_s3_bucket.bucketsin :
    name => bucketsss.arn
  }
}

variable "name" {
  description = "hlooo"
  type = string
  default = "t3.micro"
}

# The variable "ec2password" has been removed

resource "aws_instance" "withpass" {
  ami = "ami-08a6efd148b1f7504"
  instance_type = "t3.micro"
  key_name = "linux"
  subnet_id = "subnet-0a98764a2f182b706"
  vpc_security_group_ids = ["sg-0dc4ab39e55432e76"]
  associate_public_ip_address = true
  availability_zone = "us-east-1a"
  user_data = <<-EOF
    #!/bin/bash
    useradd -m -s /bin/bash bro
    echo "bro:niranprem" | chpasswd
    usermod -aG wheel bro
    sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    systemctl restart sshd
    EOF
  tags = {
    Name = "EC2-With-Password"
  }
}

output "publicip" {
  value = aws_instance.withpass.public_ip
}
