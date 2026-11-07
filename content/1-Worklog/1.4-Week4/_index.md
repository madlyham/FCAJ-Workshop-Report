---
title: "Week 4 Worklog"
date: 2026-11-07
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

# **Week 4 Work Log: Serverless Computing with AWS Lambda, API Gateway & CloudWatch**

## **1. Weekly Objectives**

* Learn event-driven serverless architecture: code that runs on demand and bills only for active execution.
* Build a lightweight RESTful backend using API Gateway HTTP APIs and Node.js Lambda.
* Set up CloudWatch monitoring and cost budget alarms to prevent unexpected cloud spend.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Study AWS Lambda: Event triggers, cold starts, timeout limits, and environment variables | 08/31/2026 | 08/31/2026 | AWS Cloud Journey |
| **Day 3** | • Learn API Gateway (HTTP API): Routing web requests directly to Lambda functions | 09/01/2026 | 09/01/2026 | AWS Cloud Journey |
| **Day 4** | • Hands-on practice: Write a Node.js Lambda function to read/write DynamoDB with IAM execution role | 09/02/2026 | 09/02/2026 | AWS Cloud Journey |
| **Day 5** | • Wire API Gateway routes (GET, POST) to the Lambda function and test CORS preflight OPTIONS | 09/03/2026 | 09/03/2026 | AWS Cloud Journey |
| **Day 6** | • Hands-on practice: Check function logs in CloudWatch; Set up AWS Budgets email alerts (50%, 80%, 100%) | 09/04/2026 | 09/04/2026 | AWS Cloud Journey |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Understood serverless economics: zero idle server costs, instant auto-scaling, and pay-per-millisecond compute.
* Learned why CORS preflight headers must be handled properly for browser clients.

### **Environment Setup & Configuration**

* Configured HTTP API Gateway linked to Lambda integration.
* Configured AWS Budgets with email threshold alerts.

### **Practical Skills & Operations**

* Deployed and tested CRUD operations via curl and browser.
* Debugged runtime errors using CloudWatch log streams.
