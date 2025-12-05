
# Terraform Deployment of Node.js App on AWS Elastic Beanstalk

## Prerequisites
- AWS account with permissions for **EC2, Elastic Beanstalk, VPC, IAM, and S3**
- **One S3 bucket for Terraform backend state** (already created)
- **One S3 bucket containing the application ZIP files**  
  Example:  
  - `s3://wu-nodejs-s3/v3.zip`  
  - `s3://wu-nodejs-s3/v4.zip`
- Existing IAM roles for Elastic Beanstalk:  
  - **Service role**  
  - **EC2 Instance Profile**
- Existing **EC2 key pair** (e.g., `wu-key`)
- Terraform installed locally

---

## Objective
This project deploys a **versioned Node.js application** to **AWS Elastic Beanstalk** using Terraform.  
It provisions:

- A VPC with **two public subnets** (one per AZ)
- **Internet Gateway** and **public route table**
- **Security groups** for ALB and EC2 instances
- Elastic Beanstalk:
  - Application
  - Application Version (stored in S3)
  - Load-balanced Web Server Environment (Amazon Linux 2023, Node.js 24)

Terraform handles the entire infrastructure and deployment workflow end-to-end.

---

## Architecture Diagram
![Diagram](architecture.png)

---

## Terraform Project Structure

```
project-root/
  ├── backend.tf
  ├── main.tf
  ├── variables.tf
  ├── terraform.tfvars
  ├── modules/
  │     ├── vpc/
  │     │     ├── main.tf
  │     │     ├── variables.tf
  │     │     └── outputs.tf
  │     ├── security/
  │     │     ├── main.tf
  │     │     ├── variables.tf
  │     │     └── outputs.tf
  │     └── beanstalk/
  │           ├── main.tf
  │           ├── variables.tf
  │           └── outputs.tf
```

---

## Deployment Process

### 1. Configure terraform.tfvars
Define values for:
- `vpc_cidr`
- `public_subnets`
- `region`
- `service_role_arn`
- `instance_profile`
- `keypair`
- `s3_bucket`
- `s3_key` (initially `v3.zip`)

### 2. Initialize Terraform
```
terraform init
```

### 3. Validate the configuration
```
terraform validate
```

### 4. Review planned resources
```
terraform plan
```

### 5. Deploy the infrastructure + application
```
terraform apply
```
Type **yes** when prompted.

Terraform will output the **Elastic Beanstalk environment URL**.

---

## Updating the Application Version

To redeploy using a new ZIP file (e.g., **v4.zip**):

1. Update the value:
   ```
   s3_key = "v4.zip"
   ```
2. Run:
   ```
   terraform plan
   terraform apply
   ```

Elastic Beanstalk automatically deploys the updated version.

---

This completes the fully automated Node.js deployment using **Terraform + Elastic Beanstalk**.
````
