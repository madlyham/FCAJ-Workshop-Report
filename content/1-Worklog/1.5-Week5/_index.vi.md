---
title: "Nhật ký công việc Tuần 5"
date: 2026-11-07
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

# **Nhật ký công việc Tuần 5: Khởi động Đồ án ReLoop, Kiến trúc Hệ thống & Thiết kế Khóa Single-Table**

## **1. Mục tiêu tuần**

* Chính thức khởi động đồ án tốt nghiệp nền tảng tuần hoàn đồ điện tử ReLoop cùng nhóm 5 thành viên.
* Rà soát tài liệu đặc tả, làm rõ các điểm thiếu sót và phân định vai trò nghiệp vụ rõ ràng.
* Thiết kế cấu trúc khóa Single-table DynamoDB đáp ứng toàn bộ luồng người dùng, bài đăng, báo giá và giao dịch.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Họp nhóm 5 thành viên rà soát đặc tả ReLoop ban đầu và liệt kê 58 điểm thiếu sót (baton.txt) | 09/07/2026 | 09/07/2026 | Tài liệu đặc tả & Ghi chú nhóm |
| **Ngày 3** | • Chốt quy tắc nghiệp vụ: Viewer, Partner Cấp 1 (bán), Partner Cấp 2 (thu gom trong 5km) và Admin | 09/08/2026 | 09/08/2026 | plan/quyetdinh.txt |
| **Ngày 4** | • Thiết kế cấu trúc khóa Single-table (keys.ts) cho Users, Partners, Listings, Quotes, Transactions và AI Labels | 09/09/2026 | 09/09/2026 | backend/src/store/keys.ts |
| **Ngày 5** | • Khởi tạo bảng reloop-core-table (On-Demand) và S3 bucket reloop-device-images tại vùng Singapore | 09/10/2026 | 09/10/2026 | AWS Console / CLI |
| **Ngày 6** | • Phân chia khối lượng công việc cho 5 thành viên; đảm nhận vị trí Lead Backend-AI & Tài liệu kỹ thuật | 09/11/2026 | 09/11/2026 | Kế hoạch phân công nhóm |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Chuyển dịch tư duy từ CSDL quan hệ nhiều bảng sang kiến trúc Single-table DynamoDB sử dụng kỹ thuật nạp chồng khóa.
* Xây dựng máy trạng thái hữu hạn (State Machine) quản lý chặt chẽ vòng đời giao dịch thu hồi thiết bị.

### **Cài đặt & Thiết lập môi trường**

* Khởi tạo bảng DynamoDB reloop-core-table và S3 bucket lưu trữ ảnh tại khu vực ap-southeast-1 (Singapore).
* Thiết lập cấu trúc repository Git và quy chuẩn phân nhánh cho cả nhóm.

### **Kỹ năng thực hành & Vận hành**

* Tài liệu hóa hơn 30 mẫu khóa PK/SK trong file keys.ts.
* Kiểm thử khả năng truy vấn theo phân vùng khóa bằng dữ liệu mẫu giả định.
