data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# 🔐 Security Group
resource "aws_security_group" "app_sg" {
  name = "app-sg"

  ingress {
    description = "Allow app traffic"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH (restrict in real use)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # 👉 Replace with your IP for better security
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-app-sg"
  }
}

# 🔑 Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "devops-key"
  public_key = trimspace(file(var.public_key_path))
}


# 💻 EC2 Instance
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  iam_instance_profile = var.instance_profile

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  key_name = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              EOF

  tags = {
    Name = "Devops-Flask-App"
    Env  = "dev"
  }
}
