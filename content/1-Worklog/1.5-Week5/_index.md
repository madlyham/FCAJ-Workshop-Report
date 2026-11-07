---
title: "Week 5 Worklog"
date: 2026-11-07
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

# **Week 5 Work Log: ReLoop Capstone Kickoff, System Architecture & Single-Table Keys**

## **1. Weekly Objectives**

* Kick off the ReLoop circular economy capstone project with the 5-member team.
* Review specification requirements, resolve architectural gaps, and define clear business roles.
* Design the foundational DynamoDB single-table access patterns for users, listings, quotes, and transactions.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Review original ReLoop spec with 5-person team and list out 58 spec gaps | 09/07/2026 | 09/07/2026 | ReLoop Spec & Team Notes |
| **Day 3** | • Lock in business rules: Viewer, Partner Tier 1 (sellers), Partner Tier 2 (collectors within 5km), and Admin | 09/08/2026 | 09/08/2026 | plan/quyetdinh.txt |
| **Day 4** | • Design single-table key structure (keys.ts) for Users, Partners, Listings, Quotes, Transactions, and AI Labels | 09/09/2026 | 09/09/2026 | backend/src/store/keys.ts |
| **Day 5** | • Provision reloop-core-table (On-Demand) and reloop-device-images S3 bucket in Singapore | 09/10/2026 | 09/10/2026 | AWS Console / CLI |
| **Day 6** | • Split 12-week workload across 5 team members and take charge of the #3 BE-AI & Technical Docs track | 09/11/2026 | 09/11/2026 | Team Work Plan |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Transformed relational multi-table mindset into a unified single-table DynamoDB architecture using partition key overloading.
* Defined strict state machines for hardware recycling transactions.

### **Environment Setup & Configuration**

* Created Singapore (ap-southeast-1) DynamoDB core table and private asset bucket.
* Established unified Git repository structure and team branch conventions.

### **Practical Skills & Operations**

* Documented all 30+ DynamoDB PK/SK key structures in keys.ts.
* Validated key partition queries using mock data fixtures.
