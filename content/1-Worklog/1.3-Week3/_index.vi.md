---
title: "Nhật ký công việc Tuần 3"
date: 2026-11-07
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

# **Nhật ký công việc Tuần 3: Lưu trữ đám mây S3, Thiết kế Single-Table DynamoDB & Presigned URLs**

## **1. Mục tiêu tuần**

* Tìm hiểu lưu trữ đối tượng đám mây (Amazon S3) và cơ sở dữ liệu NoSQL serverless (DynamoDB).
* Cấu hình S3 hoàn toàn riêng tư nhưng vẫn cho phép tải ảnh an toàn qua Presigned URLs.
* Hiểu rõ thiết kế Partition Key / Sort Key để tối ưu chi phí và tránh quét toàn bảng (Scan).

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Tìm hiểu Amazon S3: Buckets, object keys và cơ chế 'Block all public access' | 08/24/2026 | 08/24/2026 | AWS Cloud Journey |
| **Ngày 3** | • Tìm hiểu quy tắc S3 Lifecycle (tự động xóa dữ liệu cũ) và cấu hình CORS | 08/25/2026 | 08/25/2026 | AWS Cloud Journey |
| **Ngày 4** | • Tìm hiểu DynamoDB: Khóa phân vùng (PK), Khóa sắp xếp (SK) và thiết kế Single-table | 08/26/2026 | 08/26/2026 | AWS Cloud Journey |
| **Ngày 5** | • So sánh chế độ dung lượng DynamoDB On-Demand (trả theo lượng dùng) và Provisioned | 08/27/2026 | 08/27/2026 | AWS Cloud Journey |
| **Ngày 6** | • Thực hành: Tạo S3 bucket bảo mật, tạo Presigned URL upload file, tạo bảng DynamoDB và chạy truy vấn Query | 08/28/2026 | 08/28/2026 | AWS Cloud Journey |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu bản chất lưu trữ đối tượng của S3 và lý do Presigned URL giúp tiết kiệm băng thông máy chủ backend.
* Nắm vững kỹ thuật mô hình hóa dữ liệu Single-table trong DynamoDB theo tiền tố PK/SK để tránh thao tác Scan tốn kém.

### **Cài đặt & Thiết lập môi trường**

* Khởi tạo S3 bucket với chính sách 'Block all public access' tuyệt đối.
* Tạo bảng DynamoDB ở chế độ On-Demand linh hoạt.

### **Kỹ năng thực hành & Vận hành**

* Tạo Presigned URL thời hạn 300 giây cho phép trình duyệt tải ảnh trực tiếp lên S3.
* Thực hiện truy vấn Query chính xác dựa trên Key Condition bằng AWS CLI.
