---
title: "Week 4 Worklog"
date: 2026-11-07
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

# **Week 4 Work Log: Serverless Computing with AWS Lambda, API Gateway & CloudWatch**

## **1. Weekly Objectives**

* Move from always-on EC2 servers to Serverless compute (AWS Lambda + API Gateway).
* Understand how functions wake up on a trigger, run code, and shut down without idle cost.
* Set up CloudWatch logs and AWS Budgets alerts so we dont burn credits by accident.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Study AWS Lambda: Event triggers, cold starts, timeout limits, and environment variables | 09/01/2025 | 09/01/2025 | AWS Cloud Journey |
| **Day 3** | • Learn API Gateway (HTTP API): Acts as the front door router that takes web requests and forwards to Lambda | 09/02/2025 | 09/02/2025 | AWS Cloud Journey |
| **Day 4** | • Hands-on practice: Write a small Lambda function to read/write DynamoDB; Attach IAM execution role | 09/03/2025 | 09/03/2025 | AWS Cloud Journey |
| **Day 5** | • Wire API Gateway routes (GET, POST) to Lambda and test CORS preflight OPTIONS | 09/04/2025 | 09/04/2025 | AWS Cloud Journey |
| **Day 6** | • Hands-on practice: Check function logs in CloudWatch; Set up AWS Budgets email alerts (50%, 80%, 100% of $20) | 09/05/2025 | 09/05/2025 | AWS Cloud Journey |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Got comfortable with how API Gateway + Lambda + DynamoDB form a full backend without paying for a running Linux box 24/7.
* Learned how CloudWatch collects console.log outputs from Lambda and triggers alarms when errors spike.

### **Environment Setup & Configuration**

* Deployed a working HTTP API Gateway hooked up to a Node.js Lambda function.
* Set up AWS Budgets alerts at 50/80/100% thresholds so we get emailed before spending real money.

### **Practical Skills & Operations**

* Debugged Lambda permission errors by checking CloudWatch log streams and adding the missing dynamodb:PutItem rule in IAM.
