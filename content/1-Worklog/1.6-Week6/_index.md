---
title: "Week 6 Worklog"
date: 2026-11-07
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

# **Week 6 Work Log: Authentication with Amazon Cognito & React/Amplify UI Integration**

## **1. Weekly Objectives**

* Set up user login and registration using Amazon Cognito (ReLoop-user-pool).
* Wire the Post-Confirmation Lambda trigger so verified signups automatically create a profile in DynamoDB.
* Build and style the local React + Vite login portal using Amplify UI.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Configure Cognito User Pool and Web/Mobile App Clients (no client secret for browser safety) | 09/15/2025 | 09/15/2025 | AWS Cognito Docs |
| **Day 3** | • Hook up the reloop-auth-post-confirmation Lambda trigger to write USER#<sub\> / PROFILE into DynamoDB | 09/16/2025 | 09/16/2025 | AWS Lambda + Cognito |
| **Day 4** | • Fix Windows PowerShell execution policy, scaffold reloop-ui with Vite + React + ESLint, install aws-amplify | 09/17/2025 | 09/17/2025 | Vite & Amplify Docs |
| **Day 5** | • Add required schema fields (address, phone_number, email) into the Amplify <Authenticator\> sign-up form | 09/18/2025 | 09/18/2025 | @aws-amplify/ui-react |
| **Day 6** | • Style login UI with emerald green ThemeProvider and switch Cognito from SMS codes to free Email verification | 09/19/2025 | 09/19/2025 | Cognito Console & App.jsx |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned two major Cognito rules: 1) Required attributes are permanently locked once the pool is created, and 2) if passing both phone and email, Cognito defaults to SMS unless configured explicitly for Email verification.

### **Environment Setup & Configuration**

* Local Vite dev server running at http://localhost:5173 connected to our Singapore Cognito pool.
* Kept required address and phone fields in signup form as needed for hardware pickup/handover.

### **Practical Skills & Operations**

* Completed full test registration on ReLoop UI, verified email OTP code, and confirmed profile record appeared in reloop-core-table.
