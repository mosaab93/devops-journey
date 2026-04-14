terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# أول resource — S3 bucket مجاني 100%
resource "aws_s3_bucket" "my_bucket" {
  bucket = "mosaab-devops-journey-2026"

  tags = {
    Name        = "DevOps Journey"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}
