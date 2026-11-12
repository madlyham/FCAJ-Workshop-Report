---
title: "Week 4 Worklog"
date: 2026-11-07
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

# **Week 4 Work Log: ReLoop Architecture, Single-Table Keys & Cognito Sign-in with React/Amplify**

## **1. Weekly Objectives**

* Fix the system architecture: one Lambda behind an HTTP API, with small adapters for each AWS service.
* Design every DynamoDB access pattern up front in one keys file.
* Get sign-up / sign-in working end to end with Cognito and a React front end.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Architecture review: single Lambda + HTTP API, adapters (Table, ImageStore, Analyzer, AuthProvider) so the same code runs locally with in-memory fakes | 10/05/2026 | 10/05/2026 | Architecture notes |
| **Day 3** | • Write backend/src/store/keys.ts: all PK/SK and GSI1 key patterns (USER#, LISTING#, QUOTE#, TXN#…); no table scans allowed | 10/06/2026 | 10/06/2026 | keys.ts |
| **Day 4** | • Create reloop-core-table (On-Demand, PITR) and the reloop-device-images bucket; cost check: drop bank top-up/withdrawal in favour of payment at hand-over, choose arm64 Lambda | 10/07/2026 | 10/07/2026 | DynamoDB / S3 Console |
| **Day 5** | • Cognito user pool with email verification and groups (Admins, FinanceAdmins, Partners); sign-up trigger writes USER#sub / PROFILE; JWT authorizer on private routes | 10/08/2026 | 10/08/2026 | Amazon Cognito Docs |
| **Day 6** | • Scaffold the Vite + React reloop-ui app, wire Amplify Authenticator, emerald theme; test the full sign-up → verify email → sign-in flow | 10/09/2026 | 10/09/2026 | reloop-ui |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned how the adapter pattern keeps business logic independent of AWS, so tests run without an AWS bill.
* Understood how a Cognito JWT carries the user ID and groups that API Gateway checks on every private route.

### **Environment Setup & Configuration**

* reloop-core-table (On-Demand, PITR) and reloop-device-images bucket (private) in ap-southeast-1.
* Cognito user pool with email verification, user groups and a JWT authorizer on the HTTP API.

### **Practical Skills & Operations**

* Listed every access pattern in keys.ts before writing any query code.
* Demonstrated the first working sign-up and sign-in on the React app to the team.
