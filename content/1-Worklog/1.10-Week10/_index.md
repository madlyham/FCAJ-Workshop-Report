---
title: "Week 10 Worklog"
date: 2026-11-07
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

# **Week 10 Work Log: Load Test, Throttling Fix, Single Deploy Path & Production Environment**

## **1. Weekly Objectives**

* Prove the system handles bursts gracefully after the concurrency raise.
* Move all deploys to one CI/CD path with one IAM user per member.
* Create the production environment from the same Terraform code.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Re-run loadtest.mjs (80 parallel requests) against the earlier baseline of 26% 5xx; with concurrency 1,000 the 5xx errors are gone | 11/16/2026 | 11/16/2026 | loadtest.mjs |
| **Day 3** | • Throttling fix: API Gateway throttle 20 requests/s with burst 50; WAF rate limits and API return 429 with Retry-After instead of failing | 11/17/2026 | 11/17/2026 | API Gateway Docs |
| **Day 4** | • Single CI/CD deploy path in GitHub Actions from a committed revision; one IAM user per team member; plan removal of root access keys | 11/18/2026 | 11/18/2026 | GitHub Actions, IAM |
| **Day 5** | • Create the production stack from the same Terraform modules with separate variables | 11/19/2026 | 11/19/2026 | infra/*.tf |
| **Day 6** | • Run the smoke test on production and fix the last environment-specific issues | 11/20/2026 | 11/20/2026 | smoke-aws.py |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned the difference between failing under load (5xx) and pushing back politely (429 + Retry-After).
* Understood why one deploy path from a committed revision prevents two machines from overwriting each other.

### **Environment Setup & Configuration**

* API Gateway throttle 20/s, burst 50; WAF rate limits returning 429.
* Production stack built from the same Terraform modules as dev.

### **Practical Skills & Operations**

* Compared load-test results before and after the fix and recorded them for the final report.
* Deployed through CI only, with no manual deploys from laptops.
