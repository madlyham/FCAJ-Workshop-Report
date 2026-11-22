---
title: "Week 7 Worklog"
date: 2026-11-07
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

## **Week 7 Worklog — New UI, Prompt-Injection Defense, Switch to Kimi K3 & Smart Plushies Community**

## **1. Weekly Objectives**

* Rebuild the UI from the Product Owner's designs: public market, partner portal, and Admin portal.
* Stop malicious text inside photos from steering the AI (prompt injection).
* Fix poor Vietnamese output from the AI; attend Event 5 (Smart Plushies with Operation Smile Vietnam).

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Participated in [Event 5: Smart Plushies for Children – In Collaboration with Operation Smile Vietnam](../../4-eventparticipated/4.5-event5/) (01:30 PM – 03:30 PM at AWS Vietnam Office, EC2 Room, Level 36, Bitexco), assembling teddy-bear gift kits with interactive audio modules for pediatric patients. Started building the new UI from the Product Owner's designs. | 26/10/2026 | 26/10/2026 | [Event 5](../../4-eventparticipated/4.5-event5/), [ReLoop Repository](https://github.com/madlyham/ReLoop) |
| **Tuesday** | • Added Rekognition `DetectText` to extract text in photos, screened that extracted text via Bedrock `ApplyGuardrail` (`PROMPT_ATTACK`, input-only `HIGH`, `output_strength = NONE`) before calling the LLM, and configured `textScreener` (12-character threshold) to flag listings to `IMGFLAG` / `REVIEWQ#LISTING` for Admin review | 27/10/2026 | 27/10/2026 | [Amazon Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html), [Amazon Rekognition Docs](https://docs.aws.amazon.com/rekognition/) |
| **Wednesday** | • Benchmarked on real device photos: Nova Pro's Vietnamese output fell short, so we switched AI to `Kimi K3` (`global.moonshotai.kimi-k3`) on Bedrock (28/10/2026) after verifying pay-per-token billing remained low (~$0.87/month in October) within our remaining credit balance. The same day, two machines deployed different code to the same Lambda, exposing a gap in the manual workflow agreed in Week 3 and triggering the move to CI-enforced deploys | 28/10/2026 | 28/10/2026 | [Amazon Bedrock Docs](https://docs.aws.amazon.com/bedrock/), [AWS Lambda Docs](https://docs.aws.amazon.com/lambda/) |
| **Thursday** | • Added a Vietnamese electronics glossary, split AI output into `observedTextAndLabels` and `identifiedComponents`, and fixed the Vietnamese diacritics bug found in red-team testing | 29/10/2026 | 29/10/2026 | [Amazon Bedrock Docs](https://docs.aws.amazon.com/bedrock/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`analyzer.ts`) |
| **Friday** | • Shipped the new UI (public market, two-tier partner portal, Admin portal) and re-ran the AI benchmark, which substantially improved device-classification accuracy on our internal test photos | 30/10/2026 | 30/10/2026 | [Amazon CloudFront Docs](https://docs.aws.amazon.com/cloudfront/), [ReLoop Repository](https://github.com/madlyham/ReLoop) (`reloop-ui`) |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned that text inside an image is also user input and can carry prompt-injection attacks.
* Learned to choose a model by measured results on our own data, not by brand.

### **Environment Setup & Configuration**

* Bedrock Guardrail (`PROMPT_ATTACK`, input-only `HIGH`, `output_strength = NONE`) applied via `ApplyGuardrail` to Rekognition-extracted photo text before calling Kimi K3.
* AI model switched to `Kimi K3` (`global.moonshotai.kimi-k3`) on Bedrock in `ap-southeast-1`, still using Converse with forced tool choice while keeping pay-per-token spend low (~$0.87/month in October).

### **Practical Skills & Operations**

* Red-teamed the AI with photos containing hidden instructions; flagged listings now wait for Admin review.
* Volunteered at the Smart Plushies event, assembling teddy-bear gift kits with interactive audio modules for pediatric patients with Operation Smile Vietnam.
