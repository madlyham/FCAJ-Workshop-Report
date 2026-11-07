---
title: "Nhật ký công việc Tuần 4"
date: 2026-11-07
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

# **Nhật ký công việc Tuần 4: Điện toán Serverless với AWS Lambda, API Gateway và CloudWatch**

## **1. Mục tiêu tuần**

* Nắm vững kiến trúc Serverless hướng sự kiện: mã thực thi theo nhu cầu và chỉ tính phí khi có request.
* Xây dựng backend RESTful tinh gọn với API Gateway HTTP API và hàm AWS Lambda.
* Thiết lập giám sát CloudWatch và cảnh báo ngân sách AWS Budgets tránh phát sinh chi phí ngoài ý muốn.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Tìm hiểu AWS Lambda: Event triggers, hiện tượng cold start, giới hạn timeout và biến môi trường | 08/31/2026 | 08/31/2026 | AWS Cloud Journey |
| **Ngày 3** | • Tìm hiểu API Gateway (HTTP API): Cổng định tuyến nhận request từ web và chuyển tiếp tới hàm Lambda | 09/01/2026 | 09/01/2026 | AWS Cloud Journey |
| **Ngày 4** | • Thực hành: Viết hàm Lambda Node.js đọc/ghi DynamoDB kèm IAM execution role tối thiểu | 09/02/2026 | 09/02/2026 | AWS Cloud Journey |
| **Ngày 5** | • Cấu hình các route API Gateway (GET, POST), gắn integration tới Lambda và xử lý CORS preflight | 09/03/2026 | 09/03/2026 | AWS Cloud Journey |
| **Ngày 6** | • Thực hành: Tra cứu log CloudWatch; Thiết lập cảnh báo ngân sách AWS Budgets gửi email khi đạt 50%, 80%, 100% | 09/04/2026 | 09/04/2026 | AWS Cloud Journey |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu rõ lợi thế kinh tế của serverless: chi phí bằng 0 khi nhàn rỗi, tự động mở rộng theo tải và tính cước theo mili-giây.
* Nắm vững cơ chế xử lý CORS preflight OPTIONS để ứng dụng web giao tiếp trơn tru với API.

### **Cài đặt & Thiết lập môi trường**

* Tạo và cấu hình HTTP API Gateway kết nối trực tiếp với hàm Lambda.
* Cấu hình AWS Budgets gửi cảnh báo qua email khi chi phí chạm ngưỡng ngân sách.

### **Kỹ năng thực hành & Vận hành**

* Triển khai và kiểm thử các thao tác CRUD từ terminal bằng curl và trình duyệt.
* Tra cứu vết lỗi thực thi và phân tích thời gian phản hồi qua CloudWatch Logs.
