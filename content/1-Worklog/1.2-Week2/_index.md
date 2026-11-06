---
title: "Week 2 Worklog"
date: 2026-11-07
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

# **Week 2 Work Log: IAM Security, VPC Architecture & Network Isolation**

## **1. Weekly Objectives**

* Understand how AWS handles permission rules (IAM) and private networks (VPC).
* Stop using the root account for daily work and set up proper user and role rules.
* Build an isolated virtual network with public/private zones and port firewall rules.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Learn IAM basics: Users, Groups, Roles, and JSON policies | 08/18/2025 | 08/18/2025 | AWS Cloud Journey |
| **Day 3** | • Hands-on practice: Create an IAM Admin user & turn on MFA; Test custom role rules with least privilege | 08/19/2025 | 08/19/2025 | AWS Cloud Journey |
| **Day 4** | • Study VPC fundamentals: Public vs private subnets, Internet Gateway and Route Tables | 08/20/2025 | 08/20/2025 | AWS Cloud Journey |
| **Day 5** | • Learn Security Groups (stateful server firewall) vs NACLs (stateless subnet firewall) | 08/21/2025 | 08/21/2025 | AWS Cloud Journey |
| **Day 6** | • Hands-on practice: Build a custom VPC with public & private subnets; Lock Security Group rules to port 22 and 80 | 08/22/2025 | 08/22/2025 | AWS Cloud Journey |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Figured out how IAM works as a central rulebook—instead of hardcoding secret keys inside code, attach a Role with strict rules on actions a service can run.
* Understood how a VPC walls off cloud resources and splits public-facing workloads from private backend services.

### **Environment Setup & Configuration**

* Created an IAM user group with MFA enabled and switched local CLI off root keys.
* Built a custom VPC with working route tables and an Internet Gateway attached.

### **Practical Skills & Operations**

* Set up Security Group rules to block random traffic and only allow SSH/HTTP ports.
* Fixed a couple of AccessDenied issues by reading and tweaking JSON permission rules in IAM.
