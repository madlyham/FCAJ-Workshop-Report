---
title: "Week 11 Worklog"
date: 2026-11-22
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

# **Week 11 Worklog — Resource Audit, Unused-Asset Cleanup & Cost Review [Planned]**

> **Status:** Planned (upcoming sprint: 23/11/2026 – 27/11/2026; last updated 22/11/2026).

## **1. Weekly Objectives**

* Audit every active AWS resource across `ap-southeast-1` and `us-east-1` (CloudFront WAF) against the versioned Terraform state file.
* Identify and remove leftover unmanaged resources from the early manual setup in Weeks 1–5 without disrupting the live ReLoop stack.
* Reconcile actual AWS Cost Explorer spend against the **$11.70/month** budget and confirm the remaining AWS credits (**$189.80 USD** as of 21/11/2026) cover operations until 28/02/2027.

## **2. Weekly Execution Schedule**

| Day | Planned Task Description | Target Date | Status | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Inventory every AWS resource in `ap-southeast-1` and `us-east-1` using Resource Explorer and cross-check against the Terraform state file | 23/11/2026 | Planned | [AWS CLI Docs](https://docs.aws.amazon.com/cli/), [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`infra/*.tf`) |
| **Tuesday** | • Identify leftover resources created manually in Weeks 1–5 (old user pools, test APIs, practice buckets, unused IAM roles) outside Terraform management | 24/11/2026 | Planned | [AWS IAM Docs](https://docs.aws.amazon.com/iam/), [Amazon S3 Docs](https://docs.aws.amazon.com/s3/) |
| **Wednesday** | • Confirm `terraform plan` shows no pending changes, back up the cleanup inventory, and obtain team approval before deleting any resource | 25/11/2026 | Planned | [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`infra/backend.tf`) |
| **Thursday** | • Delete approved unused assets and re-run `smoke-aws.py` against the live ReLoop stack to verify zero impact | 26/11/2026 | Planned | [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`smoke-aws.py`) |
| **Friday** | • Finalize the Cost Explorer review against the **$11.70/month** budget ($10.00/month CloudFront WAF + ~$1.70/month usage, with core compute/DB/API/S3 under $0.30/month) and verify credit runway ($189.80 USD remaining on 21/11/2026 until 28/02/2027) | 27/11/2026 | Planned | [AWS Billing & Cost Explorer](https://docs.aws.amazon.com/cost-management/) |

## **3. Expected Outcomes**

### **Theoretical Foundation**

* Reinforce how infrastructure drift detection and Resource Explorer inventories prevent silent bill creep on shared AWS accounts.
* Confirm quantitatively that fixed edge protection (the single CloudFront WAF web ACL at $10.00/month) accounts for most of the bill while serverless core compute, database, API, and S3 stay under $0.30/month.

### **Environment Setup & Configuration**

* Account cleaned of all unmanaged leftover assets from Weeks 1–5, with only the 12-service (+ IAM) ReLoop Terraform stack active.
* `terraform plan` confirmed clean with zero unintended drift.

### **Practical Skills & Operations**

* Complete safe, approved cleanup followed by a passing `smoke-aws.py` verification on the live stack.
* Prepare a concise Cost Explorer & credit-runway summary ($11.70/month run-rate; $189.80 USD remaining as of 21/11/2026 until 28/02/2027) for the final report.
