---
title: "Week 1 Worklog"
date: 2026-11-07
weight: 1
chapter: false
pre: " <b> 1.1. </b> "
---

## **Week 1 Worklog — AWS Foundations, Console, CLI, EC2, IAM & VPC**

## **1. Weekly Objectives**

* Get familiar with the AWS Management Console, AWS CLI, and the Free Tier.
* Launch and manage compute (EC2, EBS, Elastic IP) safely.
* Stop using the root account day-to-day and build a basic secure network (IAM + VPC).

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Completed onboarding to the First Cloud AI Journey program; toured the AWS Console, regions, Availability Zones, and Free Tier limits | 14/09/2026 | 14/09/2026 | [AWS Regions and Availability Zones](https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html), [AWS Free Tier](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier.html), [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) |
| **Tuesday** | • Installed and configured AWS CLI v2 (profiles, default region `ap-southeast-1`); ran first read-only commands | 15/09/2026 | 15/09/2026 | [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), [AWS CLI config and credential files](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) |
| **Wednesday** | • Launched an EC2 instance, attached an extra EBS volume, and assigned an Elastic IP; terminated the instance, then explicitly released the allocated Elastic IP and deleted the extra non-root EBS volume (`DeleteOnTermination = false` by default), since stopping or terminating EC2 alone does not stop billing for unassociated Elastic IPs or leftover EBS volumes | 16/09/2026 | 16/09/2026 | [Elastic IP addresses](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html), [Preserve data on instance termination](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/preserving-volumes-on-termination.html), [Attach an EBS volume](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-attaching-volume.html) |
| **Thursday** | • Practiced IAM basics (users, groups, roles, JSON policies); created an IAM admin user with MFA and locked away the root account | 17/09/2026 | 17/09/2026 | [IAM users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html), [MFA in IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html), [Root user best practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/root-user-best-practices.html) |
| **Friday** | • Built a custom VPC (`10.0.0.0/16`) with public/private subnets, an Internet Gateway, and route tables; compared Security Groups vs NACLs | 18/09/2026 | 18/09/2026 | [VPC subnets](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html), [Internet gateways](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html), [Route tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html), [VPC security groups and network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/infrastructure-security.html) |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Understood the shared responsibility model and how regions and Availability Zones give high availability.
* Learned the least-privilege principle: grant only the permissions a task needs.
* Learned why private subnets keep databases and internal servers away from direct Internet scans.

### **Environment Setup & Configuration**

* AWS CLI v2 configured with a named profile and region `ap-southeast-1`.
* IAM admin user with MFA created; root credentials stored safely and not used for daily work.
* Custom VPC spread across 2 Availability Zones with 2 public and 2 private subnets.

### **Practical Skills & Operations**

* Launched, connected to, and cleaned up EC2 resources (including releasing the Elastic IP and deleting extra non-root EBS volumes) without leaving billable items running.
* Wrote and tested IAM JSON policies that allow only the needed read/write actions.
* Verified network isolation: public subnet reaches the Internet via the IGW, private subnet accepts no inbound traffic from outside.
