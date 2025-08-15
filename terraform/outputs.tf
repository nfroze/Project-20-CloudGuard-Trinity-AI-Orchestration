# terraform/outputs.tf

# AWS Outputs
output "aws_instance_id" {
  description = "AWS EC2 Instance ID"
  value       = aws_instance.ai_endpoint.id
}

output "aws_public_ip" {
  description = "AWS EC2 Public IP"
  value       = aws_instance.ai_endpoint.public_ip
}

output "aws_endpoint_url" {
  description = "AWS AI Endpoint URL"
  value       = "http://${aws_instance.ai_endpoint.public_ip}"
}

# Azure Outputs
output "azure_vm_id" {
  description = "Azure VM ID"
  value       = azurerm_linux_virtual_machine.ai_endpoint.id
}

output "azure_public_ip" {
  description = "Azure VM Public IP"
  value       = azurerm_public_ip.ai_endpoint.ip_address
}

output "azure_endpoint_url" {
  description = "Azure AI Endpoint URL"
  value       = "http://${azurerm_public_ip.ai_endpoint.ip_address}"
}

# GCP Outputs
output "gcp_instance_id" {
  description = "GCP Instance ID"
  value       = google_compute_instance.ai_endpoint.id
}

output "gcp_public_ip" {
  description = "GCP Instance Public IP"
  value       = google_compute_instance.ai_endpoint.network_interface[0].access_config[0].nat_ip
}

output "gcp_endpoint_url" {
  description = "GCP AI Endpoint URL"
  value       = "http://${google_compute_instance.ai_endpoint.network_interface[0].access_config[0].nat_ip}"
}

# Summary Output
output "all_endpoints" {
  description = "All AI Model Endpoints"
  value = {
    aws   = "http://${aws_instance.ai_endpoint.public_ip}"
    azure = "http://${azurerm_public_ip.ai_endpoint.ip_address}"
    gcp   = "http://${google_compute_instance.ai_endpoint.network_interface[0].access_config[0].nat_ip}"
  }
}

output "ansible_inventory" {
  description = "Ansible inventory format"
  value = <<-EOT
[ai_endpoints]
aws-endpoint ansible_host=${aws_instance.ai_endpoint.public_ip} cloud_provider=AWS
azure-endpoint ansible_host=${azurerm_public_ip.ai_endpoint.ip_address} cloud_provider=Azure
gcp-endpoint ansible_host=${google_compute_instance.ai_endpoint.network_interface[0].access_config[0].nat_ip} cloud_provider=GCP
EOT
}