resource "aws_s3_bucket" "certifies_bucket" {
  bucket = "certifies-${var.envinronment}"

  tags = {
    Name        = "certifies-${var.envinronment}"
    Environment = var.envinronment
  }
}