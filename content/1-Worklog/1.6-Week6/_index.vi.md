---
title: "Nhật ký công việc Tuần 6"
date: 2026-11-07
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

## **Nhật ký công việc Tuần 6 — Môi trường Dev bằng Terraform, luồng chợ đầy đủ trên AWS và Cloud & AI Meetup**

## **1. Mục tiêu tuần**

* Đưa toàn bộ môi trường dev vào Terraform để dựng lại được bằng một lệnh.
* Chạy luồng chợ đầy đủ trên AWS và chứng minh bằng smoke test trọn luồng.
* Thêm tác vụ định kỳ đóng tin hết hạn và cảnh báo CloudWatch/SNS; tham dự Sự kiện 4 (Cloud & AI Infrastructure Meetup).

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Thứ 2** | • Xác nhận luồng chợ đầy đủ bản đồng bộ ban đầu chạy trực tiếp trên AWS trước ngày 19/10/2026 (đăng tin → ghép chi nhánh ban đầu → báo giá → ra giá trong chat → giao dịch → đánh giá; phần ghép chi nhánh sau đó được tái cấu trúc thành tác vụ chạy nền bất đồng bộ dùng geohash + Haversine ở Tuần 8); lưu Terraform state trong bucket S3 có versioning | 19/10/2026 | 19/10/2026 | [Terraform S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3), [S3 Versioning](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html) |
| **Thứ 3** | • Dựng lại stack dev bằng Terraform: `reloop-dev-user-pool`, `reloop-dev-api`, CloudFront với Origin Access Control (OAC) cho bucket web | 20/10/2026 | 20/10/2026 | [CloudFront OAC cho S3](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html), [Terraform aws_cloudfront_origin_access_control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`infra/*.tf`) |
| **Thứ 4** | • Cấu hình rule Amazon EventBridge chạy định kỳ mỗi 15 phút để đóng tin hết hạn (quá cửa sổ 7 ngày) | 21/10/2026 | 21/10/2026 | [Rule theo lịch EventBridge](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-create-rule-schedule.html), [Biểu thức lịch EventBridge](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html) |
| **Thứ 5** | • Triển khai và chạy `smoke-aws.py` trên stack dev thật: đạt 25/25 bước kiểm tra | 22/10/2026 | 22/10/2026 | [Repository ReLoop](https://github.com/madlyham/ReLoop) (`smoke-aws.py`) |
| **Thứ 6** | • Cấu hình lưu log CloudWatch 7 ngày và 1 cảnh báo metric Lambda Errors (≥ 3 lỗi trong 5 phút) gửi email cảnh báo cho Admin qua Amazon SNS | 23/10/2026 | 23/10/2026 | [Log group và thời gian lưu log CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html), [Cảnh báo CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html), [Đăng ký email SNS](https://docs.aws.amazon.com/sns/latest/dg/sns-email-notifications.html) |
| **Thứ 7** | • Tham dự [Sự kiện 4: Hội thảo chuyên sâu về Hạ tầng Điện toán đám mây & AI](../../4-eventparticipated/4.4-event4/) (10:30 – 12:00 tại Bitexco Financial Tower). Tìm hiểu sâu về lưu trữ đối tượng cho AI (chuẩn S3 API ở quy mô lớn), tối ưu cụm GPU phục vụ LLM và kiến trúc định tuyến thông minh (Agent Router) và đồ thị bộ nhớ. | 24/10/2026 | 24/10/2026 | [Sự kiện 4](../../4-eventparticipated/4.4-event4/) |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu vì sao Terraform state lưu từ xa, có versioning lại quan trọng khi nhiều người cùng triển khai một stack.
* Hiểu cách khóa tác vụ theo khung thời gian giúp tác vụ định kỳ tìm việc đến hạn mà không phải quét toàn bộ bảng.

### **Cài đặt & Thiết lập môi trường**

* Stack dev do Terraform quản lý: Cognito, HTTP API, Lambda, DynamoDB, S3, CloudFront (OAC), EventBridge, CloudWatch và SNS.
* Lưu log CloudWatch 7 ngày và 1 cảnh báo metric Lambda Errors (≥ 3 lỗi trong 5 phút) gửi email cho Admin qua SNS.

### **Kỹ năng thực hành & Vận hành**

* Smoke test trọn luồng đạt 25/25 trên stack dev đã triển khai.
* Tham dự Cloud & AI Infrastructure Meetup và ghi lại ý tưởng về lưu trữ cho bài toán AI.
