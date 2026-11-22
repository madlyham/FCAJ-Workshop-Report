---
title: "Week 3 Worklog"
date: 2026-11-07
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

# **Week 3 Worklog — ReLoop Specification, 45 Business Decisions, AI Day Watch Party & Dr. Werner Vogels Fireside**

## **1. Weekly Objectives**

* Turn the ReLoop specification v1.0 into clear, written business decisions.
* Agree on the team's ways of working (roles, deploy rules, AWS access) and prepare an empty repository + CI for development in Week 4.
* Attend Event 2 (AWS Cloud and AI Day Hanoi Watch Party) and Event 3 (Fireside Chat with Dr. Werner Vogels).

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Monday** | • Read the 1,189-paragraph specification v1.0 end to end; list 58 spec gaps and open questions | 28/09/2026 | 28/09/2026 | ReLoop Spec v1.0 |
| **Tuesday** | • Attend [Event 2: AWS Cloud and AI Day Hanoi – Watch Party](../../4-eventparticipated/4.2-event2/) (08:00 AM – 05:00 PM at AWS Vietnam Office, Bitexco Level 26). Deep-dive into enterprise AI agents, platform engineering, and FinOps cloud cost optimization. | 29/09/2026 | 29/09/2026 | Event 2 / AWS Vietnam Office |
| **Wednesday** | • Define the user roles (Guest, Partner tier 1, Partner tier 2, Admin, Finance Admin) and resolve the spec gaps with the team | 30/09/2026 | 30/09/2026 | Team workshop |
| **Thursday** | • Write the 45 business decisions (QĐ-01 → QĐ-45); create the empty Git repository and a GitHub Actions CI template (typecheck + tests on every pull request), ready for development | 01/10/2026 | 01/10/2026 | Decision log, GitHub Actions |
| **Friday** | • Attend [Event 3: Fireside Chat with Dr. Werner – Navigating the Future of Cloud & AI in Vietnam](../../4-eventparticipated/4.3-event3/) (10:30 AM – 12:00 PM at Bitexco Financial Tower; keynote by Dr. Werner Vogels, CTO of Amazon). Agree on the 5-person work split (my role: Team Lead — also contributing to backend AI, Terraform infrastructure, and technical docs) and the deploy rules: one deploy workflow and one IAM user per member. | 02/10/2026 | 02/10/2026 | Event 3 / Amazon Keynote |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned that writing decisions down (with an ID like QĐ-07) ends repeated debates and makes later code reviews faster.
* Absorbed Dr. Werner Vogels' axiom "Everything fails, all the time", which shaped our choices for async jobs, idempotency, and conditional writes.
* Adopted the FinOps message from AI Day: pick the right architecture and cost envelope before picking the newest tools.

### **Environment Setup & Configuration**

* Empty Git repository with branch protection and a GitHub Actions workflow for typecheck and tests (no app code yet).
* Shared decision log (QĐ-01 → QĐ-45) and a list of 58 resolved or parked spec gaps.

### **Practical Skills & Operations**

* Ran a spec-gap review with the team and turned open questions into decisions in one week.
* Attended the full-day AI Day watch party and the Dr. Werner Vogels fireside keynote at Bitexco Financial Tower.
