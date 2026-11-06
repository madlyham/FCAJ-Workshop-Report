---
title: "Week 11 Worklog"
date: 2026-11-07
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

# **Week 11 Work Log: Infrastructure as Code with Terraform, CloudFront SPA & Live Smoke Tests**

## **1. Weekly Objectives**

* Sync the whole infrastructure with Terraform (infra/*.tf) on branch feature/doi-tac-2-cap.
* Deploy production React app to S3 + CloudFront (https://d1cjl1tvcp0r6q.cloudfront.net) and retire standalone test resources.
* Verify EventBridge 15-minute background job, CloudWatch dashboard, and 25-step live AWS smoke test.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Walk through Terraform state (s3://reloop-tfstate-926583575243/dev/terraform.tfstate) and resource definitions in infra/*.tf | 10/20/2025 | 10/20/2025 | infra/*.tf |
| **Day 3** | • Migrate from standalone user pool to Terraform-managed reloop-dev-user-pool and single reloop-dev-api Lambda | 10/21/2025 | 10/21/2025 | infra/ & Task O3 |
| **Day 4** | • Test EventBridge rate(15 minutes) sweep job (LISTING_EXPIRE, TX_REMIND, TX_AUTO_COMPLETE, 10k VND fee invoices) | 10/22/2025 | 10/22/2025 | modules/jobs & billing |
| **Day 5** | • Check reloop-dev-overview CloudWatch Dashboard and 8 alarms (UnhandledErrors, AiFailures, ImagesTextFlagged, p95 latency) | 10/23/2025 | 10/23/2025 | infra/monitoring.tf |
| **Day 6** | • Run AWS_PROFILE=reloop python scripts/smoke-aws.py against live AWS; all 25 steps pass (ALL PASS) | 10/24/2025 | 10/24/2025 | scripts/smoke-aws.py |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Saw how putting everything into Terraform (deploy.sh) prevents deployment discrepancies—one script builds TypeScript, zips for arm64 Lambda, applies Terraform, and syncs Vite build to CloudFront.

### **Environment Setup & Configuration**

* Configured CloudFront Origin Access Control (OAC SigV4) so web S3 bucket stays 100% private while serving React SPA over HTTPS.

### **Practical Skills & Operations**

* Passed all 107 local Vitest unit tests (billing.test.ts, state machines, AI, auth) and 25/25 live AWS smoke tests.
