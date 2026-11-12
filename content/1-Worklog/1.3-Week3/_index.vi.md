---
title: "Nhật ký công việc Tuần 3"
date: 2026-11-07
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

# **Nhật ký công việc Tuần 3: Đặc tả ReLoop, 45 Quyết định Nghiệp vụ, Watch Party AI Day và Tọa đàm Dr. Werner**

## **1. Mục tiêu tuần**

* Chuyển bản đặc tả ReLoop v1.0 thành các quyết định nghiệp vụ rõ ràng, có văn bản.
* Dựng repository, CI và cách làm việc của nhóm (vai trò, quy tắc deploy, quyền truy cập AWS).
* Tham dự Sự kiện 2 (Watch Party AWS Cloud and AI Day Hanoi) và Sự kiện 3 (Tọa đàm cùng Tiến sĩ Werner Vogels).

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Đọc trọn bản đặc tả v1.0 (1.189 đoạn); liệt kê 58 chỗ còn thiếu và câu hỏi mở | 09/28/2026 | 09/28/2026 | Đặc tả ReLoop v1.0 |
| **Ngày 3** | • Tham dự [Sự kiện 2: Watch Party AWS Cloud and AI Day Hanoi](../../4-eventparticipated/4.2-event2/) (08:00 – 17:00 tại Văn phòng AWS Việt Nam, Bitexco Tầng 26). Tìm hiểu sâu về AI Agent doanh nghiệp, kỹ nghệ nền tảng và tối ưu chi phí FinOps. | 09/29/2026 | 09/29/2026 | Sự kiện 2 / Văn phòng AWS Việt Nam |
| **Ngày 4** | • Xác định vai trò người dùng (Khách, Đối tác cấp 1, Đối tác cấp 2, Admin, Admin tài chính) và cùng nhóm xử lý các chỗ thiếu trong đặc tả | 09/30/2026 | 09/30/2026 | Họp nhóm |
| **Ngày 5** | • Viết 45 quyết định nghiệp vụ (QĐ-01 → QĐ-45); tạo Git repository và CI GitHub Actions (typecheck + test cho mỗi pull request) | 10/01/2026 | 10/01/2026 | Nhật ký quyết định, GitHub Actions |
| **Ngày 6** | • Tham dự [Sự kiện 3: Tọa đàm Fireside Chat cùng Tiến sĩ Werner Vogels](../../4-eventparticipated/4.3-event3/) (10:30 – 12:00 tại Bitexco Financial Tower; Keynote bởi CTO Amazon). Thống nhất phân công 5 người (phần của tôi: backend AI, hạ tầng và tài liệu kỹ thuật) và quy tắc deploy: một đường deploy duy nhất, mỗi thành viên một IAM user. | 10/02/2026 | 10/02/2026 | Sự kiện 3 / Keynote Amazon |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu rằng ghi quyết định thành văn bản (có mã như QĐ-07) giúp tránh tranh luận lặp lại và review code nhanh hơn.
* Thấm câu của Tiến sĩ Werner Vogels 'Mọi thứ đều có thể hỏng, mọi lúc', định hướng lựa chọn job bất đồng bộ, idempotency và ghi có điều kiện.
* Áp dụng thông điệp FinOps từ AI Day: chọn đúng kiến trúc và khung chi phí trước khi chọn công cụ mới nhất.

### **Cài đặt & Thiết lập môi trường**

* Git repository có bảo vệ nhánh và workflow GitHub Actions chạy typecheck, test.
* Nhật ký quyết định chung (QĐ-01 → QĐ-45) và danh sách 58 chỗ thiếu đã xử lý hoặc tạm hoãn.

### **Kỹ năng thực hành & Vận hành**

* Cùng nhóm rà soát đặc tả và biến câu hỏi mở thành quyết định trong một tuần.
* Tham dự trọn ngày Watch Party AI Day và buổi keynote của Tiến sĩ Werner tại Bitexco Financial Tower.
