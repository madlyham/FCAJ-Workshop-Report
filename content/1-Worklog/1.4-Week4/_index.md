---
title: "Week 4 Worklog"
date: 2026-11-07
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

# **Week 4 Work Log: ReLoop Architecture, Proposal Part 1 & Start of Development**

## **1. Weekly Objectives**

* Fix the system architecture: one Lambda behind an HTTP API, with small adapters for each AWS service.
* Design every DynamoDB access pattern on paper before any code is written.
* Finish the cost and feasibility check and submit Proposal Part 1.
* Start ReLoop development on Friday: core table, image bucket, Cognito sign-in and the React front end.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Architecture review: single Lambda + HTTP API, adapters (Table, ImageStore, Analyzer, AuthProvider) so the same code can later run locally with in-memory fakes | 10/05/2026 | 10/05/2026 | Architecture notes |
| **Day 3** | • Design all DynamoDB access patterns on paper: PK/SK and GSI1 key patterns (USER#, LISTING#, QUOTE#, TXN#…); rule: no table scans | 10/06/2026 | 10/06/2026 | Access-pattern sheet |
| **Day 4** | • Cost and feasibility check: drop bank top-up/withdrawal in favour of payment at hand-over, choose arm64 Lambda, On-Demand DynamoDB; draft the proposal | 10/07/2026 | 10/07/2026 | AWS Pricing Calculator |
| **Day 5** | • Finish and submit **Proposal Part 1** (problem, architecture, access patterns, cost estimate, timeline) | 10/08/2026 | 10/08/2026 | [Proposal](../../2-proposal/) |
| **Day 6** | • **ReLoop development starts:** write backend/src/store/keys.ts from the access-pattern sheet; create reloop-core-table (On-Demand, PITR) and the reloop-device-images bucket; Cognito user pool with email verification, groups (Admins, FinanceAdmins, Partners), sign-up trigger writing USER#sub / PROFILE and a JWT authorizer on private routes; scaffold the Vite + React reloop-ui app with Amplify Authenticator; test sign-up → verify email → sign-in | 10/09/2026 | 10/09/2026 | Amazon Cognito Docs, reloop-ui |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned how the adapter pattern keeps business logic independent of AWS, so tests run without an AWS bill.
* Understood how a Cognito JWT carries the user ID and groups that API Gateway checks on every private route.

### **Environment Setup & Configuration**

* Proposal Part 1 submitted on 10/08/2026.
* From 10/09/2026: reloop-core-table (On-Demand, PITR) and reloop-device-images bucket (private) in ap-southeast-1.
* Cognito user pool with email verification, user groups and a JWT authorizer on the HTTP API.

### **Practical Skills & Operations**

* Listed every access pattern before writing any query code, then turned the list into keys.ts on day one of development.
* Demonstrated the first working sign-up and sign-in on the React app to the team at the end of the first development day.
