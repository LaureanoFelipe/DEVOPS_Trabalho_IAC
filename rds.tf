# Criação de instância RDS (MySQL)
resource "aws_db_instance" "rds" {
  allocated_storage    = 20    
  storage_type         = "gp2" 
  engine               = "mysql"
  engine_version       = "8.0" 
  instance_class       = "db.t3.micro"  
  db_name              = "minha_base"   
  username             = "admin"         
  password             = "minhasenha123" 
  parameter_group_name = "default.mysql8.0" 

  tags = {
    Name = "MeuBancoRDS"
  }
}
