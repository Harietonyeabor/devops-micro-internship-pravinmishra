# S3 Backend Configuration for Remote State
#
# IMPORTANT: First-time setup instructions:
# 1. Run `terraform init` WITHOUT uncommenting this backend
# 2. Deploy the infrastructure: `terraform apply`
# 3. Manually create an S3 bucket for Terraform state (or use Terraform to create it first)
# 4. Uncomment the backend configuration below
# 5. Run `terraform init -migrate-state` to migrate local state to S3
#
# Once the backend is in place, state will be stored in S3 and shared across your team.

# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
