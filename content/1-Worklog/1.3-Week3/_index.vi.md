---
title: "Worklog tuần 3"
date: 2026-11-07
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

# **Nhật ký tuần 3: Lưu trữ đám mây S3 và thiết kế NoSQL DynamoDB Single-Table**

## **1. Mục tiêu trong tuần**

* Tìm hiểu lưu trữ tệp tin đám mây (S3) và cơ sở dữ liệu NoSQL Serverless (DynamoDB).
* Nắm vững giải pháp khóa hoàn toàn truy cập public vào S3 bucket nhưng vẫn cho phép tải ảnh an toàn qua Presigned URLs.
* Thực hành thiết kế khóa bảng đơn (Partition Key - PK và Sort Key - SK) trong DynamoDB.

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Tìm hiểu Amazon S3: Buckets, object keys và cơ chế 'Block all public access' | 08/25/2025 | 08/25/2025 | AWS Cloud Journey |
| **Ngày 3** | • Tìm hiểu quy tắc S3 Lifecycle (tự động xóa dữ liệu cũ) và cấu hình CORS | 08/26/2025 | 08/26/2025 | AWS Cloud Journey |
| **Ngày 4** | • Tìm hiểu nền tảng DynamoDB: Partition Key (PK), Sort Key (SK), so sánh thao tác Query tối ưu và Scan | 08/27/2025 | 08/27/2025 | AWS Cloud Journey |
| **Ngày 5** | • So sánh hai chế độ tính cước DynamoDB: On-Demand (theo lượt dùng) và Provisioned (dung lượng cấp phát) | 08/28/2025 | 08/28/2025 | AWS Cloud Journey |
| **Ngày 6** | • Thực hành: Tạo S3 bucket private và kiểm thử Presigned URLs; Tạo bảng DynamoDB và chạy lệnh put-item, query qua CLI | 08/29/2025 | 08/29/2025 | AWS Cloud Journey |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Hiểu rõ lý do giữ S3 bucket riêng tư 100% và để backend cấp Presigned URL có hạn giờ giúp client tải ảnh trực tiếp lên S3 an toàn.
* Nắm vững tư duy Single-Table Design trên DynamoDB: gom nhiều thực thể vào một bảng duy nhất nhờ tiền tố khóa như USER# hoặc LISTING#.

### **Thiết lập & cấu hình môi trường**

* Tạo bucket S3 private thử nghiệm kèm cấu hình tiêu đề CORS và quy tắc vòng đời tự động dọn dẹp.
* Khởi tạo bảng DynamoDB chế độ On-Demand tại vùng Singapore (ap-southeast-1) giúp tiết kiệm $0 khi không có tải.

### **Kỹ năng thực hành & vận hành hệ thống**

* Kiểm thử tải ảnh thành công qua Presigned URL và xác minh truy cập trực tiếp bằng URL public bị chặn hoàn toàn.
* Thêm mới và truy vấn dữ liệu JSON trong DynamoDB bằng khóa chính và chỉ mục phụ toàn cục (GSI1).
