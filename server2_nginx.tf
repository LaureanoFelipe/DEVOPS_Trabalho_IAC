# Grupo de segurança para permitir acesso SSH e HTTP
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Permite HTTP e SSH "

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Acesso SSH de qualquer lugar
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Acesso HTTP de qualquer lugar
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Permite saída
  }

  tags = {
    Name = "nginx-security-group"
  }
}

# Instância EC2 com NGINX
resource "aws_instance" "server2_nginx" {
  ami           = "ami-0453ec754f44f9a4a" # Amazon Linux 2023
  instance_type = "t2.micro" 
  key_name      = "trabalho"
  security_groups = [aws_security_group.nginx_sg.name]

  # Script de inicialização para instalar e configurar NGINX
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable nginx1
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Bem-vindo ao server2-nginx configurado com Terraform!</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "server2-nginx"
  }
}
