# terraform/main.tf

# SSH Key Pair for all instances
resource "aws_key_pair" "demo_key" {
  key_name   = "cloudguard-demo-key"
  public_key = file("${path.module}/cloudguard-demo-key.pub")
}

# AWS EC2 Instance
resource "aws_instance" "cloudguard_instance" {
  ami           = "ami-0b4c7755cdf0d9219"  # Amazon Linux 2023 in eu-west-2
  instance_type = var.aws_instance_type
  key_name      = aws_key_pair.demo_key.key_name
  
  tags = {
    Name        = "${var.project_name}-aws"
    Environment = "Demo"
    Service     = "CloudGuard-Orchestration"
    Provider    = "AWS"
    Region      = var.aws_region
    ManagedBy   = "Terraform"
  }

  vpc_security_group_ids = [aws_security_group.cloudguard_sg.id]
  
  user_data = <<-EOF
    #!/bin/bash
    echo "CloudGuard Instance Initializing..."
  EOF
}

# AWS Security Group
resource "aws_security_group" "cloudguard_sg" {
  name_prefix = "${var.project_name}-"
  description = "Security group for CloudGuard orchestration platform"
  
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description = "Allow all outbound"
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
resource "azurerm_resource_group" "cloudguard" {
  name     = var.azure_resource_group
  location = var.azure_location
  
  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

# Azure Virtual Machine
resource "azurerm_linux_virtual_machine" "cloudguard_instance" {
  name                = "${var.project_name}-azure"
  resource_group_name = azurerm_resource_group.cloudguard.name
  location            = azurerm_resource_group.cloudguard.location
  size                = var.azure_vm_size
  
  admin_username = "azureuser"
  disable_password_authentication = true
  
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/cloudguard-demo-key.pub")
  }
  
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
  
  network_interface_ids = [azurerm_network_interface.cloudguard_nic.id]
  
  tags = {
    Service  = "CloudGuard-Orchestration"
    Provider = "Azure"
    Region   = var.azure_location
  }
}

# Azure Network Interface
resource "azurerm_network_interface" "cloudguard_nic" {
  name                = "${var.project_name}-nic"
  location            = azurerm_resource_group.cloudguard.location
  resource_group_name = azurerm_resource_group.cloudguard.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.cloudguard_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cloudguard_pip.id
  }
}

# Azure Public IP
resource "azurerm_public_ip" "cloudguard_pip" {
  name                = "${var.project_name}-pip"
  location            = azurerm_resource_group.cloudguard.location
  resource_group_name = azurerm_resource_group.cloudguard.name
  allocation_method   = "Static"
  sku                = "Standard"
}

# Azure Virtual Network
resource "azurerm_virtual_network" "cloudguard_vnet" {
  name                = "${var.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.cloudguard.location
  resource_group_name = azurerm_resource_group.cloudguard.name
}

# Azure Subnet
resource "azurerm_subnet" "cloudguard_subnet" {
  name                 = "${var.project_name}-subnet"
  resource_group_name  = azurerm_resource_group.cloudguard.name
  virtual_network_name = azurerm_virtual_network.cloudguard_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Azure Network Security Group
resource "azurerm_network_security_group" "cloudguard_nsg" {
  name                = "${var.project_name}-nsg"
  location            = azurerm_resource_group.cloudguard.location
  resource_group_name = azurerm_resource_group.cloudguard.name
  
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
resource "azurerm_network_interface_security_group_association" "cloudguard" {
  network_interface_id      = azurerm_network_interface.cloudguard_nic.id
  network_security_group_id = azurerm_network_security_group.cloudguard_nsg.id
}

# GCP Compute Instance
resource "google_compute_instance" "cloudguard_instance" {
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
  
  metadata_startup_script = "echo 'CloudGuard Instance Initializing...'"
  
  metadata = {
    ssh-keys = "debian:${file("${path.module}/cloudguard-demo-key.pub")}"
  }
  
  tags = ["http-server", "https-server"]
  
  labels = {
    service  = "cloudguard-orchestration"
    provider = "gcp"
    region   = var.gcp_region
  }
}

# GCP Firewall Rule for HTTP and SSH
resource "google_compute_firewall" "cloudguard_allow" {
  name    = "${var.project_name}-allow-http-ssh"
  network = "default"
  
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}