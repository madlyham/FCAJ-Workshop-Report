---
title: "Nhật ký công việc Tuần 2"
date: 2026-11-07
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

# **Nhật ký công việc Tuần 2: Bảo mật IAM, Kiến trúc VPC và Phân lập mạng**

## **1. Mục tiêu tuần**

* Hiểu sâu về cơ chế phân quyền bảo mật (IAM) và mạng ảo biệt lập (VPC) trên AWS.
* Chấm dứt việc dùng tài khoản Root cho công việc hàng ngày, thiết lập chuẩn Users, Groups, Roles và MFA.
* Xây dựng kiến trúc mạng phân lớp an toàn với Public Subnet và Private Subnet.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Học kiến thức IAM cơ bản: Users, Groups, Roles và JSON policies | 08/17/2026 | 08/17/2026 | AWS Cloud Journey |
| **Ngày 3** | • Thực hành: Tạo IAM Admin user & kích hoạt MFA; Kiểm thử quy tắc role tùy chỉnh theo nguyên tắc đặc quyền tối thiểu | 08/18/2026 | 08/18/2026 | AWS Cloud Journey |
| **Ngày 4** | • Tìm hiểu kiến thức VPC: Public Subnet, Private Subnet, Internet Gateway và bảng định tuyến Route Table | 08/19/2026 | 08/19/2026 | AWS Cloud Journey |
| **Ngày 5** | • Phân biệt Security Groups (tường lửa cấp máy ảo) và Network ACLs (tường lửa cấp subnet) | 08/20/2026 | 08/20/2026 | AWS Cloud Journey |
| **Ngày 6** | • Thực hành: Xây dựng VPC tùy chỉnh với 2 public subnets và 2 private subnets; Giới hạn cổng truy cập Security Group | 08/21/2026 | 08/21/2026 | AWS Cloud Journey |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Nắm vững nguyên tắc đặc quyền tối thiểu (Least Privilege): chỉ cấp đúng quyền cần thiết để vận hành.
* Hiểu rõ tại sao Private Subnet bảo vệ cơ sở dữ liệu và máy chủ nội bộ khỏi các cuộc tấn công quét mạng trực tiếp từ Internet.

### **Cài đặt & Thiết lập môi trường**

* Khởi tạo IAM Admin riêng biệt kèm xác thực 2 lớp (MFA), cất giữ an toàn thông tin tài khoản Root.
* Thiết lập dải mạng VPC tùy chỉnh (10.0.0.0/16) phân bố qua nhiều Availability Zones.

### **Kỹ năng thực hành & Vận hành**

* Viết và kiểm tra chính sách IAM định dạng JSON, chỉ cho phép các hành động đọc/ghi cần thiết.
* Kiểm tra phân lập mạng: máy chủ ở Public Subnet truy cập được Internet qua IGW trong khi máy chủ Private Subnet hoàn toàn không nhận inbound từ ngoài.
