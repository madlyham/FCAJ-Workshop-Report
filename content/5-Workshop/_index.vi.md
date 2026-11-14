---
title : "Workshop"
date : 2026-11-14
weight : 5
chapter : false
pre : " <b> 5. </b> "
---

# Triển khai Nền tảng Thu gom Rác thải Điện tử ReLoop Serverless trên AWS

Chào mừng bạn đến với bài thực hành **ReLoop AWS Serverless Workshop**. Qua 13 phần từ **5.1 đến 5.13**, bạn sẽ từng bước xây dựng hoàn chỉnh một ứng dụng web serverless trên AWS Management Console—từ cơ sở dữ liệu DynamoDB một bảng (single-table), xác thực Amazon Cognito, lưu trữ ảnh riêng tư trên S3 bằng presigned URL, API backend Node.js 22 (ARM64) qua Amazon API Gateway, AI nhận diện thiết bị điện tử đa phương thức với Amazon Bedrock (`global.moonshotai.kimi-k3`), Bedrock Guardrails và Amazon Rekognition, phân phối SPA toàn cầu qua Amazon CloudFront + OAC, bảo vệ nhiều lớp bằng AWS WAFv2, tác vụ nền định kỳ bằng EventBridge, giám sát qua CloudWatch, kiểm thử đầu cuối (E2E) và dọn dẹp tài nguyên sạch sẽ kèm bộ mã Terraform Infrastructure-as-Code (IaC).

{{% notice note %}}
Bài hướng dẫn dùng tiền tố tài nguyên `reloop2` và các giá trị mẫu đã ẩn danh (`123456789012`, `alerts@example.com`) để bạn thực hành an toàn mà không xung đột tên hay lộ thông tin tài khoản thật.
{{% /notice %}}

### Nội dung Workshop

1. [5.1. Tổng quan & Kiến trúc ReLoop](5.1-workshop-overview/)
2. [5.2. Chuẩn bị môi trường, Ngân sách & Kiểm tra Bedrock](5.2-prerequisites/)
3. [5.3. Tầng dữ liệu Single-Table với Amazon DynamoDB](5.3-dynamodb/)
4. [5.4. Xác thực & Hồ sơ người dùng với Amazon Cognito](5.4-cognito/)
5. [5.5. Lưu trữ ảnh riêng tư với Amazon S3, CORS & Lifecycle](5.5-s3-images/)
6. [5.6. Backend API với AWS Lambda & HTTP API Gateway](5.6-backend-api/)
7. [5.7. An toàn nội dung AI với Amazon Bedrock Guardrails](5.7-bedrock-guardrails/)
8. [5.8. Lưu trữ Frontend SPA & Định tuyến Edge với CloudFront + OAC](5.8-cloudfront-frontend/)
9. [5.9. Bảo vệ Edge & Danh tính với AWS WAFv2](5.9-waf/)
10. [5.10. Lịch quét tự động với Amazon EventBridge](5.10-eventbridge/)
11. [5.11. Giám sát với CloudWatch Logs, Alarms, SNS & Dashboard](5.11-monitoring/)
12. [5.12. Kiểm thử toàn trình End-to-End (E2E)](5.12-end-to-end-verification/)
13. [5.13. Dọn dẹp tài nguyên & Hạ tầng dưới dạng Mã (Terraform)](5.13-cleanup-and-iac/)
