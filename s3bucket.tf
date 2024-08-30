
resource "aws_s3_bucket" "user5bucket" {
    bucket = var.ec2bucket

    tags = {
        Name = "user5-s3-bucket"
    }
  
}



resource "aws_s3_bucket_object" "user5-folder" {
   bucket = var.ec2bucket.id
   key    = "user5-folder"
    }

output "ec2buckettagout" {
  value = aws_s3_bucket.petstorebucket.tags
}