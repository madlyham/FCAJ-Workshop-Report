---
title: "Week 12 Worklog"
date: 2026-11-07
weight: 12
chapter: false
pre: " <b> 1.12. </b> "
---

# **Week 12 Work Log: Developer Reference, Smart Plushies Community & Final Rehearsals**

## **1. Weekly Objectives**

* Participate in Event 5 (Smart Plushies for Children with Operation Smile Vietnam) applying embedded IoT and engineering skills toward social impact.
* Clean up project documentation and author a comprehensive English Developer Technical Reference (Man-Page) for the team.
* Run load tests (scripts/loadtest.mjs) and verify optimistic concurrency controls (putVersioned + withOptimisticRetry) under heavy race conditions.
* Write Final Report Section D2 and conduct full dress rehearsals of the end-to-end live demo.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Participate in [Event 5: Smart Plushies for Children – In Collaboration with Operation Smile Vietnam](../../4-eventparticipated/4.5-event5/) (01:30 PM – 03:30 PM at AWS Vietnam Office, EC2 Level 36 Bitexco). Hands-on assembly and programming of interactive IoT plushies for pediatric patients. Extract live AWS configs into standalone RELOOP_TECHNICAL_REFERENCE. | 10/26/2026 | 10/26/2026 | Event 5 / Operation Smile & AWS, RELOOP_TECHNICAL_REFERENCE |
| **Day 3** | • Document all 30+ DynamoDB key patterns (keys.ts), state transitions, AppError codes, and 45+ HTTP API endpoints | 10/27/2026 | 10/27/2026 | Backend Source Code |
| **Day 4** | • Run scripts/loadtest.mjs (50 users, 20 req/s); verify putVersioned + withOptimisticRetry stops double-selected offers | 10/28/2026 | 10/28/2026 | scripts/loadtest.mjs |
| **Day 5** | • Write Final Report Section D2: Nova Pro FinOps rationale, real photo accuracy stats, OCR + Guardrail injection defense | 10/29/2026 | 10/29/2026 | Final Report (D2) |
| **Day 6** | • Run full dress rehearsals of live demo (Partner Tier 1/2 flow, AI tagging, 5km matching, invoice, flagged attack image) and finalize presentation materials | 10/30/2026 | 10/31/2026 | Demo Script |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Tied everything together from basic Week 1 EC2/CLI commands to a full production serverless system with multimodal AI, computer vision security guardrails, optimistic concurrency control, and Infrastructure as Code.
* Experienced technology channeled toward empathetic, human-centric solutions during the Smart Plushies workshop, complementing our technical cloud architecture deliverables.

### **Environment Setup & Configuration**

* Delivered complete English Developer Reference manual so any developer on the team can look up S3 CORS, Cognito pools, DynamoDB keys, and helper signatures in seconds.
* Packaged demo seed data scripts for instant reproducible live presentations.

### **Practical Skills & Operations**

* Confirmed p95 read/write latencies stay well under target during load tests and completed final ReLoop demo rehearsals smoothly.
* Proudly represented AWS FCAJ during the Operation Smile Vietnam social impact initiative.
