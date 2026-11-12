---
title: "Week 8 Worklog"
date: 2026-11-07
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

# **Week 8 Work Log: Background Matching, QA Rounds, WAF & Developer Reference**

## **1. Weekly Objectives**

* Match every new listing to buyer branches nearby, automatically and in the background.
* Find and fix bugs through structured QA rounds and a first load test.
* Protect the site and sign-in with AWS WAF and write the developer reference.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Background matching with geohash + Haversine distance: each listing goes to every approved branch whose service area (1–15 km) covers it; listings within 5 km rank first | 11/02/2026 | 11/02/2026 | matching.ts |
| **Day 3** | • Consolidate 5 QA rounds: 146 findings logged and prioritised (03/11) | 11/03/2026 | 11/03/2026 | QA tracker |
| **Day 4** | • First load test (loadtest.mjs, 80 parallel requests): 26% 5xx at Lambda concurrency 10; request and receive a quota raise to 1,000 | 11/04/2026 | 11/04/2026 | loadtest.mjs, Service Quotas |
| **Day 5** | • AI quota of 20 analyses per user per day (AI_DAILY_LIMIT); store the AI suggestion next to the seller's final value (AILABEL) | 11/05/2026 | 11/05/2026 | aiService.ts |
| **Day 6** | • AWS WAF on CloudFront (managed rules + rate limits) and on the Cognito user pool (login rate limit) (06/11); write RELOOP_TECHNICAL_REFERENCE (30+ key patterns, all API routes) | 11/06/2026 | 11/06/2026 | infra/waf.tf, RELOOP_TECHNICAL_REFERENCE |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned how geohash prefixes narrow the search area so only nearby branches are checked with the exact Haversine distance.
* Understood that the default Lambda concurrency limit on a new account can be the first bottleneck under load.

### **Environment Setup & Configuration**

* Two WAF web ACLs: reloop-dev-web (CloudFront) and reloop-dev-auth (Cognito).
* Lambda concurrency quota raised from 10 to 1,000; AI daily limit set to 20 per user.

### **Practical Skills & Operations**

* Closed the highest-priority QA findings and re-tested the affected flows.
* Wrote the developer reference so new team members can find every key pattern and route in one place.
