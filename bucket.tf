# Criação do bucket S3
resource "aws_s3_bucket" "bucket" {
  bucket = "bucket-trabalho-iac-25112024" 
  
  tags = {
    Name        = "Bucket"
  }
}
