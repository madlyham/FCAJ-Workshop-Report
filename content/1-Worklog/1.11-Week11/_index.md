---
title: "Week 11 Worklog"
date: 2026-11-07
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

# **Week 11 Work Log: Infrastructure as Code, Live Smoke Tests & Cloud & AI Meetup**

## **1. Weekly Objectives**

* Sync the entire infrastructure using Terraform (infra/*.tf) on branch feature/doi-tac-2-cap.
* Deploy production React client to S3 + CloudFront (https://d1cjl1tvcp0r6q.cloudfront.net) and retire standalone test resources.
* Verify EventBridge 15-minute background sweep job, CloudWatch dashboard, and 25-step live AWS smoke test.
* Attend Event 4 (Cloud & AI Infrastructure Meetup) at Bitexco Financial Tower to analyze object storage throughput and GPU inference architectures.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Walk through Terraform state (s3://reloop-tfstate-926583575243/dev/terraform.tfstate) and resource definitions in infra/*.tf | 10/19/2026 | 10/19/2026 | infra/*.tf |
| **Day 3** | • Migrate from standalone user pool to Terraform-managed reloop-dev-user-pool and single reloop-dev-api Lambda | 10/20/2026 | 10/20/2026 | infra/ & Task O3 |
| **Day 4** | • Test EventBridge rate(15 minutes) sweep job (LISTING_EXPIRE, TX_REMIND, TX_AUTO_COMPLETE, 10k VND fee invoices) | 10/21/2026 | 10/21/2026 | modules/jobs & billing |
| **Day 5** | • Check reloop-dev-overview CloudWatch Dashboard and 8 alarms (UnhandledErrors, AiFailures, ImagesTextFlagged, p95 latency) | 10/22/2026 | 10/22/2026 | infra/monitoring.tf |
| **Day 6** | • Run AWS_PROFILE=reloop python scripts/smoke-aws.py against live AWS; all 25 steps pass (ALL PASS) | 10/23/2026 | 10/23/2026 | scripts/smoke-aws.py |
| **Day 7** | • Attend [Event 4: Cloud & AI Infrastructure Meetup](../../4-eventparticipated/4.4-event4/) (10:30 AM – 12:00 PM at Bitexco Financial Tower). Deep-dive into AI data object storage (S3 API compatibility at scale), GPU cluster inference serving, and memory router architectures. | 10/24/2026 | 10/24/2026 | Event 4 / OMZ, Viettel & AWS |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Saw how putting everything into Terraform (deploy.sh) eliminates human deployment discrepancies—one script builds TypeScript, zips for arm64 Lambda, applies Terraform, and syncs Vite build to CloudFront.
* Validated our S3 throughput and CloudFront SPA caching strategies against real-world enterprise object storage patterns shared at the Cloud & AI Infrastructure Meetup.

### **Environment Setup & Configuration**

* Configured CloudFront Origin Access Control (OAC SigV4) so web S3 bucket stays 100% private while serving React SPA over HTTPS.
* Set up S3 remote backend with DynamoDB state locking.

### **Practical Skills & Operations**

* Passed all 107 local Vitest unit tests (billing, state machines, AI, auth) and 25/25 live AWS smoke tests.
* Participated in Event 4 at Bitexco, gaining practical insights into high-throughput storage and GPU scheduling.
