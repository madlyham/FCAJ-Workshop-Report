---
title: "Nhật ký công việc Tuần 10"
date: 2026-11-07
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

# **Nhật ký công việc Tuần 10: Load Test, Sửa Throttling, Một Đường Deploy và Môi trường Production**

## **1. Mục tiêu tuần**

* Chứng minh hệ thống chịu được tải tăng đột biến sau khi nâng giới hạn song song.
* Đưa mọi lần deploy về một đường CI/CD, mỗi thành viên một IAM user.
* Dựng môi trường production từ cùng bộ Terraform.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Chạy lại loadtest.mjs (80 request song song) so với mốc cũ 26% lỗi 5xx; với giới hạn song song 1.000, lỗi 5xx không còn | 11/16/2026 | 11/16/2026 | loadtest.mjs |
| **Ngày 3** | • Sửa throttling: API Gateway giới hạn 20 request/giây, burst 50; luật tốc độ WAF và API trả 429 kèm Retry-After thay vì báo lỗi | 11/17/2026 | 11/17/2026 | Tài liệu API Gateway |
| **Ngày 4** | • Một đường deploy CI/CD duy nhất trên GitHub Actions từ bản đã commit; mỗi thành viên một IAM user; lên kế hoạch gỡ access key của root | 11/18/2026 | 11/18/2026 | GitHub Actions, IAM |
| **Ngày 5** | • Dựng stack production từ cùng các module Terraform với bộ biến riêng | 11/19/2026 | 11/19/2026 | infra/*.tf |
| **Ngày 6** | • Chạy smoke test trên production và sửa các lỗi riêng của môi trường còn lại | 11/20/2026 | 11/20/2026 | smoke-aws.py |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu khác biệt giữa sập khi tải cao (5xx) và từ chối lịch sự (429 + Retry-After).
* Hiểu vì sao một đường deploy từ bản đã commit giúp hai máy không ghi đè lên nhau.

### **Cài đặt & Thiết lập môi trường**

* API Gateway giới hạn 20/giây, burst 50; luật tốc độ WAF trả 429.
* Stack production dựng từ cùng module Terraform với dev.

### **Kỹ năng thực hành & Vận hành**

* So sánh kết quả load test trước và sau khi sửa, ghi lại cho báo cáo cuối kỳ.
* Chỉ deploy qua CI, không deploy tay từ laptop.
