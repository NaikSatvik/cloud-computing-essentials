terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.13.5"
}

provider "aws" {
  region     = "us-east-1"
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOUR_SECRET_KEY"
}

variable "bucket_name" {
  default = "e4-demo-bucket"
}

resource "aws_s3_bucket" "buck" {
  bucket = var.bucket_name
  acl    = "public-read"

  policy = <<EOF
  {
      "Id": "bucket_policy_site",
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "bucket_policy_site_main",
              "Action": [
                  "s3:PutObject",
                  "s3:PutObjectAcl"
              ],
              "Effect": "Allow",
              "Resource": "arn:aws:s3:::${var.bucket_name}/*",
              "Principal": "*"
          }
      ]
  }
  EOF

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "index_ob" {
  bucket       = aws_s3_bucket.buck.bucket
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error_ob" {
  bucket       = aws_s3_bucket.buck.bucket
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_lifecycle_configuration" "buck-lifecycle-config" {
  bucket = aws_s3_bucket.buck.id
  rule {
    id = "rule-1"
    expiration {
      days = 1
    }
    status = "Enabled"
  }
}

output "website_domain" {
  value = aws_s3_bucket.buck.website_domain
}

output "website_endpoint" {
  value = aws_s3_bucket.buck.website_endpoint
}
