---
name: cloudfront-priceclass-optimization
description: Downgrade CloudFront from PriceClass_200 to PriceClass_100 for portfolio site
metadata:
  type: feedback
---

## CloudFront Price Class Optimization

**Rule**: Portfolio site should use `PriceClass_100` instead of `PriceClass_200`.

**Why**: PriceClass_200 (200+ edge locations globally) is overkill for a personal portfolio. PriceClass_100 (100+ core regions) provides adequate coverage for portfolio sites with predictable geographic distribution. Savings: 30-50% of CloudFront costs (~$40-150/month).

**How to apply**: Change line 60 in `terraform/main.tf` from `price_class = "PriceClass_200"` to `price_class = "PriceClass_100"`. This is a low-risk change with immediate cost reduction.

**Trade-offs**: Requests from remote/niche regions experience slightly higher latency, but PriceClass_100 still covers most of the world's major regions (North America, Europe, Asia Pacific, parts of South America).

**Implementation**: One-line change, no other modifications needed. Test with `terraform plan` before `terraform apply`.
