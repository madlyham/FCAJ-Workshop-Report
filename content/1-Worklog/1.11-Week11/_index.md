---
title: "Week 11 Worklog"
date: 2026-11-07
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

# **Week 11 Work Log: Terraform State Migration, Resource Clean-up & Cost Review**

## **1. Weekly Objectives**

* Put all Terraform state in one safe, versioned place per environment.
* Remove old resources left over from the early manual setup.
* Compare real costs with the estimate and confirm the credits last until 28/02/2027.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Plan the state migration: list every resource, back up the current state files | 11/23/2026 | 11/23/2026 | Terraform Docs |
| **Day 3** | • Migrate state to the versioned S3 backend (one key per environment) and confirm terraform plan shows no changes | 11/24/2026 | 11/24/2026 | infra/backend.tf |
| **Day 4** | • Find resources created by hand in weeks 1–5 (old user pool, test API, practice buckets) that Terraform does not manage | 11/25/2026 | 11/25/2026 | AWS Console, Resource Explorer |
| **Day 5** | • Delete the unused resources after team approval; re-run the smoke test on dev and production | 11/26/2026 | 11/26/2026 | smoke-aws.py |
| **Day 6** | • Cost review in Cost Explorer against the estimate (about 18.70 USD/month, mostly WAF); confirm the credits cover the run until 28/02/2027 | 11/27/2026 | 11/27/2026 | AWS Cost Explorer |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned how to move Terraform state safely without recreating live resources.
* Understood that most of our bill is fixed WAF cost, while usage-based services stay under 1 USD/month.

### **Environment Setup & Configuration**

* Versioned S3 state backend with one key per environment.
* Account cleaned of unmanaged leftover resources.

### **Practical Skills & Operations**

* Confirmed terraform plan was clean after the migration before deleting anything.
* Wrote a short cost summary for the final report.
