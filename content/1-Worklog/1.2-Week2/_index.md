---
title: "Week 2 Worklog"
date: 2026-11-07
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

# **Week 2 Work Log: Serverless Basics: S3, DynamoDB, Lambda, API Gateway & Buildrathon Kickoff**

## **1. Weekly Objectives**

* Learn the core serverless building blocks: S3, DynamoDB, Lambda and API Gateway.
* Set up monitoring and cost guard-rails (CloudWatch, AWS Budgets) from day one.
* Attend Event 1 (Buildrathon Kickoff), which marks the start of our capstone project ReLoop.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Amazon S3: buckets, Block Public Access, versioning, lifecycle rules and CORS | 09/21/2026 | 09/21/2026 | AWS Cloud Journey |
| **Day 3** | • Presigned URLs (300-second expiry) for direct browser upload/download without making the bucket public | 09/22/2026 | 09/22/2026 | Amazon S3 Docs |
| **Day 4** | • Amazon DynamoDB: partition key / sort key (PK/SK), On-Demand capacity, single-table design ideas | 09/23/2026 | 09/23/2026 | AWS Cloud Journey |
| **Day 5** | • AWS Lambda + API Gateway HTTP API: first function, routes, CORS, logs in CloudWatch | 09/24/2026 | 09/24/2026 | AWS Cloud Journey |
| **Day 6** | • Create AWS Budgets alerts at 50% / 80% / 100% and review CloudWatch metrics and alarms | 09/25/2026 | 09/25/2026 | AWS Billing Console |
| **Day 7** | • Participate in [Event 1: Buildrathon – Kickoff: Code the Future with CMC Global](../../4-eventparticipated/4.1-event1/) (10:30 AM – 12:00 PM at Bitexco Financial Tower). Explore Generative AI, agentic tool workflows, and RAG architectures. Our team starts the ReLoop capstone project here. | 09/26/2026 | 09/26/2026 | Event 1 / CMC Global & AWS |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Understood why serverless (pay per request, no idle servers) fits a small team with limited credits.
* Learned how a good PK/SK design lets DynamoDB answer every query without a table scan.
* Took away from Event 1 how GenAI tools and agent workflows can speed up a hackathon-style build.

### **Environment Setup & Configuration**

* Private S3 bucket with Block Public Access, lifecycle and CORS for browser uploads.
* Practice DynamoDB table in On-Demand mode.
* AWS Budgets alerts at 50% / 80% / 100% sent by email.

### **Practical Skills & Operations**

* Built a small Lambda + HTTP API endpoint and traced its logs in CloudWatch.
* Uploaded and downloaded files with presigned URLs without making any bucket public.
* Joined the Buildrathon kickoff with the team and agreed to build ReLoop, a marketplace for used electronics.
