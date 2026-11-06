---
title: "Worklog tuần 2"
date: 2026-11-07
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

# **Nhật ký tuần 2: Quản lý quyền IAM và xây dựng hạ tầng mạng VPC**

## **1. Mục tiêu trong tuần**

* Hiểu cách AWS quản lý quy tắc phân quyền (IAM) và mạng ảo riêng (VPC).
* Ngừng sử dụng tài khoản root cho công việc hàng ngày, thiết lập người dùng IAM và vai trò (Roles) đúng chuẩn.
* Xây dựng mạng ảo cô lập với các phân vùng public/private và quy tắc tường lửa cổng (Security Groups/NACLs).

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Học kiến thức IAM cơ bản: Users, Groups, Roles và JSON policies | 08/18/2025 | 08/18/2025 | AWS Cloud Journey |
| **Ngày 3** | • Thực hành: Tạo IAM Admin user & kích hoạt MFA; Kiểm thử quy tắc role tùy chỉnh theo nguyên tắc đặc quyền tối thiểu | 08/19/2025 | 08/19/2025 | AWS Cloud Journey |
| **Ngày 4** | • Tìm hiểu nền tảng VPC: Public subnet, Private subnet, Internet Gateway và Route Tables | 08/20/2025 | 08/20/2025 | AWS Cloud Journey |
| **Ngày 5** | • Phân biệt Security Groups (tường lửa cấp instance có trạng thái) và NACLs (tường lửa cấp subnet không trạng thái) | 08/21/2025 | 08/21/2025 | AWS Cloud Journey |
| **Ngày 6** | • Thực hành: Xây dựng VPC tùy chỉnh với public & private subnets; Cấu hình Security Group chỉ mở cổng 22 (SSH) và 80 (HTTP) | 08/22/2025 | 08/22/2025 | AWS Cloud Journey |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Nắm vững nguyên lý IAM: thay vì lưu mã khóa trực tiếp trong code, gán IAM Role với chính sách quyền hạn nghiêm ngặt cho dịch vụ.
* Hiểu cách VPC phân tách tài nguyên đám mây an toàn, chia ranh giới rõ ràng giữa ứng dụng public và cơ sở dữ liệu private.

### **Thiết lập & cấu hình môi trường**

* Tạo IAM User Group bật xác thực MFA và chuyển cấu hình AWS CLI cục bộ sang tài khoản có quyền hạn phù hợp thay vì root.
* Xây dựng thành công VPC tùy chỉnh với bảng định tuyến Route Tables và Internet Gateway.

### **Kỹ năng thực hành & vận hành hệ thống**

* Cấu hình các quy tắc Security Group chặn lưu lượng lạ, chỉ cho phép cổng SSH (22) và HTTP (80).
* Khắc phục thành công các lỗi AccessDenied bằng cách phân tích và điều chỉnh chính sách JSON trong IAM.
