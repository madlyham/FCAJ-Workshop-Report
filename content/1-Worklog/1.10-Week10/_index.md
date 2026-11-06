---
title: "Week 10 Worklog"
date: 2026-11-07
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

# **Week 10 Work Log: Hardware Benchmarking, Vietnamese Electronics Glossary & AI Quota**

## **1. Weekly Objectives**

* Evaluate Nova Pro on our own real hardware photos (ESP32 IoT rig, Logitech M650 L mouse) and fix broken Vietnamese outputs.
* Add a Vietnamese hardware glossary to prompt, regex cleanup, and Google AI Studio (Gemini Flash) fallback adapter.
* Implement daily user AI quota (AIQUOTA) and human-corrected training dataset logger (AILABEL#<month>).

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Test real unedited posts on dev and document Nova Pro's broken Vietnamese terminology | 10/13/2025 | 10/13/2025 | Dev Feed Inspection |
| **Day 3** | • Add observedTextAndLabels and identifiedComponents to tool schema so AI lists parts before guessing full category | 10/14/2025 | 10/14/2025 | analyzer.ts |
| **Day 4** | • Inject UTF-8 Vietnamese electronics vocabulary into system prompt + add regex cleanup in validateResult() | 10/15/2025 | 10/15/2025 | analyzer.ts |
| **Day 5** | • Build GeminiAnalyzer + FallbackAnalyzer using free Google AI Studio (gemini-2.5-flash) with Bedrock fallback | 10/16/2025 | 10/16/2025 | analyzer.ts & app.ts |
| **Day 6** | • Enforce AI_DAILY_LIMIT = 20 per user/day (AIQUOTA#<day>) and save { aiSuggested, userFinal } under AILABEL#<YYYY-MM> | 10/17/2025 | 10/17/2025 | aiService.ts & keys.ts |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Found that Nova Pro's vision was sharp (reading tiny embossed text on mouse bottoms), but its Vietnamese spelling inside JSON mode broke unless standard hardware terms were placed directly into the prompt.

### **Environment Setup & Configuration**

* Updated analyzer prompt, sanitizer rules, and optional GEMINI_API_KEY environment variable with 100% Vitest suite compatibility.

### **Practical Skills & Operations**

* Turned every user edit on the Create Listing page into a labeled training row (AILABEL#<month>) for future JSONL fine-tuning export.
