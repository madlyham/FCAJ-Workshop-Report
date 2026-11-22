---
title: "Week 9 Worklog"
date: 2026-11-22
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

# **Week 9 Worklog — Security Review, Hardening Fixes, Proposal Part 2 & Cloud Mastery Event**

## **1. Weekly Objectives**

* Conduct an end-to-end security review of IAM roles, Cognito JWT authorization, CloudFront `x-origin-verify` origin locking, and CloudFront WAF rules.
* Implement and deploy hardening fixes, then re-verify the live stack with the smoke test.
* Review live AWS Cost Explorer spend against remaining AWS credits and submit Proposal Part 2.
* Attend Event 6 (Cloud Mastery) at the AWS Vietnam Office.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Security review across least-privilege IAM policies, Cognito JWT claims and 4-group RBAC (`Admins`, `FinanceAdmins`, `Partners`, `Owners`), and DynamoDB ownership conditions | 09/11/2026 | 09/11/2026 | `infra/*.tf`, `backend/src/` |
| **Tuesday** | • Audit CloudFront-to-API Gateway `x-origin-verify` shared-header enforcement (blocking direct origin bypasses) and verify the single CloudFront WAF web ACL (3 AWS managed rule groups + 2 per-IP rate limits) | 10/11/2026 | 10/11/2026 | `infra/waf.tf`, `infra/web.tf` |
| **Wednesday** | • Implement and deploy hardening fixes (strict ownership/role guards, sanitized error payloads, tighter input validation); re-run `smoke-aws.py` to confirm zero regressions | 11/11/2026 | 11/11/2026 | Fix PRs, `smoke-aws.py` |
| **Thursday** | • Review per-service spend in AWS Cost Explorer against our AWS credit balance and confirm the 12-service (+ IAM) stack tracks at ~$11.70/month ($10.00 CloudFront WAF + ~$1.70 usage) | 12/11/2026 | 12/11/2026 | AWS Cost Explorer |
| **Friday** | • Finalize and submit **Proposal Part 2**: updated architecture (12 managed AWS services + IAM), real Cost Explorer breakdown, and security hardening verification results | 13/11/2026 | 13/11/2026 | [Proposal](../../2-proposal/) |
| **Saturday** | • Attend [Event 6: Cloud Mastery – Cloud Sharing Session for Students](../../4-eventparticipated/4.6-event6/) (morning, AWS Vietnam Office). Extended open Q&A with students on cloud careers and skills, followed by a live Quiz.com game | 14/11/2026 | 14/11/2026 | [Event 6](../../4-eventparticipated/4.6-event6/) |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned how defense-in-depth layers edge filtering (CloudFront + WAF), origin locking (`x-origin-verify`), JWT group authorization, and DynamoDB conditional expressions.
* Understood how to cross-check live Cost Explorer figures against design estimates before finalizing a project proposal.

### **Environment Setup & Configuration**

* Least-privilege IAM policies, Cognito 4-group JWT checks, `x-origin-verify` origin locking, and CloudFront WAF rules verified on the live stack.
* Proposal Part 2 submitted on 13/11/2026 with live Cost Explorer figures.

### **Practical Skills & Operations**

* Deployed all security hardening fixes and passed end-to-end smoke verification without regressions.
* Confirmed the monthly run-rate (~$11.70/month) stays comfortably within remaining AWS credits.
