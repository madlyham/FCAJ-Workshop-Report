---
title: "Week 1 Worklog"
date: 2026-11-07
weight: 1
chapter: false
pre: " <b> 1.1. </b> "
---

# **Week 1 Worklog — AWS Foundations, Console, CLI, EC2, IAM & VPC**

## **1. Weekly Objectives**

* Get familiar with the AWS Management Console, AWS CLI, and the Free Tier.
* Launch and manage compute (EC2, EBS, Elastic IP) safely.
* Stop using the root account day-to-day and build a basic secure network (IAM + VPC).

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Onboarding to the First Cloud Journey program; tour of the AWS Console, regions, Availability Zones, and Free Tier limits | 14/09/2026 | 14/09/2026 | AWS Cloud Journey |
| **Tuesday** | • Install and configure AWS CLI v2 (profiles, default region `ap-southeast-1`); run first read-only commands | 15/09/2026 | 15/09/2026 | AWS CLI Docs |
| **Wednesday** | • Hands-on: launch an EC2 instance, attach an EBS volume, assign an Elastic IP, then stop/terminate to avoid charges | 16/09/2026 | 16/09/2026 | AWS Cloud Journey |
| **Thursday** | • IAM basics: users, groups, roles, JSON policies; create an IAM admin user with MFA and lock away the root account | 17/09/2026 | 17/09/2026 | AWS Cloud Journey |
| **Friday** | • VPC basics: build a custom VPC (`10.0.0.0/16`) with public/private subnets, Internet Gateway, route tables, Security Groups vs NACLs | 18/09/2026 | 18/09/2026 | AWS Cloud Journey |

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

* Launched, connected to, and cleaned up EC2 resources without leaving billable items running.
* Wrote and tested IAM JSON policies that allow only the needed read/write actions.
* Verified network isolation: public subnet reaches the Internet via the IGW, private subnet accepts no inbound traffic from outside.
