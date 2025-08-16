# terraform/variables.tf

# AWS Variables
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-west-2"  # London
}

variable "aws_instance_type" {
  description = "Instance type for AWS EC2"
  type        = string
  default     = "t2.micro"
}

# Azure Variables
variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "azure_resource_group" {
  description = "Azure Resource Group name"
  type        = string
  default     = "cloudguard-rg"
}

variable "azure_location" {
  description = "Azure region for resources"
  type        = string
  default     = "UK South"  # London
}

variable "azure_vm_size" {
  description = "Size for Azure VM"
  type        = string
  default     = "Standard_B1s"
}

# GCP Variables
variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region for resources"
  type        = string
  default     = "europe-west2"  # London
}

variable "gcp_zone" {
  description = "GCP zone for resources"
  type        = string
  default     = "europe-west2-a"
}

variable "gcp_machine_type" {
  description = "Machine type for GCP instance"
  type        = string
  default     = "e2-micro"
}

# Common Variables
variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "cloudguard-orchestration"
}