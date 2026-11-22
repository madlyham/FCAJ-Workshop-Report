---
title: "Nhật ký công việc Tuần 10"
date: 2026-11-22
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

# **Nhật ký công việc Tuần 10 — Load Test, sửa throttling, một luồng triển khai duy nhất và xác thực Workshop trực tiếp**

## **1. Mục tiêu tuần**

* Chứng minh hệ thống chịu được tải tăng đột biến ổn định sau khi nâng giới hạn Lambda song song.
* Áp dụng một luồng triển khai duy nhất qua CI/CD, mỗi thành viên một IAM user và xác nhận không còn access key của tài khoản root.
* Xây dựng lại bộ hướng dẫn Workshop tinh gọn (`5.1`–`5.12`) và hoàn tất xác thực trực tiếp trọn luồng từ Mũi tên 1 → 10, EventBridge và CloudWatch/SNS.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Thứ 2** | • Chạy lại `loadtest.mjs` (80 request song song) so với mốc cũ 26% lỗi `5xx`; với giới hạn Lambda song song là 1.000, lỗi `5xx` giảm về 0 | 16/11/2026 | 16/11/2026 | [Tài liệu AWS Lambda](https://docs.aws.amazon.com/lambda/), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`loadtest.mjs`) |
| **Thứ 3** | • Sửa throttling: cấu hình giới hạn trên API Gateway (20 request/giây, burst 50) và xác nhận giới hạn tốc độ trên WAF cùng API trả về phản hồi giới hạn tải có kiểm soát (`429` + `Retry-After`) thay vì báo lỗi máy chủ | 17/11/2026 | 17/11/2026 | [Tài liệu Amazon API Gateway](https://docs.aws.amazon.com/apigateway/), [Tài liệu AWS WAF](https://docs.aws.amazon.com/waf/), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`infra/waf.tf`) |
| **Thứ 4** | • Áp dụng một luồng triển khai duy nhất trên GitHub Actions từ bản mã đã commit (ngừng triển khai thủ công từ laptop); hoàn tất mỗi thành viên một IAM user và xác nhận tài khoản không còn access key của root | 18/11/2026 | 18/11/2026 | [Tài liệu GitHub Actions](https://docs.github.com/actions), [Tài liệu AWS IAM](https://docs.aws.amazon.com/iam/) |
| **Thứ 5** | • Dựng lại và tinh gọn bộ tài liệu Workshop (`5.1`–`5.12`) bám sát đúng stack 12 dịch vụ AWS (+ IAM) bằng Terraform với các bước cài đặt và dọn dẹp có thể tái lập | 19/11/2026 | 19/11/2026 | [Workshop](../../5-workshop/), [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) |
| **Thứ 6** | • Thực hiện xác thực trực tiếp trọn luồng từ Mũi tên 1 → 10 (CloudFront + WAF tại biên, đăng nhập Cognito, tải ảnh presigned S3, kiểm duyệt Rekognition, Bedrock Kimi K3 + Guardrail và luồng chợ DynamoDB một bảng) | 20/11/2026 | 20/11/2026 | [Workshop](../../5-workshop/), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`smoke-aws.py`) |
| **Thứ 7** | • Xác thực rule EventBridge quét đóng tin hết hạn mỗi 15 phút và log CloudWatch 7 ngày + cảnh báo Lambda Errors (≥ 3 lỗi trong 5 phút) → email Admin qua SNS; ghi nhận số liệu Cost Explorer và credit ($189.80 USD còn lại đến 28/02/2027) | 21/11/2026 | 21/11/2026 | [Tài liệu Amazon EventBridge](https://docs.aws.amazon.com/eventbridge/), [Tài liệu Amazon CloudWatch](https://docs.aws.amazon.com/cloudwatch/), [Tài liệu Amazon SNS](https://docs.aws.amazon.com/sns/), [AWS Billing & Cost Explorer](https://docs.aws.amazon.com/cost-management/) |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu rõ khác biệt giữa lỗi sập dịch vụ khi quá tải (`5xx`) và phản hồi giới hạn tải có kiểm soát (`429` + `Retry-After`).
* Hiểu vì sao một luồng triển khai duy nhất từ bản mã đã commit giúp tránh tình trạng hai máy ghi đè lẫn nhau.

### **Cài đặt & Thiết lập môi trường**

* API Gateway giới hạn 20 request/giây (burst 50) và giới hạn tốc độ trên WAF đã xác nhận trả về `429` + `Retry-After`.
* Luồng triển khai duy nhất qua GitHub Actions đã đi vào vận hành, mỗi thành viên dùng IAM user riêng và không còn access key của root.

### **Kỹ năng thực hành & Vận hành**

* So sánh kết quả load test trước và sau khi sửa, lưu dẫn chứng cho báo cáo cuối kỳ.
* Hoàn tất xác thực trực tiếp toàn bộ Workshop (`5.1`–`5.12`) qua Mũi tên 1 → 10, EventBridge và CloudWatch/SNS, đồng thời xác nhận số dư credit ngày 21/11/2026 là $189.80 USD (hiệu lực đến 28/02/2027).
