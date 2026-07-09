---
name: project-terraform-baseline
description: Snapshot of terraform/ infra architecture and known security gaps as of 2026-07-08 audit
metadata:
  type: project
---

The `terraform/` directory (as of 2026-07-08) contains only 5 .tf files: `main.tf`, `variables.tf`, `providers.tf`, `outputs.tf`, `backend.tf`. It provisions a static portfolio site: one `aws_s3_bucket` (private, public access block enabled), a CloudFront distribution using OAC (not legacy OAI — good), and an S3 bucket policy scoped to the distribution via `AWS:SourceArn` condition (good least-privilege pattern already followed). There are **no IAM role/policy/OIDC resources anywhere in this repo** and no `.github/workflows/` files exist yet, so OIDC trust-policy scoping cannot be audited from this codebase — flag this as a gap/unknown rather than assuming it's fine.

Known baseline gaps found on first full audit (2026-07-08), none rated CRITICAL:
- No `aws_s3_bucket_server_side_encryption_configuration` (no encryption at rest) — HIGH
- No CloudFront `response_headers_policy` (missing CSP/X-Frame-Options/etc.) — HIGH
- `backend.tf` ships with S3 remote backend commented out (local state only, no locking) — HIGH, especially since project is meant to deploy via GitHub Actions per CLAUDE.md (local state doesn't persist across CI runs)
- No CloudTrail resource — MEDIUM
- No `aws_s3_bucket_versioning` — MEDIUM
- No S3 access logging (`aws_s3_bucket_logging`) — MEDIUM
- No CloudFront `logging_config` — MEDIUM
- No WAFv2 Web ACL attached to CloudFront — MEDIUM
- `variable "domain_name"` is declared in `variables.tf` but never referenced in `main.tf` (no `aliases`, no ACM cert, no `minimum_protocol_version`) — LOW, dead/incomplete config

**Why:** Recording this baseline lets future audits diff against what's already been reported instead of re-discovering the same gaps, and quickly tells us whether fixes were actually applied.

**How to apply:** On future audits of this repo, re-check this list first. If a gap has been fixed, remove it from this memory. If new .tf files appear (e.g. IAM/OIDC for GitHub Actions), audit those explicitly against OIDC repo/branch scoping and update this memory with what was found (see [[project-terraform-baseline]] — update in place, don't duplicate).
