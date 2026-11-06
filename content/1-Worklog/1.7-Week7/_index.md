---
title: "Week 7 Worklog"
date: 2026-11-07
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

# **Week 7 Work Log: S3 Secure Uploads, Rekognition Content Moderation & Lifecycle Rules**

## **1. Weekly Objectives**

* Build the private S3 image upload flow using temporary Presigned POST tickets (POST /uploads/presign).
* Add Amazon Rekognition content moderation (DetectModerationLabels) to block NSFW/unsafe photos.
* Configure S3 lifecycle rules so unattached uploads and old photos get deleted automatically.

## **2. Weekly Execution Schedule**

| Day | Task Description | Start Date | Completion Date | Reference Material |
| :--- | :--- | :--- | :--- | :--- |
| **Day 2** | • Implement S3ImageStore (backend/src/storage/imageStore.ts): 300s presigned POST tickets (max 5MB, max 6 photos/listing) | 09/22/2025 | 09/22/2025 | AWS S3 SDK Docs |
| **Day 3** | • Lock down user prefixes (listings/<userId>/) with assertOwnImageKeys() to prevent unauthorized photo attachments | 09/23/2025 | 09/23/2025 | imageStore.ts |
| **Day 4** | • Implement RekognitionModerator calling DetectModerationLabels (MinConfidence: 70) | 09/24/2025 | 09/24/2025 | AWS Rekognition Docs |
| **Day 5** | • Auto-delete rejected photos from S3, log ImagesRejected metric, return 422 IMAGE_REJECTED | 09/25/2025 | 09/25/2025 | moderateUpload() |
| **Day 6** | • Configure S3 Lifecycle rules: purge unattached state=pending images after 1 day, listing images after 120 days | 09/26/2025 | 09/26/2025 | infra/*.tf |

## **3. Key Achievements & Outcomes**

### **Theoretical Foundation**

* Saw how tagging S3 objects (state=pending -> moderation=passed -> state=attached) allows S3 Lifecycle rules to clean up abandoned uploads for free without custom cron jobs.

### **Environment Setup & Configuration**

* Wired IMAGE_BUCKET=reloop-device-images into backend config with DisabledImageStore fallback for offline tests.

### **Practical Skills & Operations**

* Tested uploading valid hardware photos vs disallowed test images and verified assertModerated() blocks anyone bypassing moderation.
