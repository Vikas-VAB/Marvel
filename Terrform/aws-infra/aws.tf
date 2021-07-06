provider "aws" {
   region = "us-east-2"
   access_key = ""
   secret_key = ""
}

resource "aws_iam_role" "test_role" {
  name = "role3"
  managed_policy_arns = [ "arn:aws:iam::aws:policy/AmazonS3FullAccess" ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "test_profile1" {
  name = "test_profile1"
  role = aws_iam_role.test_role.name
}

resource "aws_s3_bucket" "vab1bucket" {
  bucket = "vab1bucket"
  acl    = "public-read"

  tags = {
    Name        = "vab1bucket"
    Environment = "Dev"

  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.vab1bucket.id
  key    = "index.html"
  acl    = "public-read-write"
  source = "/root/terraform/Demo1/index.html"

}

resource "aws_instance" "terra1" {
 ami   = "ami-00399ec92321828f5"
 instance_type = "t2.micro"
 key_name = "Vikasaws1"
 iam_instance_profile = aws_iam_instance_profile.test_profile1.name
 security_groups = [ "webserver2" ]
 user_data = file("user_data.sh")

tags = {
    Name = "terra1"
  }
}
