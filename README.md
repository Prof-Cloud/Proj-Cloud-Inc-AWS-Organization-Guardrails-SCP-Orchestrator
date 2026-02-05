# Proj Cloud Inc: AWS Organization Guardrails, SCP Orchestrator

In this project, I built a professional-grade AWS organization for Proj Cloud Inc using Terraform. Instead of managing dozens of accounts and security settings manually, I used Infrastructure as Code (Iac) to automate a Hub-and-Spoke governance model. This ensures that every department, DevOps, Finance, Security, and Admin, operates within pre-defined safety rails from day one. 

## What I Built

Organizational Structure 

  - Automated OUs: Created distinct Organizational Units to isolate workloads


 Regional & Financial Guardrails (SCPs)

   - Regional Lockdown: A Service Control Policy (SCP) that hard restricts activity to us-east-1 and ca-central-1, preventing unauthorized global resource sprawl
   - Cost Protection: Implements a "Wallet Guard" that denies the launch of high-cost GPUs and memory-intensive instances, keeping the cloud budget predictable


Identify & Network Perimeter

  - Permission Boundaries: Ensuring that Admin Users can't delete audit trails or stop security logging
  - Network Lockdown: Prevents the creation of unauthorized Internet Gateway


Data Sovereignty & Archiving

  - Centralized Logging: A hardened S3 bucket containing all organization-wide activity
  - Lifecycle what: Automattically transitions logs to S3 Glacier after 60 days to reduce storage costs while maintancing compliance.


## Alternatives You Could Use Instead

1. AWS Control Tower: For a managed, out-of-the-box landing zone experience.

2. AWS Transit Gateway: To centralize complex networking between dozens of VPCs.

3. AWS CloudFormation StackSets: For deploying IAM roles or resources across every account in the Org simultaneously.

## Improvements I Can Add Later

1. Service Quota Automation: Adding logic to set hard limits on the number of VPCs or EC2 instances allowed per account to prevent runaway scaling.

2. Multi-Region Logging: Expanding the logging bucket to aggregate data from global regions if the company expands outside North America.

3. Automated Account Factory: Using Terraform to fully automate the provisioning of new AWS accounts with pre-configured VPCs and IAM roles.

4. Security Hub Integration: Centralizing security alerts from every account into a single dashboard for the Security OU.
