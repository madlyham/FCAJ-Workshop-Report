---
title: "Week 5 Worklog"
date: 2026-11-07
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

## **Week 5 Worklog — Secure S3 Uploads, Rekognition Moderation & AI Listing with Bedrock Nova Pro**

## **1. Weekly Objectives**

* Let sellers upload photos straight to S3 safely, with size, type, and ownership checks.
* Block unsafe photos automatically with Amazon Rekognition.
* Choose a pay-per-token AI model aligned with our AWS credit constraints and build the first AI listing assistant.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Implemented `S3ImageStore`: presigned POST (300 s, max 5 MB, JPEG/PNG/WebP, up to 6 photos per listing) and `assertOwnImageKeys` so users could only attach their own photos | 12/10/2026 | 12/10/2026 | [Amazon S3 Docs](https://docs.aws.amazon.com/s3/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`imageStore.ts`) |
| **Tuesday** | • Integrated Rekognition `DetectModerationLabels` (`MinConfidence 70`) so unsafe photos returned `422 IMAGE_REJECTED`; configured lifecycle rules deleting unattached photos after 1 day and all photos after 90 days | 13/10/2026 | 13/10/2026 | [Amazon Rekognition Docs](https://docs.aws.amazon.com/rekognition/) |
| **Wednesday** | • Checked Billing → Credits → applicable products; dropped SageMaker and Rekognition Custom Labels (hourly cost, need training data) and picked Amazon Nova Pro (`apac.amazon.nova-pro-v1:0`) for initial prototyping to stay cleanly on AWS first-party Bedrock per-token pricing | 14/10/2026 | 14/10/2026 | [AWS Billing & Cost Explorer](https://docs.aws.amazon.com/cost-management/latest/userguide/), [Amazon Bedrock Docs](https://docs.aws.amazon.com/bedrock/) |
| **Thursday** | • Implemented `BedrockAnalyzer` with the Converse API and forced `toolChoice` so the model returned JSON matching our `AiResult` schema (`temperature 0`, `maxTokens 2048`) | 15/10/2026 | 15/10/2026 | [Amazon Bedrock Docs](https://docs.aws.amazon.com/bedrock/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`analyzer.ts`) |
| **Friday** | • Moved AI analysis to asynchronous background execution (Lambda self-invoke, `InvocationType=Event`) and tested it on real laptop and component photos | 16/10/2026 | 16/10/2026 | [AWS Lambda Docs](https://docs.aws.amazon.com/lambda/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`aiService.ts`) |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned why initial prototyping favored Amazon's first-party Nova models (pay-per-token, zero idle cost, straightforward AWS promotional credit eligibility) over hourly endpoints like SageMaker or third-party Marketplace subscriptions.
* Understood how presigned POST policies enforce file size and type constraints on the S3 side, not just in the browser.

### **Environment Setup & Configuration**

* Photo flow: presign → direct upload → moderate → tag; lifecycle 1 day (unattached) / 90 days (all).
* `AI_MODEL_ID=apac.amazon.nova-pro-v1:0` with Converse tool use locked to the `AiResult` schema.

### **Practical Skills & Operations**

* Tested Nova Pro on a Dell Latitude 5490 sticker photo; it returned valid JSON matching our schema on the first try.
* Verified that a user cannot attach another user's photo key to a listing.
