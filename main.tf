# resource "aws_s3_bucket" "bucket" {
#     bucket = "rishika2801"


# }
# resource "aws_s3_object" "file"{
#     bucket = aws_s3_bucket.bucket.id
#     key    = "s3.txt"
#     source = "s3.txt"
# }
# resource "aws_s3_object" "index" {
#     bucket = aws_s3_bucket.bucket.id
#     key    = "index.html"
#     source = "index.html"
# }
# data "aws_s3_bucket" "bucket2801" {
#     bucket = "rishika2801"
# }
# resource "aws_s3_object" "file" {
#     bucket = data.aws_s3_bucket.bucket2801.id
#     key    = "s3.txt"
#     source = "s3.txt"
# }
# resource "aws_instance" "name" {
#   ami           = var.ami_id
#   instance_type = var.instance_type

#   key_name = var.key_name
#   tags = {
#     Name = "Rishi"
#   }
# }
# output "vijaya_instance_id" {
#   value = aws_instance.name.id
# }
# output "vijaya_public_ip"{
#   value=aws_instance.name.public_ip
# }
# =========================
# EC2 INSTANCE
# =========================

resource "aws_instance" "name" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "Vijaya-EC2"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Vijaya-VPC"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Vijaya-Subnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Vijaya-IGW"
  }
}

resource "aws_route_table" "my_route" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "Vijaya-RouteTable"
  }
}

resource "aws_route_table_association" "my_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route.id
}

resource "aws_security_group" "my_sg" {
  name   = "Vijaya-SecurityGroup"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description = "SSH"
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
    Name = "Vijaya-SG"
  }
}

resource "aws_iam_user" "vijaya_user" {
  name = "VijayaTerraformUser"

  tags = {
    Name = "VijayaTerraformUser"
  }
}

resource "aws_iam_user_policy_attachment" "admin_access" {
  user       = aws_iam_user.vijaya_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "vijaya_instance_id" {
  value = aws_instance.name.id
}

output "vijaya_public_ip" {
  value = aws_instance.name.public_ip
}

output "iam_user_name" {
  value = aws_iam_user.vijaya_user.name
}