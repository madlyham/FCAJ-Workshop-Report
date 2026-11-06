---
title: "Week 5 Worklog"
date: 2026-11-07
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

# **Week 5 Work Log: ReLoop Capstone Kickoff, System Architecture & Single-Table Keys**

## **1. Weekly Objectives**

* Kick off our team capstone project: ReLoop (a circular marketplace for old/broken electronics).
* Lock in the system architecture, user roles, and shared AWS resources in ap-southeast-1.
* Set up reloop-core-table in DynamoDB and reloop-device-images in S3.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Review original ReLoop spec with 5-person team and list out 58 spec gaps (baton.txt) | 09/08/2025 | 09/08/2025 | ReLoop Spec & Team Notes |
| **Day 3** | • Lock in business rules (quyetdinh.txt): Viewer, Partner Tier 1 (sellers), Partner Tier 2 (buyers within 5km), and Admin | 09/09/2025 | 09/09/2025 | plan/quyetdinh.txt |
| **Day 4** | • Design single-table key structure (keys.ts) for Users, Partners, Listings, Quotes, Transactions, and AI Labels | 09/10/2025 | 09/10/2025 | backend/src/store/keys.ts |
| **Day 5** | • Provision reloop-core-table (On-Demand) and reloop-device-images S3 bucket in Singapore | 09/11/2025 | 09/11/2025 | AWS Console / CLI |
| **Day 6** | • Split 12-week workload across 5 team members and take charge of the #3 BE-AI & Technical Docs track | 09/12/2025 | 09/12/2025 | Team Work Plan |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Mapped out how ReLoop works end-to-end: seller uploads photos -> AI suggests tags -> system matches recycling partners within 5km using geohash -> offline handover -> 10,000 VND monthly fee invoice.
* Planned state machines (assertTransition) and version locks (putVersioned) so users cannot glitch transaction states.

### **Environment Setup & Configuration**

* Initialized reloop-core-table with PK/SK + GSI1 (GSI1PK/GSI1SK) and ttl auto-expiry.
* Configured reloop-device-images with private access and CORS headers (PUT, POST, GET).

### **Practical Skills & Operations**

* Helped set team coding rules: no Scan in DynamoDB, all AWS calls wrapped inside adapters (ImageStore, Analyzer), and mandatory Idempotency-Key on create routes.
