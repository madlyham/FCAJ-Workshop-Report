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
* Build a safe network boundary with isolated private subnets for backend resources.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Learn IAM basics: Users, Groups, Roles, and JSON policies | 08/17/2026 | 08/17/2026 | AWS Cloud Journey |
| **Day 3** | • Hands-on practice: Create an IAM Admin user & turn on MFA; Test custom role rules with least privilege | 08/18/2026 | 08/18/2026 | AWS Cloud Journey |
| **Day 4** | • Study VPC fundamentals: Public vs private subnets, Internet Gateway and Route Tables | 08/19/2026 | 08/19/2026 | AWS Cloud Journey |
| **Day 5** | • Learn Security Groups (stateful server firewall) vs NACLs (stateless subnet firewall) | 08/20/2026 | 08/20/2026 | AWS Cloud Journey |
| **Day 6** | • Hands-on practice: Build a custom VPC with public & private subnets; Lock Security Group rules to specific ports | 08/21/2026 | 08/21/2026 | AWS Cloud Journey |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Understood least-privilege security: never give full admin when a narrow permission does the job.
* Learned why private subnets keep databases and internal servers hidden from direct internet attacks.

### **Environment Setup & Configuration**

* Created dedicated IAM Admin user with MFA enabled and locked away the root credentials.
* Provisioned custom VPC (10.0.0.0/16) across multiple Availability Zones.

### **Practical Skills & Operations**

* Wrote clean JSON IAM policies allowing only required read/write actions.
* Verified network isolation: public instances can communicate via IGW while private instances have zero inbound exposure.
