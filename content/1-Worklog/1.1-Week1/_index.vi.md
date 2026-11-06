---
title: "Worklog tuần 1"
date: 2026-11-07
weight: 1
chapter: false
pre: " <b> 1.1. </b> "
---

# **Nhật ký tuần 1: Làm quen với dịch vụ AWS cơ bản, Console và AWS CLI**

## **1. Mục tiêu trong tuần**

* Làm quen và kết nối với các thành viên trong chương trình First Cloud AI Journey (FCAJ).
* Nắm vững các dịch vụ AWS nền tảng và các khái niệm cốt lõi một cách trực quan, thực tế.
* Học cách tương tác và quản lý tài nguyên AWS thông qua cả AWS Management Console và AWS CLI.

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Làm quen với các thành viên FCAJ • Đọc và ghi chép nội quy, quy định của đơn vị thực tập | 08/11/2025 | 08/11/2025 | Hướng dẫn nội bộ |
| **Ngày 3** | • Tìm hiểu hạ tầng toàn cầu AWS và các nhóm dịch vụ cốt lõi: Compute, Storage, Networking, Database | 08/12/2025 | 08/12/2025 | AWS Cloud Journey |
| **Ngày 4** | • Đăng ký và kích hoạt tài khoản AWS Free Tier • Tổng quan AWS Console & AWS CLI • Thực hành: Cài đặt & cấu hình AWS CLI, kiểm tra thông tin | 08/13/2025 | 08/13/2025 | AWS Cloud Journey |
| **Ngày 5** | • Học kiến thức nền tảng Amazon EC2: Instance types, AMIs và EBS • Phương thức kết nối SSH và quản lý Key Pair • Tìm hiểu Elastic IP | 08/14/2025 | 08/15/2025 | AWS Cloud Journey |
| **Ngày 6** | • Thực hành: Khởi tạo EC2 instance, kết nối SSH qua terminal, gắn và mount EBS volume | 08/15/2025 | 08/15/2025 | AWS Cloud Journey |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Nắm vững 4 trụ cột đám mây chính (Compute, Storage, Networking, Database) và vai trò thực tế của từng nhóm dịch vụ.
* Hiểu rõ máy chủ ảo EC2, cách ổ cứng EBS bảo vệ dữ liệu khi server dừng hoạt động, và vai trò của Elastic IP như một địa chỉ IP tĩnh cố định.

### **Thiết lập & cấu hình môi trường**

* Đăng ký và thiết lập bảo mật cho tài khoản AWS Free Tier cá nhân.
* Cấu hình môi trường máy tính với AWS CLI (Access Key ID, Secret Access Key, region mặc định ap-southeast-1 và định dạng JSON).

### **Kỹ năng thực hành & vận hành hệ thống**

* Thao tác trên AWS Management Console và thực hiện các lệnh kiểm tra cơ bản qua AWS CLI (aws sts get-caller-identity, kiểm tra region/AZ, tạo key pairs, kiểm tra instance).
* Khởi chạy máy chủ ảo Linux EC2, kết nối SSH từ dòng lệnh và mount phân vùng ổ cứng EBS thành công.
