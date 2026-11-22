---
title: "Week 8 Worklog"
date: 2026-11-07
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

# **Week 8 Worklog — Background Matching, QA Rounds, WAF & Developer Reference**

## **1. Weekly Objectives**

* Match every new listing to buyer branches nearby, automatically and in the background.
* Find and fix bugs through structured QA rounds and a first load test.
* Protect the CloudFront edge and public API with AWS WAF and write the developer reference.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Background matching with geohash + Haversine distance: each listing goes to every approved branch whose service area (1–15 km) covers it; listings within 5 km rank first | 02/11/2026 | 02/11/2026 | [Amazon DynamoDB Docs](https://docs.aws.amazon.com/dynamodb/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`matching.ts`) |
| **Tuesday** | • Consolidate 5 QA rounds: 146 findings logged and prioritized (03/11/2026) | 03/11/2026 | 03/11/2026 | [ReLoop Repository](https://github.com/madlyham/ReLoop), [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) |
| **Wednesday** | • First load test (`loadtest.mjs`, 80 parallel requests): 26% `5xx` at Lambda concurrency 10; request and receive a quota raise to 1,000 | 04/11/2026 | 04/11/2026 | [AWS Lambda Docs](https://docs.aws.amazon.com/lambda/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`loadtest.mjs`) |
| **Thursday** | • AI quota of 20 analyses per user per day (`AI_DAILY_LIMIT`); store the AI suggestion next to the seller's final value (`AILABEL`) | 05/11/2026 | 05/11/2026 | [Amazon Bedrock Docs](https://docs.aws.amazon.com/bedrock/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`aiService.ts`) |
| **Friday** | • Configure a single CloudFront AWS WAF web ACL (3 AWS managed rule groups + 2 per-IP rate limits: 100 req/min on the public API and 1,000 req/min overall) on 06/11/2026; write `RELOOP_TECHNICAL_REFERENCE` (30+ key patterns, all API routes) | 06/11/2026 | 06/11/2026 | [AWS WAF Docs](https://docs.aws.amazon.com/waf/), [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`infra/waf.tf`) |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned how geohash prefixes narrow the search area so only nearby branches are checked with the exact Haversine distance.
* Understood that the default Lambda concurrency limit on a new account can be the first bottleneck under load.

### **Environment Setup & Configuration**

* Single CloudFront WAF web ACL ($10.00/month) with 3 AWS managed rule groups and 2 per-IP rate limits (100 req/min public API, 1,000 req/min overall).
* Lambda concurrency quota raised from 10 to 1,000; AI daily limit set to 20 per user.

### **Practical Skills & Operations**

* Resolved the highest-priority QA bugs and re-tested the affected flows.
* Wrote the developer reference so new team members can find every key pattern and route in one place.
