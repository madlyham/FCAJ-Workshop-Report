---
title: "Week 3 Worklog"
date: 2026-11-07
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

# **Week 3 Work Log: Cloud Storage S3, DynamoDB Single-Table Design & Presigned URLs**

## **1. Weekly Objectives**

* Learn cloud object storage (S3) and serverless NoSQL tables (DynamoDB).
* Keep S3 buckets strictly private while letting authenticated clients upload photos directly via Presigned URLs.
* Understand why DynamoDB partition keys prevent slow, expensive table scans.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Study Amazon S3: Buckets, object keys, and 'Block all public access' | 08/24/2026 | 08/24/2026 | AWS Cloud Journey |
| **Day 3** | • Learn S3 Lifecycle rules (auto-deleting old files) and CORS configuration | 08/25/2026 | 08/25/2026 | AWS Cloud Journey |
| **Day 4** | • Study DynamoDB fundamentals: Partition Key (PK), Sort Key (SK), and single-table modeling | 08/26/2026 | 08/26/2026 | AWS Cloud Journey |
| **Day 5** | • Compare DynamoDB On-Demand vs Provisioned capacity modes | 08/27/2026 | 08/27/2026 | AWS Cloud Journey |
| **Day 6** | • Hands-on practice: Create private S3 bucket, test Presigned URLs, create DynamoDB table and query via CLI | 08/28/2026 | 08/28/2026 | AWS Cloud Journey |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Understood why S3 is an object store (not a mounted hard disk) and why Presigned URLs save API server bandwidth.
* Learned single-table DynamoDB querying by PK and SK prefixes without full-table Scans.

### **Environment Setup & Configuration**

* Created S3 bucket with 'Block all public access' enabled.
* Provisioned DynamoDB table in On-Demand capacity mode.

### **Practical Skills & Operations**

* Generated 300-second Presigned URLs for secure browser uploads.
* Queried DynamoDB items with key conditions via AWS CLI.
