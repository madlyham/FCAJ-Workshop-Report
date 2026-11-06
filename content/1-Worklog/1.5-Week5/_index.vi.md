---
title: "Worklog tuần 5"
date: 2026-11-07
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

# **Nhật ký tuần 5: Khởi động dự án ReLoop, kiến trúc hệ thống và thiết kế bảng dữ liệu**

## **1. Mục tiêu trong tuần**

* Khởi động dự án capstone nhóm: ReLoop (nền tảng kinh tế tuần hoàn thu gom, tái chế thiết bị điện tử).
* Thống nhất kiến trúc hệ thống, phân quyền người dùng và hạ tầng AWS dùng chung tại ap-southeast-1.
* Khởi tạo bảng reloop-core-table trên DynamoDB và bucket reloop-device-images trên Amazon S3.

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Họp nhóm 5 thành viên rà soát đặc tả ReLoop ban đầu và liệt kê 58 điểm thiếu sót (baton.txt) | 09/08/2025 | 09/08/2025 | Tài liệu đặc tả & Ghi chú nhóm |
| **Ngày 3** | • Chốt quy tắc nghiệp vụ (quyetdinh.txt): Viewer, Partner Cấp 1 (bán), Partner Cấp 2 (thu gom trong 5km) và Admin | 09/09/2025 | 09/09/2025 | plan/quyetdinh.txt |
| **Ngày 4** | • Thiết kế cấu trúc khóa Single-Table (keys.ts) cho Users, Partners, Listings, Quotes, Transactions và AI Labels | 09/10/2025 | 09/10/2025 | backend/src/store/keys.ts |
| **Ngày 5** | • Khởi tạo bảng reloop-core-table (On-Demand) và bucket S3 reloop-device-images tại Singapore | 09/11/2025 | 09/11/2025 | AWS Console / CLI |
| **Ngày 6** | • Phân chia khối lượng công việc 12 tuần cho 5 thành viên, đảm nhận nhánh #3 Backend AI & Technical Docs | 09/12/2025 | 09/12/2025 | Kế hoạch nhóm |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Xây dựng luồng vận hành đầu-cuối của ReLoop: người bán đăng ảnh -> AI nhận diện phân loại -> ghép đối tác thu gom trong bán kính 5km qua geohash -> bàn giao trực tiếp -> hóa đơn phí duy trì 10.000 VNĐ/tháng.
* Thiết kế máy trạng thái (assertTransition) và khóa phiên bản (putVersioned) ngăn chặn xung đột trạng thái giao dịch.

### **Thiết lập & cấu hình môi trường**

* Tạo bảng reloop-core-table với cấu trúc PK/SK kết hợp GSI1 (GSI1PK/GSI1SK) và trường TTL tự động dọn dẹp.
* Cấu hình bucket reloop-device-images với quyền truy cập private và tiêu đề CORS đầy đủ.

### **Kỹ năng thực hành & vận hành hệ thống**

* Đóng góp xây dựng quy chuẩn lập trình của nhóm: cấm dùng lệnh Scan trên DynamoDB, bọc mọi lệnh gọi AWS qua Adapter và bắt buộc Idempotency-Key cho các API tạo mới.
