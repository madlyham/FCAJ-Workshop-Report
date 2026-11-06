---
title: "Week 3 Worklog"
date: 2026-11-07
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

# **Week 3 Work Log: Cloud Storage S3, DynamoDB Single-Table Design & Presigned URLs**

## **1. Weekly Objectives**

* Learn cloud file storage (S3) and serverless NoSQL tables (DynamoDB).
* Figure out how to keep S3 buckets locked to the public while still letting users upload photos safely.
* Practice designing single-table keys (PK and SK) in DynamoDB.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Study Amazon S3: Buckets, object keys, and 'Block all public access' | 08/25/2025 | 08/25/2025 | AWS Cloud Journey |
| **Day 3** | • Learn S3 Lifecycle rules (auto-deleting old files) and CORS configuration | 08/26/2025 | 08/26/2025 | AWS Cloud Journey |
| **Day 4** | • Study DynamoDB fundamentals: Partition Key (PK), Sort Key (SK), Query vs Scan operations | 08/27/2025 | 08/27/2025 | AWS Cloud Journey |
| **Day 5** | • Compare DynamoDB On-Demand vs Provisioned capacity modes | 08/28/2025 | 08/28/2025 | AWS Cloud Journey |
| **Day 6** | • Hands-on practice: Create a private S3 bucket and test Presigned URLs; Create DynamoDB table and run put-item & query via CLI | 08/29/2025 | 08/29/2025 | AWS Cloud Journey |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Learned why we keep S3 buckets 100% private and have the backend hand the browser a temporary Presigned URL (like a 5-minute upload ticket) to upload files directly.
* Understood DynamoDB single-table design where different entity types live in one table using prefixes like USER# or LISTING#.

### **Environment Setup & Configuration**

* Created a private test S3 bucket with CORS headers and auto-expire lifecycle rules.
* Provisioned an On-Demand DynamoDB table in ap-southeast-1 so it costs $0 when sitting idle.

### **Practical Skills & Operations**

* Tested file uploads using presigned links and verified direct public URLs get blocked.
* Inserted and queried JSON items in DynamoDB using primary keys and secondary indexes (GSI1).
