---
title: "Nhật ký công việc Tuần 1"
date: 2026-11-07
weight: 1
chapter: false
pre: " <b> 1.1. </b> "
---

# **Nhật ký công việc Tuần 1: Nền tảng AWS: Console, CLI, EC2, IAM và VPC**

## **1. Mục tiêu tuần**

* Làm quen với AWS Management Console, AWS CLI và Free Tier.
* Khởi tạo và quản lý tài nguyên tính toán (EC2, EBS, Elastic IP) an toàn.
* Ngừng dùng tài khoản root hằng ngày và dựng mạng cơ bản an toàn (IAM + VPC).

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Nhập môn chương trình First Cloud Journey; làm quen AWS Console, region, Availability Zone và giới hạn Free Tier | 09/14/2026 | 09/14/2026 | AWS Cloud Journey |
| **Ngày 3** | • Cài đặt và cấu hình AWS CLI v2 (profile, region mặc định ap-southeast-1); chạy các lệnh chỉ đọc đầu tiên | 09/15/2026 | 09/15/2026 | Tài liệu AWS CLI |
| **Ngày 4** | • Thực hành: tạo EC2, gắn ổ EBS, gán Elastic IP, sau đó dừng/xóa để tránh phát sinh phí | 09/16/2026 | 09/16/2026 | AWS Cloud Journey |
| **Ngày 5** | • IAM cơ bản: user, group, role, policy JSON; tạo IAM admin có MFA và cất giữ tài khoản root | 09/17/2026 | 09/17/2026 | AWS Cloud Journey |
| **Ngày 6** | • VPC cơ bản: dựng VPC tùy chỉnh (10.0.0.0/16) với subnet public/private, Internet Gateway, route table, so sánh Security Group và NACL | 09/18/2026 | 09/18/2026 | AWS Cloud Journey |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu mô hình trách nhiệm chia sẻ và cách region, Availability Zone mang lại tính sẵn sàng cao.
* Nắm nguyên tắc quyền tối thiểu: chỉ cấp đúng quyền công việc cần.
* Hiểu vì sao subnet private giúp cơ sở dữ liệu và máy chủ nội bộ tránh bị quét trực tiếp từ Internet.

### **Cài đặt & Thiết lập môi trường**

* Cấu hình AWS CLI v2 với profile riêng và region ap-southeast-1.
* Tạo IAM admin có MFA; thông tin root được cất an toàn, không dùng hằng ngày.
* VPC tùy chỉnh trải trên 2 Availability Zone với 2 subnet public và 2 subnet private.

### **Kỹ năng thực hành & Vận hành**

* Tạo, kết nối và dọn dẹp tài nguyên EC2 mà không để sót mục tính phí.
* Viết và kiểm thử policy IAM JSON chỉ cho phép đúng các thao tác đọc/ghi cần thiết.
* Kiểm tra phân lập mạng: subnet public ra Internet qua IGW, subnet private không nhận kết nối từ ngoài vào.
