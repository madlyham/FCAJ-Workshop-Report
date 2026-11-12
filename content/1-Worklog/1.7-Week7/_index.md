---
title: "Week 7 Worklog"
date: 2026-11-07
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

# **Week 7 Work Log: New UI, Prompt-Injection Defence, Switch to Kimi K3 & Smart Plushies Community**

## **1. Weekly Objectives**

* Rebuild the UI from the product owner's designs: public market, partner portal and Admin portal.
* Stop malicious text inside photos from steering the AI (prompt injection).
* Fix poor Vietnamese output from the AI; attend Event 5 (Smart Plushies with Operation Smile Vietnam).

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Participate in [Event 5: Smart Plushies for Children – In Collaboration with Operation Smile Vietnam](../../4-eventparticipated/4.5-event5/) (01:30 PM – 03:30 PM at AWS Vietnam Office, EC2 Level 36 Bitexco). Hands-on assembly and programming of interactive IoT plushies for pediatric patients. Start the new UI from the product owner's designs. | 10/26/2026 | 10/26/2026 | Event 5 / Operation Smile & AWS |
| **Day 3** | • Rekognition DetectText reads text in photos; Bedrock Guardrail (PROMPT_ATTACK, HIGH) screens it; textScreener (12-character threshold) flags listings to IMGFLAG / REVIEWQ#LISTING for Admin review | 10/27/2026 | 10/27/2026 | Bedrock Guardrails Docs |
| **Day 4** | • Benchmark on real device photos: Nova Pro's Vietnamese output is poor; switch AI to Kimi K3 on Bedrock (28/10). Same day, two machines deployed different code to the same Lambda, which showed why one deploy path is needed | 10/28/2026 | 10/28/2026 | AI benchmark sheet |
| **Day 5** | • Vietnamese electronics glossary; split AI output into observedTextAndLabels and identifiedComponents; fix the Vietnamese diacritics bug found in red-team testing | 10/29/2026 | 10/29/2026 | Glossary, analyzer.ts |
| **Day 6** | • Ship the new UI (public market, two-tier partner portal, Admin portal); re-run the AI benchmark: accuracy on our test set rose from about 40% to 92% | 10/30/2026 | 10/30/2026 | reloop-ui, AI benchmark |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned that text inside an image is also user input and can carry prompt-injection attacks.
* Learned to choose a model by measured results on our own data, not by brand.

### **Environment Setup & Configuration**

* Guardrail (PROMPT_ATTACK HIGH) applied to AI input/output and to text found in photos.
* AI model switched to Kimi K3 on Bedrock, still using Converse with forced tool choice.

### **Practical Skills & Operations**

* Red-teamed the AI with photos containing hidden instructions; flagged listings now wait for Admin review.
* Volunteered at the Smart Plushies event, assembling IoT plushies for children with Operation Smile Vietnam.
