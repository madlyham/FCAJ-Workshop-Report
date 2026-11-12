---
title: "Week 6 Worklog"
date: 2026-11-07
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

# **Week 6 Work Log: Terraform Dev Environment, Full Market Flow on AWS & Cloud & AI Meetup**

## **1. Weekly Objectives**

* Move the whole dev environment into Terraform so it can be rebuilt with one command.
* Run the full market flow on AWS and prove it with an end-to-end smoke test.
* Add background jobs and monitoring; attend Event 4 (Cloud & AI Infrastructure Meetup).

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Confirm the full market flow live on AWS by 10/19 (listing → match → quote → chat offer → transaction → review); store Terraform state in a versioned S3 bucket | 10/19/2026 | 10/19/2026 | Terraform Docs |
| **Day 3** | • Rebuild the dev stack in Terraform: reloop-dev-user-pool, reloop-dev-api, CloudFront with Origin Access Control (OAC) for the web bucket | 10/20/2026 | 10/20/2026 | infra/*.tf |
| **Day 4** | • EventBridge rule every 15 minutes: expire listings, auto-complete transactions after 48 hours, send reminders, issue monthly invoices | 10/21/2026 | 10/21/2026 | Amazon EventBridge Docs |
| **Day 5** | • Deploy and run smoke-aws.py against the live dev stack: 25/25 checks pass | 10/22/2026 | 10/22/2026 | smoke-aws.py |
| **Day 6** | • CloudWatch dashboard reloop-dev-overview and alarms (Lambda errors/throttles, API 5xx, p95 > 2 s) sent to Admin by SNS email | 10/23/2026 | 10/23/2026 | Amazon CloudWatch Docs |
| **Day 7** | • Attend [Event 4: Cloud & AI Infrastructure Meetup](../../4-eventparticipated/4.4-event4/) (10:30 AM – 12:00 PM at Bitexco Financial Tower). Deep-dive into AI data object storage (S3 API compatibility at scale), GPU cluster inference serving, and memory router architectures. | 10/24/2026 | 10/24/2026 | Event 4 / OMZ, Viettel & AWS |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned why remote, versioned Terraform state matters when several people deploy the same stack.
* Understood how time-bucketed job keys let a scheduled sweep find due work without scanning the table.

### **Environment Setup & Configuration**

* Terraform-managed dev stack: Cognito, HTTP API, Lambda, DynamoDB, S3, CloudFront (OAC), EventBridge, CloudWatch, SNS.
* Dashboard reloop-dev-overview with alarms routed to SNS email.

### **Practical Skills & Operations**

* Passed the end-to-end smoke test (25/25) on the deployed dev stack.
* Attended the Cloud & AI Infrastructure Meetup and noted ideas on storage for AI workloads.
