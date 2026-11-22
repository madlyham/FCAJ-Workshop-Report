---
title : "Workshop"
date : 2026-11-21
weight : 5
chapter : false
pre : " <b> 5. </b> "
---

# Deploy ReLoop Serverless E-Waste Marketplace on AWS

Welcome to the **ReLoop AWS Serverless Workshop**. Across Modules **5.1 through 5.12**, you build and verify a complete serverless web application on AWS following the exact request flow of the architecture diagram — from **Arrow 1** at the global edge all the way through **Arrow 10** in AI processing, plus scheduled cleanup, monitoring, live verification, and teardown.

{{% notice tip %}}
**Live Demo:** [https://d1cjl1tvcp0r6q.cloudfront.net/](https://d1cjl1tvcp0r6q.cloudfront.net/) (verified live HTTPS CloudFront deployment of ReLoop)  
**Companion Code & Terraform Repo:** [https://github.com/madlyham/ReLoop](https://github.com/madlyham/ReLoop)
{{% /notice %}}

{{% notice note %}}
This guide uses `reloop2` as the resource prefix and sanitized placeholders (`123456789012`, `alerts@example.com`, `<suffix>`) so you can run the workshop safely without exposing personal data or colliding with existing stacks.
{{% /notice %}}

### Workshop Modules (Graph Order: 1 → 10)

1. [5.1. Workshop Overview & Architecture](5.1-workshop-overview/) — Full diagram & numbered walk **1 → 10**
2. [5.2. Prerequisites & Bedrock Access](5.2-prerequisites/) — Account, Singapore region (`ap-southeast-1`) & Kimi K3 access
3. [5.3. Global Edge & Static Website](5.3-global-edge/) — **Arrows 1, 2** + WAF (`Users → CloudFront [WAF] → S3 website`)
4. [5.4. Sign-up & Sign-in](5.4-sign-up-and-sign-in/) — **Arrow 3** + Post-confirm (`Users → Cognito → Lambda → create profile`)
5. [5.5. API Backend](5.5-api-backend/) — **Arrows 4, 5** + verify JWT (`CloudFront /api/* → API Gateway → Lambda API`)
6. [5.6. Data Storage: Amazon DynamoDB](5.6-dynamodb/) — **Arrow 6** (`read/write users, listings & invoices`)
7. [5.7. Data Storage: Amazon S3 Photos](5.7-s3-photos/) — **Arrows 7, 8** (`presign & tag` + `upload / view photos`)
8. [5.8. AI Processing: Rekognition & Bedrock](5.8-ai-processing/) — **Arrows 9, 10** (`image moderation` + `AI analysis + Guardrail`)
9. [5.9. Scheduled Sweeps: Amazon EventBridge](5.9-eventbridge/) — `expire listings every 15 min`
10. [5.10. Monitoring & Alerts: CloudWatch & SNS](5.10-monitoring/) — `logs & metrics → alarm → email Admin`
11. [5.11. End-to-End Verification](5.11-end-to-end-verification/) — Live walk of **Arrows 1 → 10** + EventBridge + CloudWatch & SNS
12. [5.12. Cleanup & Terraform Reference](5.12-cleanup-and-iac/) — Reverse-order teardown & zero-leftovers verification
