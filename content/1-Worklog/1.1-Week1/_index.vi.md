---
title: "Nhật ký công việc Tuần 1"
date: 2026-11-07
weight: 1
chapter: false
pre: " <b> 1.1. </b> "
---

# **Nhật ký công việc Tuần 1: Làm quen với dịch vụ AWS cơ bản, Console và AWS CLI**

## **1. Mục tiêu tuần**

* Làm quen và kết nối với các thành viên trong chương trình First Cloud AI Journey (FCAJ).
* Nắm vững các dịch vụ AWS nền tảng và các khái niệm cốt lõi một cách trực quan, thực tế.
* Học cách tương tác và quản lý tài nguyên AWS thông qua cả AWS Management Console và AWS CLI.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Làm quen với các thành viên FCAJ • Đọc và ghi chép nội quy, quy định của đơn vị thực tập | 08/11/2026 | 08/11/2026 | Hướng dẫn nội bộ |
| **Ngày 3** | • Tìm hiểu hạ tầng toàn cầu AWS và các nhóm dịch vụ cốt lõi: Compute, Storage, Networking, Database | 08/12/2026 | 08/12/2026 | AWS Cloud Journey |
| **Ngày 4** | • Đăng ký và kích hoạt tài khoản AWS Free Tier • Tổng quan AWS Console & AWS CLI • Thực hành: Cài đặt & cấu hình AWS CLI, kiểm tra thông tin | 08/13/2026 | 08/13/2026 | AWS Cloud Journey |
| **Ngày 5** | • Học kiến thức nền tảng Amazon EC2: Instance types, AMIs và EBS • Phương thức kết nối SSH và quản lý Key Pair • Tìm hiểu Elastic IP (Chính thức bắt đầu kỳ thực tập) | 08/14/2026 | 08/14/2026 | AWS Cloud Journey |
| **Ngày 6** | • Thực hành: Khởi tạo EC2 instance, kết nối SSH qua terminal, gắn và mount EBS volume | 08/15/2026 | 08/15/2026 | AWS Cloud Journey |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Nắm vững 4 trụ cột điện toán đám mây cốt lõi (Compute, Storage, Networking, Database) và vai trò thực tế của từng nhóm.
* Hiểu rõ cơ chế máy ảo EC2, cách ổ đĩa EBS bảo toàn dữ liệu độc lập khi máy chủ dừng hoạt động và cách Elastic IP cung cấp địa chỉ IP tĩnh cố định.

### **Cài đặt & Thiết lập môi trường**

* Đăng ký thành công và thiết lập bảo mật ban đầu cho tài khoản AWS Free Tier.
* Cấu hình môi trường máy trạm với AWS CLI (Access Key ID, Secret Access Key, vùng mặc định ap-southeast-1 và định dạng output JSON).

### **Kỹ năng thực hành & Vận hành**

* Thao tác thuần thục trên giao diện AWS Management Console và kiểm tra thông tin định danh bằng AWS CLI (aws sts get-caller-identity, tra cứu Availability Zones, tạo key pair).
* Khởi tạo thành công máy ảo Linux EC2, kết nối an toàn qua SSH và gắn kết/mount ổ đĩa EBS vào hệ điều hành.
