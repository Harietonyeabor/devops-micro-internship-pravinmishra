---
name: s3-intelligent-tiering-config
description: Implement S3 Intelligent-Tiering for portfolio static content
metadata:
  type: feedback
---

## S3 Intelligent-Tiering Setup

**Rule**: Add S3 Intelligent-Tiering to the portfolio bucket for automatic cost optimization.

**Why**: Portfolio content accessed primarily through CloudFront cache means S3 origin is hit infrequently. Intelligent-Tiering automatically transitions objects to cheaper tiers after 30 days of inactivity, saving 20-30% on storage costs ($2-10/month).

**How to apply**: Add this resource block to `terraform/main.tf` after the S3 bucket definition:

```hcl
resource "aws_s3_bucket_intelligent_tiering_configuration" "portfolio" {
  bucket = aws_s3_bucket.website.id
  name   = "AutoArchive"
  
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }
  
  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
}
```

This moves infrequently accessed objects to Archive (90 days) and Deep Archive (180 days), while keeping recent objects in Frequent tier.

**Trade-offs**: Negligible retrieval latency when CloudFront needs to re-fetch from origin after cache expiration. First access to archived objects takes 1-4 hours to transition back to Frequent tier.

**Data**: Based on portfolio-site project (portfolio-site-{account-id} bucket in ap-south-1 region).
