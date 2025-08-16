# terraform/outputs.tf

# AWS Outputs
output "aws_instance_id" {
  description = "AWS EC2 Instance ID"
  value       = aws_instance.cloudguard_instance.id
}

output "aws_public_ip" {
  description = "AWS EC2 Public IP"
  value       = aws_instance.cloudguard_instance.public_ip
}

output "aws_endpoint_url" {
  description = "AWS CloudGuard URL"
  value       = "http://${aws_instance.cloudguard_instance.public_ip}"
}

# Azure Outputs
output "azure_vm_id" {
  description = "Azure VM ID"
  value       = azurerm_linux_virtual_machine.cloudguard_instance.id
}

output "azure_public_ip" {
  description = "Azure VM Public IP"
  value       = azurerm_public_ip.cloudguard_pip.ip_address
}

output "azure_endpoint_url" {
  description = "Azure CloudGuard URL"
  value       = "http://${azurerm_public_ip.cloudguard_pip.ip_address}"
}

# GCP Outputs
output "gcp_instance_id" {
  description = "GCP Instance ID"
  value       = google_compute_instance.cloudguard_instance.id
}

output "gcp_public_ip" {
  description = "GCP Instance Public IP"
  value       = google_compute_instance.cloudguard_instance.network_interface[0].access_config[0].nat_ip
}

output "gcp_endpoint_url" {
  description = "GCP CloudGuard URL"
  value       = "http://${google_compute_instance.cloudguard_instance.network_interface[0].access_config[0].nat_ip}"
}

# Summary Output
output "all_endpoints" {
  description = "All CloudGuard Endpoints"
  value = {
    aws   = "http://${aws_instance.cloudguard_instance.public_ip}"
    azure = "http://${azurerm_public_ip.cloudguard_pip.ip_address}"
    gcp   = "http://${google_compute_instance.cloudguard_instance.network_interface[0].access_config[0].nat_ip}"
  }
}

output "ansible_inventory" {
  description = "Ansible inventory format"
  value = <<-EOT
[cloudguard_instances]
aws-instance ansible_host=${aws_instance.cloudguard_instance.public_ip} cloud_provider=AWS
azure-instance ansible_host=${azurerm_public_ip.cloudguard_pip.ip_address} cloud_provider=Azure
gcp-instance ansible_host=${google_compute_instance.cloudguard_instance.network_interface[0].access_config[0].nat_ip} cloud_provider=GCP
EOT
}