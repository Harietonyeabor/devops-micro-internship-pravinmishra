---
name: cloudfront-cache-ttl-optimization
description: Increase CloudFront cache TTL for static portfolio content
metadata:
  type: feedback
---

## CloudFront Cache TTL Optimization

**Rule**: Portfolio site should use higher TTLs on CloudFront cache for static content.

**Why**: Static portfolio content rarely changes. Higher TTLs = more cache hits at edge locations = fewer requests to S3 origin. Estimated savings: 10-30% reduction in origin requests ($20-60/month).

**How to apply**: Create a custom cache policy or modify the default behavior in `terraform/main.tf`:

Option 1 (Recommended): Create custom cache policy:
```hcl
resource "aws_cloudfront_cache_policy" "portfolio_cache" {
  name = "portfolio-cache-policy"
  
  default_ttl = 86400   # 24 hours for index.html
  max_ttl     = 31536000 # 1 year for static assets
  min_ttl     = 0
  
  parameters_in_cache_key_and_forwarded_to_origin {
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    cookies_config {
      cookie_behavior = "none"
    }
  }
}
```

Then update the distribution to use this policy (line 75).

Option 2 (Quick): Increase error cache TTL from 300 to 3600 seconds in the custom_error_response block (line 83).

**Trade-offs**: Content updates take longer to propagate globally (up to 24 hours). Mitigation: Use CloudFront cache invalidation when deploying updates.

**Current state**: Using `Managed-CachingOptimized` with default AWS TTLs. Custom policy allows fine-grained control.
