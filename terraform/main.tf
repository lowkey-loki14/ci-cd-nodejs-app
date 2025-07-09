provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "node_app" {
  ami           = "ami-0c02fb55956c7d316"  # Ubuntu 22.04 (verify latest in region)
  instance_type = "t2.micro"
  key_name      = ecommerce-key

  user_data = file("user_data.sh")

  tags = {
    Name = "NodeAppServer"
  }

  vpc_security_group_ids = [aws_security_group.allow_http.id]
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
