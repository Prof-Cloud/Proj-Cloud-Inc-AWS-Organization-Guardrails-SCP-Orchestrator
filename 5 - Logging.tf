# Security Audits.
# Creates a hardened S# bucket for all organization logs with lifecycle rules

resource "aws_s3_bucket" "audit_logs" {
  bucket = "prof-cloud-inc-central-audit-logs" # Must be globally unique

  # Force the bucket to be private 
  lifecycle {
    prevent_destroy = false
  }

  #Allow terraform to delete the bucket even if files exist in the bucket
  # Good for the lab; set to false for production.
  force_destroy = true

  tags = {
    Environment = "Security"
    ManagedBy   = "Terraform"
  }
}

# Block all public access. 
resource "aws_s3_bucket_public_access_block" "audit_logs_block" {
  bucket = aws_s3_bucket.audit_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#Enabling versioning
resource "aws_s3_bucket_versioning" "S3Robot_versioning" {
  bucket = aws_s3_bucket.audit_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

#Lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "S3Robot-lifecycle" {
  bucket = aws_s3_bucket.audit_logs.id

  rule {
    id = "Lifecycle rules"

    expiration {
      days = 90
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}
