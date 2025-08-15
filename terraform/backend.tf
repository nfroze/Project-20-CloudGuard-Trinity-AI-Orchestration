# terraform/backend.tf
terraform {
  backend "s3" {
    bucket = "project20-multi-cloud-ai-orchestration"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}