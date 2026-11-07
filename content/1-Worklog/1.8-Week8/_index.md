---
title: "Week 8 Worklog"
date: 2026-11-07
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

# **Week 8 Work Log: Multimodal AI (Nova Pro), AI Day Hanoi Watch Party & Dr. Werner Fireside**

## **1. Weekly Objectives**

* Attend Event 2 (AWS Cloud and AI Day Hanoi Watch Party) and Event 3 (Fireside Chat with Dr. Werner Vogels) to incorporate enterprise FinOps and distributed system resilience principles.
* Compare AI model options (SageMaker, Rekognition Custom Labels, Claude Haiku, Amazon Nova Pro) to maximize AWS Credit coverage.
* Build the async device classification adapter (BedrockAnalyzer) using Amazon Nova Pro and enforce strict JSON output with Converse API tool schemas.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Check Billing and Cost Management -> Credits -> Applicable products to verify promotional AI coverage | 09/28/2026 | 09/28/2026 | AWS Billing Console |
| **Day 3** | • Attend [Event 2: AWS Cloud and AI Day Hanoi – Watch Party](../../4-eventparticipated/4.2-event2/) (08:00 AM – 05:00 PM at AWS Vietnam Office, Bitexco Level 26). Deep-dive into enterprise AI agents, platform engineering, and FinOps cloud cost optimization. | 09/29/2026 | 09/29/2026 | Event 2 / AWS Vietnam Office |
| **Day 4** | • Drop SageMaker and Custom Labels—both charge hourly and require extensive training data; evaluate serverless inference options | 09/30/2026 | 09/30/2026 | Team AI Review |
| **Day 5** | • Switch to Amazon Nova Pro (apac.amazon.nova-pro-v1:0): Amazon 1st-party model covered by credits, billed strictly per token | 10/01/2026 | 10/01/2026 | Amazon Bedrock Docs |
| **Day 6** | • Attend [Event 3: Fireside Chat with Dr. Werner – Navigating the Future of Cloud & AI in Vietnam](../../4-eventparticipated/4.3-event3/) (10:30 AM – 12:00 PM at Bitexco Financial Tower; Keynote by Dr. Werner Vogels, CTO of Amazon). Implement BedrockAnalyzer using Converse API with forced toolChoice. | 10/02/2026 | 10/02/2026 | Event 3 / Amazon Keynote & analyzer.ts |
| **Day 7** | • Wire async background execution (InvocationType=Event self-invoke) and test on real laptop and component photos | 10/03/2026 | 10/03/2026 | aiService.ts |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned why 3rd-party models like Claude Haiku bill through Marketplace (bypassing promotional credits), while Amazon Nova Pro deducts cleanly from AWS credits and costs $0 when idle.
* Absorbed Dr. Werner Vogels' core axiom 'Everything fails, all the time'—reinforcing our ReLoop asynchronous event decoupling, idempotency, and optimistic concurrency decisions.
* Adopted FinOps insights from the AI Day Hanoi Watch Party: selecting the right architecture and cost envelope is far more important than blindly picking the newest tools.

### **Environment Setup & Configuration**

* Configured AI_MODEL_ID=apac.amazon.nova-pro-v1:0 with temperature: 0 and maxTokens: 2048.
* Established Converse API Tool Use to lock AI responses into our exact TypeScript AiResult schema.

### **Practical Skills & Operations**

* Tested Nova Pro on a Dell Latitude 5490 sticker photo and confirmed it extracted valid JSON matching our schema on the first try.
* Attended Event 2 full-day watch party and Event 3 executive fireside keynote at Bitexco Financial Tower.
