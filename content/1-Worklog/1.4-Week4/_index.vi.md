---
title: "Worklog tuần 4"
date: 2026-11-07
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

# **Nhật ký tuần 4: Điện toán Serverless với AWS Lambda, API Gateway và CloudWatch**

## **1. Mục tiêu trong tuần**

* Chuyển đổi từ máy chủ EC2 truyền thống sang mô hình điện toán Serverless (AWS Lambda + API Gateway).
* Hiểu cơ chế hàm khởi động theo sự kiện kích hoạt, thực thi mã nguồn và tự động tắt không phát sinh chi phí nhàn rỗi.
* Thiết lập nhật ký CloudWatch và cảnh báo chi phí AWS Budgets để kiểm soát sử dụng AWS credits.

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Tìm hiểu AWS Lambda: Event triggers, hiện tượng cold start, giới hạn timeout và biến môi trường | 09/01/2025 | 09/01/2025 | AWS Cloud Journey |
| **Ngày 3** | • Tìm hiểu API Gateway (HTTP API): Cổng định tuyến nhận request từ web và chuyển tiếp tới hàm Lambda | 09/02/2025 | 09/02/2025 | AWS Cloud Journey |
| **Ngày 4** | • Thực hành: Viết hàm Lambda đọc/ghi DynamoDB; Gán IAM execution role để Lambda có quyền thao tác bảng | 09/03/2025 | 09/03/2025 | AWS Cloud Journey |
| **Ngày 5** | • Định tuyến API Gateway (GET, POST) tới hàm Lambda và kiểm thử preflight request CORS OPTIONS | 09/04/2025 | 09/04/2025 | AWS Cloud Journey |
| **Ngày 6** | • Thực hành: Kiểm tra log hàm trong CloudWatch; Cấu hình cảnh báo email AWS Budgets tại các mốc 50%, 80%, 100% của $20 | 09/05/2025 | 09/05/2025 | AWS Cloud Journey |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Nắm vững mô hình kiến trúc API Gateway + Lambda + DynamoDB tạo nên backend hoàn chỉnh mà không cần trả phí duy trì máy chủ 24/7.
* Hiểu cách CloudWatch thu thập log console từ Lambda và kích hoạt cảnh báo khi tỷ lệ lỗi tăng cao.

### **Thiết lập & cấu hình môi trường**

* Triển khai thành công HTTP API Gateway kết nối trực tiếp với hàm Lambda viết bằng Node.js.
* Thiết lập cảnh báo ngân sách AWS Budgets ở các ngưỡng 50%, 80% và 100% gửi email thông báo tự động.

### **Kỹ năng thực hành & vận hành hệ thống**

* Khắc phục lỗi quyền hạn của Lambda bằng cách tra cứu CloudWatch log streams và bổ sung quyền dynamodb:PutItem vào IAM Role.
