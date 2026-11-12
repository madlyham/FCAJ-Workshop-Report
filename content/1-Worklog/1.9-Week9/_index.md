---
title: "Week 9 Worklog"
date: 2026-11-07
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

# **Week 9 Work Log: Pentest with AWS Security Agent, Fixes, CSP, SES Email & Budgets**

## **1. Weekly Objectives**

* Review the automated pentest results and fix every fixable finding.
* Enforce a strict Content-Security-Policy on the web app.
* Remove the Cognito email limit with Amazon SES and add budget alerts.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Review the AWS Security Agent black-box pentest of the dev site (run the week of 09/11; 3.63 task-hours): 7 findings, none high | 11/09/2026 | 11/09/2026 | AWS Security Agent report |
| **Day 3** | • Fix and deploy the findings (security headers, error messages, input checks); re-run the smoke test | 11/10/2026 | 11/10/2026 | Fix PRs, smoke-aws.py |
| **Day 4** | • Move the Content-Security-Policy from report-only to enforced on CloudFront; check every page for blocked resources | 11/11/2026 | 11/11/2026 | infra/web.tf |
| **Day 5** | • Switch Cognito email to Amazon SES so sign-ups are not blocked by the default limit (~50 emails/day) | 11/12/2026 | 11/12/2026 | Amazon SES Docs |
| **Day 6** | • AWS Budgets alerts at 50% / 80% of the remaining credits; review credit balance and cost per service | 11/13/2026 | 11/13/2026 | AWS Billing Console |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned how an automated black-box pentest finds issues from the outside, the same way an attacker would.
* Understood why a CSP should run in report-only mode first, then be enforced once no real page breaks.

### **Environment Setup & Configuration**

* Strict CSP, HSTS and X-Frame-Options headers enforced on CloudFront.
* Cognito sending email through Amazon SES; AWS Budgets alerts at 50% / 80%.

### **Practical Skills & Operations**

* Closed all fixable pentest findings and confirmed them with a re-test.
* Kept the pentest within budget by stopping it at about 3.5 task-hours.
