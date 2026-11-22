---
title: "Week 6 Worklog"
date: 2026-11-07
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

# **Week 6 Worklog — Terraform Dev Environment, Full Market Flow on AWS & Cloud & AI Meetup**

## **1. Weekly Objectives**

* Move the whole dev environment into Terraform so it can be rebuilt with one command.
* Run the full market flow on AWS and prove it with an end-to-end smoke test.
* Add scheduled background expiry and CloudWatch/SNS alerting; attend Event 4 (Cloud & AI Infrastructure Meetup).

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Confirm the full market flow live on AWS by 19/10/2026 (listing → match → quote → chat offer → transaction → review); store Terraform state in a versioned S3 bucket | 19/10/2026 | 19/10/2026 | Terraform Docs |
| **Tuesday** | • Rebuild the dev stack in Terraform: `reloop-dev-user-pool`, `reloop-dev-api`, CloudFront with Origin Access Control (OAC) for the web bucket | 20/10/2026 | 20/10/2026 | `infra/*.tf` |
| **Wednesday** | • Configure an Amazon EventBridge scheduled rule every 15 minutes to expire open listings past their 7-day window | 21/10/2026 | 21/10/2026 | Amazon EventBridge Docs |
| **Thursday** | • Deploy and run `smoke-aws.py` against the live dev stack: 25/25 checks pass | 22/10/2026 | 22/10/2026 | `smoke-aws.py` |
| **Friday** | • Configure 7-day CloudWatch log retention and a Lambda Errors metric alarm (≥ 3 errors in 5 min) routed to Admin email alerts via Amazon SNS | 23/10/2026 | 23/10/2026 | Amazon CloudWatch Docs, Amazon SNS Docs |
| **Saturday** | • Attend [Event 4: Cloud & AI Infrastructure Meetup](../../4-eventparticipated/4.4-event4/) (10:30 AM – 12:00 PM at Bitexco Financial Tower). Deep-dive into AI data object storage (S3 API compatibility at scale), GPU cluster inference serving, and Agent Router & memory graph architectures. | 24/10/2026 | 24/10/2026 | Event 4 / OMZ, Viettel & AWS |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned why remote, versioned Terraform state matters when several people deploy the same stack.
* Understood how time-bucketed job keys let a scheduled sweep find due work without scanning the table.

### **Environment Setup & Configuration**

* Terraform-managed dev stack: Cognito, HTTP API, Lambda, DynamoDB, S3, CloudFront (OAC), EventBridge, CloudWatch, and SNS.
* 7-day CloudWatch log retention and 1 Lambda Errors metric alarm (≥ 3 errors in 5 min) routed to Admin email alerts via SNS.

### **Practical Skills & Operations**

* Passed the end-to-end smoke test (25/25) on the deployed dev stack.
* Attended the Cloud & AI Infrastructure Meetup and noted ideas on storage for AI workloads.
