---
title: "Week 6 Worklog"
date: 2026-11-07
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

# **Week 6 Work Log: Authentication with Amazon Cognito & React/Amplify UI Integration**

## **1. Weekly Objectives**

* Set up Amazon Cognito User Pool for secure customer and partner authentication.
* Connect Post-Confirmation Lambda trigger to automatically create user profile records in DynamoDB.
* Scaffold React web client with AWS Amplify UI and brand-aligned theming.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Configure Cognito User Pool and Web/Mobile App Clients (no client secret for browser safety) | 09/14/2026 | 09/14/2026 | AWS Cognito Docs |
| **Day 3** | • Hook up the reloop-auth-post-confirmation Lambda trigger to write USER#<sub\> / PROFILE into DynamoDB | 09/15/2026 | 09/15/2026 | AWS Lambda + Cognito |
| **Day 4** | • Fix Windows PowerShell execution policy, scaffold reloop-ui with Vite + React + ESLint, install aws-amplify | 09/16/2026 | 09/16/2026 | Vite & Amplify Docs |
| **Day 5** | • Add required schema fields (address, phone_number, email) into the Amplify <Authenticator> sign-up form | 09/17/2026 | 09/17/2026 | @aws-amplify/ui-react |
| **Day 6** | • Style login UI with emerald green ThemeProvider and switch Cognito from SMS codes to free Email verification | 09/18/2026 | 09/18/2026 | Cognito Console & App.jsx |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Understood JWT token architecture: ID Token for identity claims, Access Token for API authorization, Refresh Token for silent session renewal.
* Learned why Post-Confirmation Lambda hooks ensure strong consistency between Cognito IDs and DynamoDB profiles.

### **Environment Setup & Configuration**

* Configured Cognito User Pool with email verification and custom attributes.
* Integrated @aws-amplify/ui-react into the Vite React client.

### **Practical Skills & Operations**

* Successfully tested end-to-end registration flow: sign up -> verify code via email -> trigger auto-populates DynamoDB profile.
* Secured API Gateway endpoints with Cognito JWT authorizer.
