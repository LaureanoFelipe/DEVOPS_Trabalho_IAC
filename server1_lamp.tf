# Grupo de segurança para permitir tráfego HTTP, HTTPS e SSH
resource "aws_security_group" "lamp_sg" {
  name        = "lamp-sg"
  description = "Permite HTTP, HTTPS e SSH"

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
    cidr_blocks = ["0.0.0.0/0"] # HTTP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTPS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lamp-security-group"
  }
}

# Instância EC2 com LAMP
resource "aws_instance" "lamp_server" {
  ami           = "ami-0453ec754f44f9a4a" # Amazon Linux 2023
  instance_type = "t2.micro"
  key_name      = "trabalho"
  security_groups = [aws_security_group.lamp_sg.name]

  # Script de inicialização para configurar LAMP
  user_data = <<-EOF
              #!/bin/bash
              # Atualizando pacotes
              yum update -y

              # Instalando Apache
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd

              # Configurando página inicial do Apache
              echo "<h1>Servidor LAMP com Terraform!</h1>" > /var/www/html/index.html

              # Instalando MariaDB (MySQL)
              amazon-linux-extras enable mariadb10.5
              yum install -y mariadb-server
              systemctl start mariadb
              systemctl enable mariadb

              # Criando banco de dados
              mysql -e "CREATE DATABASE lamp_db;"
              mysql -e "CREATE USER 'lamp_user'@'%' IDENTIFIED BY 'password123';"
              mysql -e "GRANT ALL PRIVILEGES ON lamp_db.* TO 'lamp_user'@'%';"
              mysql -e "FLUSH PRIVILEGES;"

              # Instalando PHP
              amazon-linux-extras enable php8.0
              yum install -y php php-mysqlnd

              # Configurando página PHP
              echo "<?php phpinfo(); ?>" > /var/www/html/info.php

              # Reiniciando Apache
              systemctl restart httpd
              EOF

  tags = {
    Name = "lamp-server"
  }
}
