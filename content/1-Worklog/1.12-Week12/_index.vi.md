---
title: "Worklog tuần 12"
date: 2026-11-07
weight: 12
chapter: false
pre: " <b> 1.12. </b> "
---

# **Nhật ký tuần 12: Cẩm nang kỹ thuật cho lập trình viên, kiểm thử tải đồng thời và tổng duyệt Demo**

## **1. Mục tiêu trong tuần**

* Chuẩn hóa tài liệu dự án và biên soạn Cẩm nang kỹ thuật cho lập trình viên (Developer Technical Reference - Man-Page).
* Thực hiện kiểm thử tải (scripts/loadtest.mjs) và kiểm tra xử lý đồng thời để chuẩn bị cho buổi bảo vệ cuối kỳ.
* Hoàn thiện phần báo cáo kiến trúc AI (D2) và tổng duyệt kịch bản demo trực tiếp toàn bộ hệ thống.

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Tổng hợp toàn bộ cấu hình AWS, biến môi trường và biến Terraform thành tài liệu RELOOP_TECHNICAL_REFERENCE chuẩn | 10/27/2025 | 10/27/2025 | RELOOP_TECHNICAL_REFERENCE |
| **Ngày 3** | • Tài liệu hóa hơn 30 mẫu khóa DynamoDB, các chuyển trạng thái giao dịch, mã lỗi AppError và hơn 45 API endpoints | 10/28/2025 | 10/28/2025 | Mã nguồn Backend |
| **Ngày 4** | • Chạy kiểm thử tải (50 người dùng giả lập, 20 req/giây); xác nhận putVersioned kết hợp thử lại lạc quan ngăn chặn nhận trùng báo giá | 10/29/2025 | 10/29/2025 | scripts/loadtest.mjs |
| **Ngày 5** | • Biên soạn Mục D2 Báo cáo cuối kỳ: phân tích FinOps mô hình Nova Pro, độ chính xác nhận diện ảnh thực tế và phòng thủ Prompt Injection | 10/30/2025 | 10/30/2025 | Báo cáo cuối kỳ (D2) |
| **Ngày 6** | • Tổng duyệt 2 lần kịch bản demo trực tiếp (luồng đối tác cấp 1/2, AI nhận diện, ghép nối 5km, xuất hóa đơn, gắn cờ ảnh tấn công) | 10/31/2025 | 10/31/2025 | Kịch bản Demo |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Kết nối toàn diện kiến thức từ các lệnh EC2/CLI cơ bản tuần 1 đến hệ thống Serverless hoàn chỉnh: tích hợp AI đa phương thức, hàng rào bảo mật Computer Vision, kiểm soát đồng thời lạc quan và Hạ tầng dưới dạng mã.

### **Thiết lập & cấu hình môi trường**

* Bàn giao tài liệu cẩm nang kỹ thuật chi tiết giúp các thành viên tra cứu cấu hình S3 CORS, Cognito User Pool, mẫu khóa DynamoDB trong vài giây.

### **Kỹ năng thực hành & vận hành hệ thống**

* Xác nhận độ trễ p95 đọc/ghi duy trì dưới ngưỡng mục tiêu trong suốt quá trình test tải và hoàn thành xuất sắc các buổi tổng duyệt demo ReLoop.
