---
title: "Week 4 Worklog"
date: 2026-11-07
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

## **Week 4 Worklog — ReLoop Architecture, Proposal Part 1 & Start of Development**

## **1. Weekly Objectives**

* Finalize the system architecture: one Lambda behind an HTTP API, with small adapters for each AWS service.
* Design every DynamoDB access pattern on paper before any code is written.
* Finish the cost and feasibility check and submit Proposal Part 1.
* Start ReLoop development on Friday: core table, image bucket, Cognito sign-in, and the React frontend.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Completed architecture review: single Lambda + HTTP API, with adapters (`Table`, `ImageStore`, `Analyzer`, `AuthProvider`) so the same code could later run locally with in-memory fakes | 05/10/2026 | 05/10/2026 | [AWS Lambda Docs](https://docs.aws.amazon.com/lambda/), [Amazon API Gateway Docs](https://docs.aws.amazon.com/apigateway/) |
| **Tuesday** | • Designed all DynamoDB access patterns on paper: PK/SK and GSI1 key patterns (`USER#`, `LISTING#`, `QUOTE#`, `TXN#`…), enforcing a zero table-scan rule | 06/10/2026 | 06/10/2026 | [Amazon DynamoDB Docs](https://docs.aws.amazon.com/dynamodb/) |
| **Wednesday** | • Completed cost and feasibility check: dropped bank top-up/withdrawal in favor of payment at handover, chose `arm64` Lambda and On-Demand DynamoDB, and drafted the proposal | 07/10/2026 | 07/10/2026 | [AWS Pricing Calculator](https://calculator.aws/), [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) |
| **Thursday** | • Finished and submitted **Proposal Part 1** (problem, architecture, access patterns, cost estimate, timeline) | 08/10/2026 | 08/10/2026 | [Proposal](../../2-proposal/) |
| **Friday** | • **Started ReLoop development:** wrote `backend/src/store/keys.ts` from the access-pattern sheet; created `reloop-core-table` (On-Demand, PITR) and the `reloop-device-images` bucket; configured the Cognito user pool with email verification, all 4 groups (`Admins`, `FinanceAdmins`, `Partners`, `Owners`), a Post-confirmation Lambda trigger writing `USER#sub` / `PROFILE`, and an HTTP API JWT authorizer on private routes; scaffolded the Vite + React `reloop-ui` app with the Cognito client SDK and tested sign-up → verify email → sign-in | 09/10/2026 | 09/10/2026 | [Amazon Cognito Docs](https://docs.aws.amazon.com/cognito/), [Amazon S3 Docs](https://docs.aws.amazon.com/s3/), [ReLoop Repository](https://github.com/madlyham/ReLoop) |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned how the adapter pattern keeps business logic independent of AWS, so tests run without an AWS bill.
* Understood the split between authentication and authorization: API Gateway HTTP API's JWT authorizer validates the Cognito token signature (via JWKS), issuer, audience, and expiry on every private route, while Lambda application code inspects `cognito:groups` claims (`Admins` / `FinanceAdmins`) and DynamoDB role records to enforce authorization.

### **Environment Setup & Configuration**

* Proposal Part 1 submitted on 08/10/2026.
* From 09/10/2026: `reloop-core-table` (On-Demand, PITR) and `reloop-device-images` bucket (private) in `ap-southeast-1`.
* Cognito user pool with email verification, all 4 user groups (`Admins`, `FinanceAdmins`, `Partners`, `Owners`), Post-confirmation Lambda trigger, and a JWT authorizer on the HTTP API.

### **Practical Skills & Operations**

* Listed every access pattern before writing any query code, then turned the list into `keys.ts` on day one of development.
* Demonstrated the first working sign-up and sign-in on the React app to the team at the end of the first development day.
