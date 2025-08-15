# terraform/main.tf

# AWS EC2 Instance
resource "aws_instance" "ai_endpoint" {
  ami           = "ami-0b4c7755cdf0d9219"  # Amazon Linux 2023 in eu-west-2
  instance_type = var.aws_instance_type
  
  tags = {
    Name        = "${var.project_name}-aws"
    Environment = "Demo"
    Service     = "AI-Inference-Endpoint"
    Model       = "BERT-Large"
    Provider    = "AWS-SageMaker-Compatible"
    GPU         = "T4-In-Production"
    ManagedBy   = "Terraform"
  }

  # Allow HTTP traffic
  vpc_security_group_ids = [aws_security_group.ai_endpoint.id]
  
  user_data = <<-EOF
    #!/bin/bash
    echo "AI Endpoint Initializing..."
  EOF
}

# AWS Security Group
resource "aws_security_group" "ai_endpoint" {
  name_prefix = "${var.project_name}-"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-sg"
  }
}

# Azure Resource Group
resource "azurerm_resource_group" "ai_platform" {
  name     = var.azure_resource_group
  location = var.azure_location
  
  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

# Azure Virtual Machine
resource "azurerm_linux_virtual_machine" "ai_endpoint" {
  name                = "${var.project_name}-azure"
  resource_group_name = azurerm_resource_group.ai_platform.name
  location            = azurerm_resource_group.ai_platform.location
  size                = var.azure_vm_size
  
  admin_username = "azureuser"
  admin_password = "CloudGuard123!@#"
  disable_password_authentication = false
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  
  network_interface_ids = [azurerm_network_interface.ai_endpoint.id]
  
  tags = {
    Service  = "AI-Inference-Endpoint"
    Model    = "GPT-2-Medium"
    Provider = "Azure-ML-Compatible"
    GPU      = "K80-In-Production"
  }
}

# Azure Network Interface
resource "azurerm_network_interface" "ai_endpoint" {
  name                = "${var.project_name}-nic"
  location            = azurerm_resource_group.ai_platform.location
  resource_group_name = azurerm_resource_group.ai_platform.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ai_platform.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ai_endpoint.id
  }
}

# Azure Public IP
resource "azurerm_public_ip" "ai_endpoint" {
  name                = "${var.project_name}-pip"
  location            = azurerm_resource_group.ai_platform.location
  resource_group_name = azurerm_resource_group.ai_platform.name
  allocation_method   = "Static"
  sku                = "Standard"
}

# Azure Virtual Network
resource "azurerm_virtual_network" "ai_platform" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ai_platform.location
  resource_group_name = azurerm_resource_group.ai_platform.name
}

# Azure Subnet
resource "azurerm_subnet" "ai_platform" {
  name                 = "${var.project_name}-subnet"
  resource_group_name  = azurerm_resource_group.ai_platform.name
  virtual_network_name = azurerm_virtual_network.ai_platform.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Azure Network Security Group
resource "azurerm_network_security_group" "ai_endpoint" {
  name                = "${var.project_name}-nsg"
  location            = azurerm_resource_group.ai_platform.location
  resource_group_name = azurerm_resource_group.ai_platform.name
  
  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "ai_endpoint" {
  network_interface_id      = azurerm_network_interface.ai_endpoint.id
  network_security_group_id = azurerm_network_security_group.ai_endpoint.id
}

# GCP Compute Instance
resource "google_compute_instance" "ai_endpoint" {
  name         = "${var.project_name}-gcp"
  machine_type = var.gcp_machine_type
  zone         = var.gcp_zone
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  
  network_interface {
    network = "default"
    
    access_config {
      # Ephemeral public IP
    }
  }
  
  metadata_startup_script = "echo 'AI Endpoint Initializing...'"
  
  tags = ["http-server", "https-server"]
  
  labels = {
    service  = "ai-inference-endpoint"
    model    = "llama-2-7b"
    provider = "vertex-ai-compatible"
    gpu      = "t4-in-production"
  }
}

# GCP Firewall Rule for HTTP
resource "google_compute_firewall" "ai_endpoint_http" {
  name    = "${var.project_name}-allow-http"
  network = "default"
  
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}