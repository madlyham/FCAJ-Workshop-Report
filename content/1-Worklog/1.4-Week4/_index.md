---
title: "Week 4 Worklog"
date: 2026-11-07
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

# **Week 4 Worklog — ReLoop Architecture, Proposal Part 1 & Start of Development**

## **1. Weekly Objectives**

* Finalize the system architecture: one Lambda behind an HTTP API, with small adapters for each AWS service.
* Design every DynamoDB access pattern on paper before any code is written.
* Finish the cost and feasibility check and submit Proposal Part 1.
* Start ReLoop development on Friday: core table, image bucket, Cognito sign-in, and the React frontend.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Architecture review: single Lambda + HTTP API, adapters (`Table`, `ImageStore`, `Analyzer`, `AuthProvider`) so the same code can later run locally with in-memory fakes | 05/10/2026 | 05/10/2026 | [AWS Lambda Docs](https://docs.aws.amazon.com/lambda/), [Amazon API Gateway Docs](https://docs.aws.amazon.com/apigateway/) |
| **Tuesday** | • Design all DynamoDB access patterns on paper: PK/SK and GSI1 key patterns (`USER#`, `LISTING#`, `QUOTE#`, `TXN#`…); rule: no table scans | 06/10/2026 | 06/10/2026 | [Amazon DynamoDB Docs](https://docs.aws.amazon.com/dynamodb/) |
| **Wednesday** | • Cost and feasibility check: drop bank top-up/withdrawal in favor of payment at handover, choose `arm64` Lambda, On-Demand DynamoDB; draft the proposal | 07/10/2026 | 07/10/2026 | [AWS Pricing Calculator](https://calculator.aws/), [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) |
| **Thursday** | • Finish and submit **Proposal Part 1** (problem, architecture, access patterns, cost estimate, timeline) | 08/10/2026 | 08/10/2026 | [Proposal](../../2-proposal/) |
| **Friday** | • **ReLoop development starts:** write `backend/src/store/keys.ts` from the access-pattern sheet; create `reloop-core-table` (On-Demand, PITR) and the `reloop-device-images` bucket; configure the Cognito user pool with email verification, all 4 groups (`Admins`, `FinanceAdmins`, `Partners`, `Owners`), a Post-confirmation Lambda trigger writing `USER#sub` / `PROFILE`, and a JWT authorizer on private routes; scaffold the Vite + React `reloop-ui` app with the Cognito client SDK; test sign-up → verify email → sign-in | 09/10/2026 | 09/10/2026 | [Amazon Cognito Docs](https://docs.aws.amazon.com/cognito/), [Amazon S3 Docs](https://docs.aws.amazon.com/s3/), [ReLoop Repository](https://github.com/madlyham/ReLoop) |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned how the adapter pattern keeps business logic independent of AWS, so tests run without an AWS bill.
* Understood how a Cognito JWT carries the user ID and groups that API Gateway validates on every private route.

### **Environment Setup & Configuration**

* Proposal Part 1 submitted on 08/10/2026.
* From 09/10/2026: `reloop-core-table` (On-Demand, PITR) and `reloop-device-images` bucket (private) in `ap-southeast-1`.
* Cognito user pool with email verification, all 4 user groups (`Admins`, `FinanceAdmins`, `Partners`, `Owners`), Post-confirmation Lambda trigger, and a JWT authorizer on the HTTP API.

### **Practical Skills & Operations**

* Listed every access pattern before writing any query code, then turned the list into `keys.ts` on day one of development.
* Demonstrated the first working sign-up and sign-in on the React app to the team at the end of the first development day.
