---
title: "Week 5 Worklog"
date: 2026-11-07
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

# **Week 5 Work Log: Secure S3 Uploads, Rekognition Moderation & AI Listing with Bedrock Nova Pro**

## **1. Weekly Objectives**

* Let sellers upload photos straight to S3 safely, with size, type and ownership checks.
* Block unsafe photos automatically with Amazon Rekognition.
* Choose an AI model that the AWS credits cover and build the first AI listing assistant.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • S3ImageStore: presigned POST (300 s, max 5 MB, JPEG/PNG/WebP, up to 6 photos per listing); assertOwnImageKeys so users can only attach their own photos | 10/12/2026 | 10/12/2026 | imageStore.ts |
| **Day 3** | • Rekognition DetectModerationLabels (MinConfidence 70); unsafe photos return 422 IMAGE_REJECTED; lifecycle rules delete unattached photos after 1 day and all photos after 90 days | 10/13/2026 | 10/13/2026 | Amazon Rekognition Docs |
| **Day 4** | • Check Billing → Credits → applicable products; drop SageMaker and Rekognition Custom Labels (hourly cost, need training data); pick Amazon Nova Pro (apac.amazon.nova-pro-v1:0), billed per token and covered by credits | 10/14/2026 | 10/14/2026 | AWS Billing Console, Bedrock Docs |
| **Day 5** | • Implement BedrockAnalyzer with the Converse API and forced toolChoice so the model must return JSON matching our AiResult schema (temperature 0, maxTokens 2048) | 10/15/2026 | 10/15/2026 | analyzer.ts |
| **Day 6** | • Run AI analysis in the background (Lambda self-invoke, InvocationType=Event) and test on real laptop and component photos | 10/16/2026 | 10/16/2026 | aiService.ts |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned why third-party models sold through AWS Marketplace may not use promotional credits, while Amazon's own Nova models do and cost nothing when idle.
* Understood how presigned POST policies enforce file size and type on the S3 side, not just in the browser.

### **Environment Setup & Configuration**

* Photo flow: presign → direct upload → moderate → tag; lifecycle 1 day (unattached) / 90 days (all).
* AI_MODEL_ID=apac.amazon.nova-pro-v1:0 with Converse tool use locked to the AiResult schema.

### **Practical Skills & Operations**

* Tested Nova Pro on a Dell Latitude 5490 sticker photo; it returned valid JSON matching our schema on the first try.
* Verified that a user cannot attach another user's photo key to a listing.
