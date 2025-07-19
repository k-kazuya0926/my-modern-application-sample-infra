# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the infrastructure as code repository for a modern serverless application using Terraform on AWS. The infrastructure supports a microservices architecture with event-driven communication patterns.

## Common Commands

### Terraform Operations
```bash
# Navigate to environment directory
cd environments/prod

# Initialize Terraform with backend configuration
terraform init -backend-config=backend.hcl

# Plan infrastructure changes
terraform plan

# Apply infrastructure changes
terraform apply

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Show current state
terraform show

# Import existing resources
terraform import <resource_type>.<resource_name> <resource_id>
```

### Backend Configuration
- Copy `environments/backend.hcl.example` to `environments/prod/backend.hcl`
- Configure S3 bucket name and region for state storage
- State files are stored in S3 with DynamoDB locking enabled

## Architecture

### Module Structure
- **environments/**: Environment-specific configurations (currently `prod`)
- **modules/**: Reusable Terraform modules for AWS services
- **environments/prod/data_stores/**: Separate state management for data layer

### Key AWS Services
- **Lambda**: Container-based functions with individual IAM roles
- **API Gateway**: HTTP API with Cognito integration for authentication
- **Step Functions**: Workflow orchestration with X-Ray tracing
- **DynamoDB**: NoSQL database with separate state management
- **S3**: Multiple buckets for different purposes (read, write, contents, mail)
- **SQS/SNS**: Message queuing and fan-out patterns
- **ECR**: Container registry for Lambda functions
- **Cognito**: User authentication and authorization
- **AppConfig**: Feature flag management
- **SES**: Email service with bounce handling

### Lambda Architecture Pattern
Each Lambda function:
- Has its own IAM execution role with least privilege permissions
- Uses container images from ECR (not ZIP files)
- Has dedicated CloudWatch log groups
- Supports custom policy statements via `policy_statements` variable
- Can have S3 or SQS triggers configured
- Optionally enables X-Ray tracing

### Security Patterns
- Individual IAM roles per Lambda function (not shared roles)
- Least privilege principle with specific policy statements
- GitHub Actions OIDC integration for secure CI/CD
- Environment variable injection for configuration

### State Management
- Main infrastructure in `environments/prod/`
- DynamoDB tables managed separately in `environments/prod/data_stores/`
- Remote state references between layers using `terraform_remote_state`

## Development Workflow

### Adding New Lambda Functions
1. Create ECR repository in `ecr.tf`
2. Add Lambda module in `lambda.tf` with required configurations:
   - `function_name`: Unique identifier
   - `image_uri`: ECR repository URL
   - `policy_statements`: Required IAM permissions
   - `environment_variables`: Runtime configuration
   - Optional triggers: `s3_trigger_*` or `sqs_trigger_*`

### Module Development
- All modules follow standard structure: `main.tf`, `variables.tf`, `outputs.tf`
- Use data sources for current AWS account/region information
- Implement dynamic policy statements for flexible IAM permissions
- Support conditional resource creation with `count` parameter

### Terraform Versions
- Terraform: 1.12.2
- AWS Provider: 6.0.0
- Backend: S3 with state locking via DynamoDB

## File Organization

### Environment Structure
```
environments/prod/
├── data_stores/dynamodb/    # Separate state for DynamoDB
├── backend.hcl             # Backend configuration
├── terraform.tfvars        # Environment variables
├── *.tf                    # Service configurations
```

### Module Structure
```
modules/<service>/
├── main.tf                 # Resource definitions
├── variables.tf            # Input variables
├── outputs.tf              # Output values
```

## Key Conventions

- Resource naming: `${var.github_repository_name}-${var.env}-${specific_name}`
- All Lambda functions use container packaging
- IAM policies use dynamic statements for flexibility
- Log retention periods are configurable
- X-Ray tracing is optional per function
- Environment variables passed via Terraform