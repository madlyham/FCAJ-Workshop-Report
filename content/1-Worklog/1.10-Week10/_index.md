---
title: "Week 10 Worklog"
date: 2026-11-22
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

## **Week 10 Worklog — Load Test, Throttling Fix, Single Deploy Workflow & Live Workshop Verification**

## **1. Weekly Objectives**

* Prove the system handles traffic bursts gracefully after the Lambda concurrency quota raise.
* Enforce a single CI/CD deploy workflow with one IAM user per member and zero root access keys.
* Rebuild the streamlined hands-on Workshop (`5.1`–`5.12`) and complete full live end-to-end verification across Arrows 1 → 10 (the numbered request/data-flow steps of the Workshop architecture diagram), EventBridge, and CloudWatch/SNS.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Re-ran `loadtest.mjs` (80 parallel requests) against the earlier baseline of 26% `5xx`; with Lambda concurrency at 1,000, `5xx` errors dropped to zero | 16/11/2026 | 16/11/2026 | [AWS Lambda Docs](https://docs.aws.amazon.com/lambda/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`loadtest.mjs`) |
| **Tuesday** | • Applied the throttling fix: configured API Gateway throttling (20 req/s, burst 50) and verified CloudFront WAF rate-limit rules returned controlled `429` + `Retry-After` responses via our custom response configured in Module 5.3 (overriding WAF's default `403` block response) instead of failing | 17/11/2026 | 17/11/2026 | [Amazon API Gateway Docs](https://docs.aws.amazon.com/apigateway/), [AWS WAF Docs](https://docs.aws.amazon.com/waf/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`infra/waf.tf`) |
| **Wednesday** | • Enforced the single GitHub Actions deploy workflow from committed revisions (no manual laptop deploys), closing the Week 7 overwrite issue; finalized one IAM user per team member and confirmed zero root access keys existed on the account | 18/11/2026 | 18/11/2026 | [GitHub Actions Docs](https://docs.github.com/actions), [AWS IAM Docs](https://docs.aws.amazon.com/iam/) |
| **Thursday** | • Rebuilt and streamlined the ReLoop Workshop (`5.1`–`5.12`) to match the exact 12-service (+ IAM) Terraform stack with repeatable setup and cleanup instructions | 19/11/2026 | 19/11/2026 | [Workshop](../../5-workshop/), [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) |
| **Friday** | • Ran full live end-to-end verification across Arrows 1 → 10 of the Workshop architecture diagram (CloudFront + WAF edge, Cognito auth, S3 presigned upload, Rekognition moderation, Bedrock Kimi K3 + Guardrail, and DynamoDB single-table marketplace flows) | 20/11/2026 | 20/11/2026 | [Workshop](../../5-workshop/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`smoke-aws.py`) |
| **Saturday** | • Verified the EventBridge 15-minute listing-expiry sweep and CloudWatch 7-day logs + Lambda Errors alarm (≥ 3 errors in 5 min) → SNS Admin email alerts; recorded the Cost Explorer & credit snapshot (189.80 USD remaining until 28/02/2027) | 21/11/2026 | 21/11/2026 | [Amazon EventBridge Docs](https://docs.aws.amazon.com/eventbridge/), [Amazon CloudWatch Docs](https://docs.aws.amazon.com/cloudwatch/), [Amazon SNS Docs](https://docs.aws.amazon.com/sns/), [AWS Billing & Cost Explorer](https://docs.aws.amazon.com/cost-management/latest/userguide/) |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned the difference between failing under load (`5xx`) and pushing back gracefully with controlled rate limiting (`429` + `Retry-After`).
* Understood why a single CI/CD deploy workflow from committed revisions prevents concurrent overwrites across developer machines.

### **Environment Setup & Configuration**

* API Gateway throttle (20 req/s, burst 50) and CloudFront WAF rate limits (using our Module 5.3 custom response overriding WAF's default `403` block response) verified to return `429` + `Retry-After`.
* Single GitHub Actions deploy workflow active (closing the Week 7 overwrite issue), per-member IAM users enforced, and zero root access keys confirmed.

### **Practical Skills & Operations**

* Compared load-test results before and after the fix and documented them for the final report.
* Completed live end-to-end Workshop verification (`5.1`–`5.12`) across Arrows 1 → 10 of the Workshop architecture diagram, EventBridge, and CloudWatch/SNS, and verified remaining credits (189.80 USD on 21/11/2026 until 28/02/2027).
