---
title: "Week 9 Worklog"
date: 2026-11-07
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

# **Week 9 Work Log: Visual Prompt Injection Defense with OCR & Bedrock Guardrails**

## **1. Weekly Objectives**

* Stop visual prompt injection attacks (users putting sticky notes in photos instructing AI to misclassify items).
* Build the OCR + Guardrail screening pipeline in backend/src/storage/textScreener.ts.
* Hold listings with flagged images in PENDING_REVIEW so an Admin approves them first.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Design 2-step text screener: Rekognition DetectText reads image text -> Bedrock Guardrail checks for prompt attacks | 10/06/2025 | 10/06/2025 | AWS Rekognition & Bedrock |
| **Day 3** | • Configure aws_bedrock_guardrail.ai (PROMPT_ATTACK = HIGH) in infra/ai.tf | 10/07/2025 | 10/07/2025 | infra/ai.tf |
| **Day 4** | • Write RekognitionGuardrailScreener (skip Guardrail if text < 12 characters to let brand logos pass) | 10/08/2025 | 10/08/2025 | textScreener.ts |
| **Day 5** | • Save IMGFLAG#<imageKey> in DynamoDB when flagged and route listing to REVIEWQ#LISTING (PENDING_REVIEW) | 10/09/2025 | 10/09/2025 | listingService.ts |
| **Day 6** | • Red-team live deployment: caught English attacks; identified bug where Rekognition misreads Vietnamese diacritics | 10/10/2025 | 10/10/2025 | Live AWS Dev Test |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Discovered a real security edge case: Rekognition.DetectText struggles with Vietnamese diacritics, turning accented attack sentences into broken ASCII that slipped past Bedrock Guardrails.
* Designed an unaccented Vietnamese keyword check (bo qua huong dan, system prompt, ignore previous) to patch that OCR blindspot.

### **Environment Setup & Configuration**

* Enabled AI_GUARDRAIL_ID and AI_GUARDRAIL_VERSION on Lambda and added ImagesTextFlagged CloudWatch metric.

### **Practical Skills & Operations**

* Verified end-to-end that uploading an image with printed attack instructions flags the upload, routes to PENDING_REVIEW, and presents extracted OCR text to Admin.
