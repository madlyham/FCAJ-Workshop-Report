---
title : "Workshop"
date : 2026-11-14
weight : 5
chapter : false
pre : " <b> 5. </b> "
---

# Deploy ReLoop Serverless E-Waste Marketplace on AWS

Welcome to the **ReLoop AWS Serverless Workshop**. Across Modules **5.1 through 5.13**, you will deploy an end-to-end, production-style serverless web application from scratch via the AWS Management Console—covering single-table DynamoDB storage, Amazon Cognito authentication, private S3 media uploads with presigned URLs, a Node.js 22 ARM64 backend API behind Amazon API Gateway, multimodal AI device screening with Amazon Bedrock (`global.moonshotai.kimi-k3`), Bedrock Guardrails, and Amazon Rekognition, global delivery through Amazon CloudFront + OAC, layered AWS WAFv2 protection, scheduled EventBridge sweeps, CloudWatch observability, full end-to-end verification, and complete resource cleanup with Terraform Infrastructure-as-Code (IaC) parity.

{{% notice note %}}
This guide uses `reloop2` as the workshop prefix and `123456789012` / `alerts@example.com` as sanitized placeholder identifiers so you can safely follow along alongside existing workloads without name collisions or secret exposure.
{{% /notice %}}

### Workshop Modules

1. [5.1. Workshop Overview & Architecture](5.1-workshop-overview/)
2. [5.2. Prerequisites, Budget Guardrails & Bedrock Access](5.2-prerequisites/)
3. [5.3. Single-Table Data Layer with Amazon DynamoDB](5.3-dynamodb/)
4. [5.4. Authentication & User Profiles with Amazon Cognito](5.4-cognito/)
5. [5.5. Private Image Storage with Amazon S3, CORS & Lifecycle Rules](5.5-s3-images/)
6. [5.6. Serverless Backend with AWS Lambda & HTTP API Gateway](5.6-backend-api/)
7. [5.7. Content Safety with Amazon Bedrock Guardrails](5.7-bedrock-guardrails/)
8. [5.8. Frontend Hosting & Edge Routing with CloudFront & OAC](5.8-cloudfront-frontend/)
9. [5.9. Edge & Identity Protection with AWS WAFv2](5.9-waf/)
10. [5.10. Automated Background Sweeps with Amazon EventBridge](5.10-eventbridge/)
11. [5.11. Observability with CloudWatch Logs, Alarms, SNS & Dashboard](5.11-monitoring/)
12. [5.12. End-to-End Live Verification](5.12-end-to-end-verification/)
13. [5.13. Cleanup & Infrastructure as Code (Terraform)](5.13-cleanup-and-iac/)
