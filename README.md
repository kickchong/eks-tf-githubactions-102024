# #EKS / TF / Githubactions

Use github action deploy EKS

This project will cover the followings requirement. 

Task:
Create a project that deploys a basic EKS cluster and a sample application, with a focus on networking. We recommend using AWS CDK, but you may use Terraform if you're more comfortable with it.

Requirements:

1. Use AWS CDK (recommended) or Terraform to define the infrastructure.

2. Create an EKS cluster with at least one node group that can auto-scale.

3. Set up a VPC with public and private subnets across two availability zones. The EKS cluster should be deployed in the private subnets.

5. Implement basic security measures (e.g., use of IAM roles, security groups, network ACLs).

7. Include a GitHub Actions workflow or GitLab CI/CD pipeline to deploy the infrastructure and application.

Actions:

Use Terraform / Github Action to complete the task

1. provider.tf: Define provider info and define TF state files s3 location.
2. vpc.tf: Establish Network(VPC/Subnet/Internet Gateway/NAT) for the project.
3. eks.tf: Establish EKS cluster.
4. deploy.yml/cleanup.yml: Github action CI/CD for deployment and cleanup.
