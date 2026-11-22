---
title: "Week 7 Worklog"
date: 2026-11-07
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

# **Week 7 Worklog — New UI, Prompt-Injection Defense, Switch to Kimi K3 & Smart Plushies Community**

## **1. Weekly Objectives**

* Rebuild the UI from the Product Owner's designs: public market, partner portal, and Admin portal.
* Stop malicious text inside photos from steering the AI (prompt injection).
* Fix poor Vietnamese output from the AI; attend Event 5 (Smart Plushies with Operation Smile Vietnam).

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Participate in [Event 5: Smart Plushies for Children – In Collaboration with Operation Smile Vietnam](../../4-eventparticipated/4.5-event5/) (01:30 PM – 03:30 PM at AWS Vietnam Office, EC2 Room, Level 36, Bitexco). Hands-on assembly and programming of interactive IoT plushies for pediatric patients. Start the new UI from the Product Owner's designs. | 26/10/2026 | 26/10/2026 | [Event 5](../../4-eventparticipated/4.5-event5/), [ReLoop Repository](https://github.com/madlyham/ReLoop) |
| **Tuesday** | • Rekognition `DetectText` reads text in photos; Bedrock Guardrail (`PROMPT_ATTACK`, `HIGH`) screens it; `textScreener` (12-character threshold) flags listings to `IMGFLAG` / `REVIEWQ#LISTING` for Admin review | 27/10/2026 | 27/10/2026 | [Amazon Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html), [Amazon Rekognition Docs](https://docs.aws.amazon.com/rekognition/) |
| **Wednesday** | • Benchmark on real device photos: Nova Pro's Vietnamese output is poor; switch AI to Kimi K3 on Bedrock (28/10/2026). Same day, two machines deployed different code to the same Lambda, which showed why one single deploy workflow is needed | 28/10/2026 | 28/10/2026 | [Amazon Bedrock Docs](https://docs.aws.amazon.com/bedrock/), [AWS Lambda Docs](https://docs.aws.amazon.com/lambda/) |
| **Thursday** | • Vietnamese electronics glossary; split AI output into `observedTextAndLabels` and `identifiedComponents`; fix the Vietnamese diacritics bug found in red-team testing | 29/10/2026 | 29/10/2026 | [Amazon Bedrock Docs](https://docs.aws.amazon.com/bedrock/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`analyzer.ts`) |
| **Friday** | • Ship the new UI (public market, two-tier partner portal, Admin portal); re-run the AI benchmark: accuracy on our test set rose from about 40% to 92% | 30/10/2026 | 30/10/2026 | [Amazon CloudFront Docs](https://docs.aws.amazon.com/cloudfront/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`reloop-ui`) |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned that text inside an image is also user input and can carry prompt-injection attacks.
* Learned to choose a model by measured results on our own data, not by brand.

### **Environment Setup & Configuration**

* Bedrock Guardrail (`PROMPT_ATTACK HIGH`) applied to AI input/output and to text detected in photos.
* AI model switched to Kimi K3 on Bedrock in `ap-southeast-1`, still using Converse with forced tool choice.

### **Practical Skills & Operations**

* Red-teamed the AI with photos containing hidden instructions; flagged listings now wait for Admin review.
* Volunteered at the Smart Plushies event, assembling IoT plushies for children with Operation Smile Vietnam.
