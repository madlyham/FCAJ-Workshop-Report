---
title: "Week 9 Worklog"
date: 2026-11-07
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

# **Week 9 Work Log: Visual Prompt Injection Defense with OCR & Bedrock Guardrails**

## **1. Weekly Objectives**

* Protect the AI pipeline against visual prompt injection (adversarial text written on hardware labels).
* Build a 2-tier screening defense: Rekognition DetectText OCR followed by Amazon Bedrock Guardrails.
* Route suspicious flagged listings to a manual human review queue (REVIEWQ#LISTING) without crashing.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Design 2-step text screener: Rekognition DetectText reads image text -> Bedrock Guardrail checks for prompt attacks | 10/05/2026 | 10/05/2026 | AWS Rekognition & Bedrock |
| **Day 3** | • Configure aws_bedrock_guardrail.ai (PROMPT_ATTACK = HIGH) in infra/ai.tf | 10/06/2026 | 10/06/2026 | infra/ai.tf |
| **Day 4** | • Write RekognitionGuardrailScreener (skip Guardrail if text < 12 characters to let brand logos pass) | 10/07/2026 | 10/07/2026 | textScreener.ts |
| **Day 5** | • Save IMGFLAG#<imageKey> in DynamoDB when flagged and route listing to REVIEWQ#LISTING (PENDING_REVIEW) | 10/08/2026 | 10/08/2026 | listingService.ts |
| **Day 6** | • Red-team live deployment: caught English attacks; identified bug where Rekognition misreads Vietnamese diacritics | 10/09/2026 | 10/09/2026 | Live AWS Dev Test |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Understood multimodal threat surfaces: attackers can print malicious instructions on a sticker to trick the vision LLM into declaring a broken device as brand new.
* Designed defense-in-depth: lightweight OCR first, expensive Guardrail second, human fallback third.

### **Environment Setup & Configuration**

* Provisioned aws_bedrock_guardrail with Prompt Attack filter set to HIGH.
* Configured DynamoDB review queue schema.

### **Practical Skills & Operations**

* Tested against synthetic attack images and confirmed the system flags the listing with 100% accuracy.
* Cataloged OCR limitations with Vietnamese tone marks for Week 10 prompt tuning.
