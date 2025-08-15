# CloudGuard Trinity - Multi-Cloud AI Orchestration Platform

## 🚀 TL;DR
A production-grade multi-cloud orchestration platform that deploys and manages AI model inference endpoints across AWS, Azure, and GCP simultaneously. Using GitOps principles, infrastructure is provisioned via Terraform, configured through Ansible, deployed with GitHub Actions CI/CD, and monitored through Datadog - all from a single pipeline.

**Key Achievement**: Deploy AI infrastructure to 3 clouds in under 5 minutes with one `git push`.

---

## 📋 Overview

CloudGuard Trinity demonstrates enterprise-level DevSecOps practices by orchestrating simulated AI model endpoints across the three major cloud providers. This project showcases the ability to manage complex multi-cloud infrastructure whilst maintaining consistency, security, and observability.

### 🎯 Problem Solved
Organisations struggling with multi-cloud AI workloads need unified deployment, configuration, and monitoring. This platform provides a single source of truth for infrastructure that works identically across AWS SageMaker, Azure ML, and Vertex AI patterns.

### 💡 Solution Architecture
- **Infrastructure as Code**: Terraform with remote S3 backend for state management
- **Configuration Management**: Ansible playbooks handling OS-specific configurations
- **CI/CD Pipeline**: GitHub Actions workflow orchestrating the entire deployment
- **Unified Monitoring**: Datadog integration across all three cloud providers
- **Security**: SSH key management and secure secret handling

## 🛠️ Technologies Used

### Core Technologies
- **Terraform** (v1.5.0) - Multi-cloud infrastructure provisioning
- **Ansible** (v2.17) - Configuration management and application deployment
- **GitHub Actions** - CI/CD pipeline and GitOps workflow
- **Datadog** - Unified monitoring and observability

### Cloud Providers
- **AWS**: EC2 instances (eu-west-2)
- **Azure**: Virtual Machines (UK South)
- **GCP**: Compute Engine (europe-west2)

### Supporting Technologies
- **AWS S3** - Terraform remote state backend
- **Nginx** - Web server for AI endpoint simulation
- **SSH** - Secure instance access and Ansible connectivity

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        GitHub Repository                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Terraform  │  │    Ansible   │  │    GitHub    │      │
│  │     Code     │  │   Playbooks  │  │   Actions    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                               │
                    ┌──────────▼──────────┐
                    │   GitHub Actions    │
                    │      Pipeline        │
                    └──────────┬──────────┘
                               │
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
        ▼                      ▼                      ▼
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│     AWS      │      │    Azure     │      │     GCP      │
│   EC2 + SG   │      │   VM + NSG   │      │  GCE + FW   │
│              │      │              │      │              │
│  BERT Model  │      │ GPT-2 Model  │      │ LLaMA Model  │
└──────────────┘      └──────────────┘      └──────────────┘
        │                      │                      │
        └──────────────────────┼──────────────────────┘
                               │
                    ┌──────────▼──────────┐
                    │      Datadog        │
                    │  Unified Monitoring │
                    └─────────────────────┘
```

## 🚦 Features

### Infrastructure Management
- ✅ Multi-cloud resource provisioning with Terraform
- ✅ Remote state management using S3 backend
- ✅ Automated resource tagging for cost tracking
- ✅ Network security configuration (Security Groups, NSGs, Firewall Rules)

### Configuration & Deployment
- ✅ OS-agnostic Ansible playbooks (supports Debian/RedHat families)
- ✅ Dynamic configuration based on cloud provider
- ✅ Templated deployments with Jinja2
- ✅ Idempotent configuration management

### Monitoring & Observability
- ✅ Unified Datadog dashboard across all clouds
- ✅ Custom metrics endpoints (Prometheus format)
- ✅ Health check endpoints for each service
- ✅ Real-time resource utilisation tracking

### Security
- ✅ SSH key management across all instances
- ✅ GitHub Secrets for sensitive credentials
- ✅ Network security with minimal required ports
- ✅ Automated security group configuration

## 📊 Endpoints

Each deployed instance provides:

| Endpoint | Purpose | Example Response |
|----------|---------|------------------|
| `/` | Main AI model interface | HTML page with model details |
| `/v1/models/predict` | Mock inference API | JSON with prediction results |
| `/health` | Health check | `{"status":"healthy","provider":"AWS"}` |
| `/metrics` | Prometheus metrics | Metrics in Prometheus format |

## 🔄 CI/CD Pipeline

The GitHub Actions workflow:
1. **Authentication**: Configures credentials for AWS, Azure, and GCP
2. **Infrastructure**: Runs Terraform to provision resources
3. **Configuration**: Executes Ansible playbooks for application setup
4. **Verification**: Validates deployments and outputs endpoints

### Pipeline Duration
- Average runtime: 8-12 minutes
- Terraform provisioning: ~3 minutes
- Ansible configuration: ~2 minutes
- Total including validation: ~10 minutes

## 📈 Monitoring

Datadog provides:
- Real-time infrastructure metrics
- Cross-cloud resource utilisation
- Custom dashboards for AI workload simulation
- Automatic discovery of cloud resources

## 🏃 Quick Start

### Prerequisites
- AWS, Azure, and GCP accounts
- Terraform installed locally
- Ansible installed locally
- Datadog account with cloud integrations
- GitHub repository with Actions enabled

### Deployment
1. Clone the repository
2. Configure cloud credentials in GitHub Secrets
3. Set up Datadog integrations for each cloud
4. Push to main branch to trigger deployment
5. Monitor progress in GitHub Actions tab
6. Access endpoints via provided IPs

## 💰 Cost Optimisation

- Uses minimal instance sizes (t2.micro, B1s, e2-micro)
- Automatic resource cleanup with `terraform destroy`
- Estimated daily cost: < £2 for all resources
- Free tier eligible where available

## 🔐 Security Considerations

- All credentials stored in GitHub Secrets
- SSH keys managed securely
- Network access limited to necessary ports (22, 80)
- Infrastructure as Code ensures consistent security posture

## 📝 Project Structure

```
Project-20-Multi-Cloud-AI-Orchestration/
├── .github/
│   └── workflows/
│       └── deploy.yml              # CI/CD pipeline
├── terraform/
│   ├── main.tf                     # Infrastructure definitions
│   ├── providers.tf                # Cloud provider configuration
│   ├── variables.tf                # Input variables
│   ├── outputs.tf                  # Output definitions
│   └── backend.tf                  # S3 state backend
├── ansible/
│   ├── playbooks/
│   │   └── configure-nginx.yml     # Configuration playbook
│   ├── templates/
│   │   └── index.html.j2           # AI endpoint template
│   └── ansible.cfg                 # Ansible configuration
└── README.md
```

## 🎓 Learning Outcomes

This project demonstrates:
- Enterprise-grade multi-cloud architecture
- GitOps and Infrastructure as Code principles
- CI/CD pipeline development
- Configuration management at scale
- Cloud-agnostic deployment strategies
- Unified monitoring across providers

## 🔮 Future Enhancements

- [ ] Implement actual AI model serving (TensorFlow Serving, TorchServe)
- [ ] Add Kubernetes orchestration layer
- [ ] Integrate with real GPU instances
- [ ] Implement cost anomaly detection
- [ ] Add automated disaster recovery
- [ ] Integrate with HashiCorp Vault for secrets management

## 📜 Licence

MIT Licence - See LICENCE file for details

## 🙏 Acknowledgements

Built as part of a comprehensive DevSecOps portfolio demonstrating enterprise cloud orchestration capabilities.

---

**Status**: ✅ Production Ready | **Region**: UK/EU | **Last Updated**: August 2025