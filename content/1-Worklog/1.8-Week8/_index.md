---
title: "Week 8 Worklog"
date: 2026-11-07
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

# **Week 8 Work Log: Multimodal AI Evaluation with Amazon Nova Pro & Bedrock Converse API**

## **1. Weekly Objectives**

* Compare AI model options (SageMaker, Rekognition Custom Labels, Claude Haiku, Amazon Nova Pro) to see what works with our AWS Credits.
* Build the async device classification adapter (BedrockAnalyzer) using Amazon Nova Pro.
* Force the LLM to output strict JSON tags using the Bedrock Converse API tool schema instead of free-text paragraphs.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Check Billing and Cost Management -> Credits -> Applicable products to verify AI coverage | 09/29/2025 | 09/29/2025 | AWS Billing Console |
| **Day 3** | • Drop SageMaker and Custom Labels—both charge hourly and require extensive training data | 09/30/2025 | 09/30/2025 | Team AI Review |
| **Day 4** | • Switch to Amazon Nova Pro (apac.amazon.nova-pro-v1:0): Amazon 1st-party model covered by credits, billed per token | 10/01/2025 | 10/01/2025 | Amazon Bedrock Docs |
| **Day 5** | • Implement BedrockAnalyzer using Converse API with forced toolChoice: 'record_device_analysis' | 10/02/2025 | 10/02/2025 | analyzer.ts |
| **Day 6** | • Wire async background execution (InvocationType=Event self-invoke) and test on real laptop photos | 10/03/2025 | 10/03/2025 | aiService.ts |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned why 3rd-party models like Claude Haiku bill through Marketplace (bypassing promotional credits), while Amazon Nova Pro deducts cleanly from AWS credits and costs $0 when idle.
* Used Converse API Tool Use to lock AI responses into our exact TypeScript AiResult schema.

### **Environment Setup & Configuration**

* Configured AI_MODEL_ID=apac.amazon.nova-pro-v1:0 with temperature: 0 and maxTokens: 2048.

### **Practical Skills & Operations**

* Tested Nova Pro on a Dell Latitude 5490 sticker photo and confirmed it extracted valid JSON matching our schema on the first try.
