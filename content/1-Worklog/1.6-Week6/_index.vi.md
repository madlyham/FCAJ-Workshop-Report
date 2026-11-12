---
title: "Nhật ký công việc Tuần 6"
date: 2026-11-07
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

# **Nhật ký công việc Tuần 6: Môi trường Dev bằng Terraform, Luồng Chợ đầy đủ trên AWS và Cloud & AI Meetup**

## **1. Mục tiêu tuần**

* Đưa toàn bộ môi trường dev vào Terraform để dựng lại được bằng một lệnh.
* Chạy luồng Chợ đầy đủ trên AWS và chứng minh bằng smoke test trọn luồng.
* Thêm job chạy nền và giám sát; tham dự Sự kiện 4 (Cloud & AI Infrastructure Meetup).

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Xác nhận luồng Chợ đầy đủ chạy trên AWS trước ngày 19/10 (đăng tin → ghép → báo giá → ra giá trong chat → giao dịch → đánh giá); lưu Terraform state trong bucket S3 có versioning | 10/19/2026 | 10/19/2026 | Tài liệu Terraform |
| **Ngày 3** | • Dựng lại stack dev bằng Terraform: reloop-dev-user-pool, reloop-dev-api, CloudFront với Origin Access Control (OAC) cho bucket web | 10/20/2026 | 10/20/2026 | infra/*.tf |
| **Ngày 4** | • Rule EventBridge mỗi 15 phút: cho tin hết hạn, tự hoàn tất giao dịch sau 48 giờ, gửi nhắc việc, lập hóa đơn tháng | 10/21/2026 | 10/21/2026 | Tài liệu Amazon EventBridge |
| **Ngày 5** | • Deploy và chạy smoke-aws.py trên stack dev thật: đạt 25/25 bước kiểm tra | 10/22/2026 | 10/22/2026 | smoke-aws.py |
| **Ngày 6** | • Dashboard CloudWatch reloop-dev-overview và alarm (Lambda lỗi/throttle, API 5xx, p95 > 2 giây) gửi email cho Admin qua SNS | 10/23/2026 | 10/23/2026 | Tài liệu Amazon CloudWatch |
| **Ngày 7** | • Tham dự [Sự kiện 4: Cloud & AI Infrastructure Meetup](../../4-eventparticipated/4.4-event4/) (10:30 – 12:00 tại Bitexco Financial Tower). Tìm hiểu sâu về lưu trữ đối tượng cho AI (chuẩn S3 API ở quy mô lớn), tối ưu cụm GPU phục vụ LLM và kiến trúc bộ nhớ router. | 10/24/2026 | 10/24/2026 | Sự kiện 4 / OMZ, Viettel & AWS |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu vì sao Terraform state lưu từ xa, có versioning lại quan trọng khi nhiều người cùng deploy một stack.
* Hiểu cách khóa job theo 'ngăn giờ' giúp job định kỳ tìm việc đến hạn mà không phải quét bảng.

### **Cài đặt & Thiết lập môi trường**

* Stack dev do Terraform quản lý: Cognito, HTTP API, Lambda, DynamoDB, S3, CloudFront (OAC), EventBridge, CloudWatch, SNS.
* Dashboard reloop-dev-overview có alarm gửi qua SNS email.

### **Kỹ năng thực hành & Vận hành**

* Smoke test trọn luồng đạt 25/25 trên stack dev đã deploy.
* Tham dự Cloud & AI Infrastructure Meetup và ghi lại ý tưởng về lưu trữ cho bài toán AI.
