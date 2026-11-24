---
title: "Week 2 Worklog"
date: 2026-11-07
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

## **Week 2 Worklog — Serverless Basics (S3, DynamoDB, Lambda, API Gateway) & Buildrathon Kickoff**

## **1. Weekly Objectives**

* Learn the core serverless building blocks: S3, DynamoDB, Lambda, and API Gateway.
* Set up monitoring and cost guardrails (CloudWatch, Billing & Cost Explorer credit monitoring, plus a personal Week 2 sandbox AWS Budgets lab) from day one.
* Attend Event 1 (Buildrathon Kickoff), where our team chose ReLoop as the capstone project (development starts in Week 4).

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Configured Amazon S3 buckets with Block Public Access, versioning, lifecycle rules, and CORS | 21/09/2026 | 21/09/2026 | [S3 Block Public Access](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html), [S3 Versioning](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html), [S3 Lifecycle](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html), [S3 CORS](https://docs.aws.amazon.com/AmazonS3/latest/userguide/cors.html) |
| **Tuesday** | • Generated presigned URLs (300-second expiry) for direct browser upload/download without making the bucket public | 22/09/2026 | 22/09/2026 | [S3 presigned URLs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-presigned-url.html), [Upload with presigned URLs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/PresignedUrlUploadObject.html) |
| **Wednesday** | • Practiced Amazon DynamoDB partition key / sort key (PK/SK), On-Demand capacity, and single-table design concepts | 23/09/2026 | 23/09/2026 | [DynamoDB partition key design](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-partition-key-design.html), [DynamoDB sort keys](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-sort-keys.html), [DynamoDB on-demand mode](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/on-demand-capacity-mode.html), [DynamoDB data modeling foundations](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/data-modeling-foundations.html) |
| **Thursday** | • Built a first AWS Lambda + API Gateway HTTP API endpoint with routes, CORS, and CloudWatch logs | 24/09/2026 | 24/09/2026 | [HTTP API Lambda integrations](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-lambda.html), [HTTP API CORS](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-cors.html), [Lambda logs in CloudWatch](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-cloudwatchlogs.html) |
| **Friday** | • Reviewed AWS Billing, Cost Explorer, and credit balance monitoring; practiced AWS Budgets alerts (50% / 80% / 100%) in a personal Week 2 sandbox lab (outside ReLoop's 12-service stack) and reviewed CloudWatch metrics and alarms | 25/09/2026 | 25/09/2026 | [AWS Cost Explorer](https://docs.aws.amazon.com/cost-management/latest/userguide/ce-what-is.html), [AWS Budgets](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html), [CloudWatch alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html) |
| **Saturday** | • Participated in [Event 1: Buildrathon – Kickoff: Code the Future with CMC Global](../../4-eventparticipated/4.1-event1/) (10:30 AM – 12:00 PM at Bitexco Financial Tower). Explored Generative AI, agentic tool workflows, and RAG architectures. Our team picked ReLoop as the capstone topic here; spec and design followed in Weeks 3–4, and coding started on 09/10/2026. | 26/09/2026 | 26/09/2026 | [Event 1](../../4-eventparticipated/4.1-event1/), [Bedrock Knowledge Bases](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html), [Bedrock Agents](https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html) |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Understood why serverless (pay per request, no idle servers) fits a small team with limited credits.
* Learned how a good PK/SK design lets DynamoDB answer every query without a table scan.
* Took away from Event 1 how GenAI tools and agent workflows can speed up a hackathon-style build.

### **Environment Setup & Configuration**

* Private S3 bucket with Block Public Access, lifecycle rules, and CORS for browser uploads.
* Practice DynamoDB table in On-Demand mode.
* Billing & Cost Explorer credit monitoring reviewed, plus a personal Week 2 sandbox AWS Budgets lab (50% / 80% / 100% email alerts; not part of ReLoop's 12-service stack).

### **Practical Skills & Operations**

* Built a small Lambda + HTTP API endpoint and traced its logs in CloudWatch.
* Uploaded and downloaded files with presigned URLs without making any bucket public.
* Joined the Buildrathon kickoff with the team and agreed to build ReLoop, a circular marketplace for used and broken electronics.
