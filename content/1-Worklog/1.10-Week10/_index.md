---
title: "Week 10 Worklog"
date: 2026-11-07
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

# **Week 10 Work Log: Hardware Benchmarking, Vietnamese Electronics Glossary & AI Quota**

## **1. Weekly Objectives**

* Benchmark AI classification accuracy on real unedited Vietnamese hardware photos.
* Build an embedded Vietnamese electronics dictionary and two-pass component identification schema.
* Implement multi-provider fallback (Google Gemini 2.5 Flash) and per-user daily AI quota limits.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Test real unedited posts on dev and document Nova Pro's broken Vietnamese terminology | 10/12/2026 | 10/12/2026 | Dev Feed Inspection |
| **Day 3** | • Add observedTextAndLabels and identifiedComponents to tool schema so AI lists parts before guessing full category | 10/13/2026 | 10/13/2026 | analyzer.ts |
| **Day 4** | • Inject UTF-8 Vietnamese electronics vocabulary into system prompt + add regex cleanup in validateResult() | 10/14/2026 | 10/14/2026 | analyzer.ts |
| **Day 5** | • Build GeminiAnalyzer + FallbackAnalyzer using free Google AI Studio (gemini-2.5-flash) with Bedrock fallback | 10/15/2026 | 10/15/2026 | analyzer.ts & app.ts |
| **Day 6** | • Enforce AI_DAILY_LIMIT = 20 per user/day (AIQUOTA#<day>) and save { aiSuggested, userFinal } under AILABEL#<YYYY-MM> | 10/16/2026 | 10/16/2026 | aiService.ts & keys.ts |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned that multi-step CoT reasoning (listing components first before predicting top-level category) drastically reduces classification hallucinations.
* Designed multi-cloud resilience: if AWS Bedrock throttles, gracefully fall back to Gemini Flash without user disruption.

### **Environment Setup & Configuration**

* Integrated optional GEMINI_API_KEY environment variable with 100% Vitest suite compatibility.
* Created DynamoDB AI quota tracking item with 24-hour TTL.

### **Practical Skills & Operations**

* Boosted Vietnamese electronics classification accuracy from 40% to 92% across test fixtures.
* Enforced 20 request/user/day hard cap to protect AWS credit limits.
