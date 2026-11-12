---
title: "Nhật ký công việc Tuần 2"
date: 2026-11-07
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

# **Nhật ký công việc Tuần 2: Serverless cơ bản: S3, DynamoDB, Lambda, API Gateway và Khởi động Buildrathon**

## **1. Mục tiêu tuần**

* Học các khối serverless chính: S3, DynamoDB, Lambda và API Gateway.
* Thiết lập giám sát và hàng rào chi phí (CloudWatch, AWS Budgets) ngay từ đầu.
* Tham dự Sự kiện 1 (Khởi động Buildrathon), đánh dấu điểm bắt đầu đồ án ReLoop.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Amazon S3: bucket, Block Public Access, versioning, lifecycle rule và CORS | 09/21/2026 | 09/21/2026 | AWS Cloud Journey |
| **Ngày 3** | • Presigned URL (hết hạn sau 300 giây) để trình duyệt tải lên/tải xuống trực tiếp mà không mở công khai bucket | 09/22/2026 | 09/22/2026 | Tài liệu Amazon S3 |
| **Ngày 4** | • Amazon DynamoDB: partition key / sort key (PK/SK), chế độ On-Demand, ý tưởng thiết kế một bảng | 09/23/2026 | 09/23/2026 | AWS Cloud Journey |
| **Ngày 5** | • AWS Lambda + API Gateway HTTP API: hàm đầu tiên, route, CORS, log trên CloudWatch | 09/24/2026 | 09/24/2026 | AWS Cloud Journey |
| **Ngày 6** | • Tạo cảnh báo AWS Budgets ở mức 50% / 80% / 100% và tìm hiểu metric, alarm của CloudWatch | 09/25/2026 | 09/25/2026 | AWS Billing Console |
| **Ngày 7** | • Tham gia [Sự kiện 1: Khởi động Buildrathon – Code the Future cùng CMC Global](../../4-eventparticipated/4.1-event1/) (10:30 – 12:00 tại Bitexco Financial Tower). Khám phá Generative AI, quy trình Agentic AI và kiến trúc RAG. Nhóm chính thức bắt đầu đồ án ReLoop từ đây. | 09/26/2026 | 09/26/2026 | Sự kiện 1 / CMC Global & AWS |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu vì sao serverless (trả theo request, không có máy chủ chạy không) hợp với nhóm nhỏ có ít credit.
* Nắm cách thiết kế PK/SK tốt giúp DynamoDB trả lời mọi truy vấn mà không phải quét bảng.
* Rút ra từ Sự kiện 1 cách công cụ GenAI và quy trình agent giúp tăng tốc khi xây dựng sản phẩm kiểu hackathon.

### **Cài đặt & Thiết lập môi trường**

* Bucket S3 riêng tư có Block Public Access, lifecycle và CORS cho trình duyệt tải ảnh.
* Bảng DynamoDB thực hành ở chế độ On-Demand.
* Cảnh báo AWS Budgets ở mức 50% / 80% / 100% gửi qua email.

### **Kỹ năng thực hành & Vận hành**

* Dựng một endpoint Lambda + HTTP API nhỏ và theo dõi log trên CloudWatch.
* Tải file lên/xuống bằng presigned URL mà không mở công khai bucket nào.
* Cùng nhóm tham gia buổi khởi động Buildrathon và thống nhất xây dựng ReLoop, chợ đồ điện tử cũ.
