---
title: "Nhật ký công việc Tuần 4"
date: 2026-11-07
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

# **Nhật ký công việc Tuần 4: Kiến trúc ReLoop, Khóa Single-Table và Đăng nhập Cognito với React/Amplify**

## **1. Mục tiêu tuần**

* Chốt kiến trúc hệ thống: một Lambda sau HTTP API, mỗi dịch vụ AWS có adapter nhỏ riêng.
* Thiết kế trước mọi cách truy vấn DynamoDB trong một file khóa.
* Chạy được đăng ký / đăng nhập trọn luồng với Cognito và giao diện React.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Rà soát kiến trúc: một Lambda + HTTP API, các adapter (Table, ImageStore, Analyzer, AuthProvider) để cùng code chạy trên máy cá nhân với bản giả trong bộ nhớ | 10/05/2026 | 10/05/2026 | Ghi chú kiến trúc |
| **Ngày 3** | • Viết backend/src/store/keys.ts: mọi mẫu khóa PK/SK và GSI1 (USER#, LISTING#, QUOTE#, TXN#…); không cho phép quét bảng | 10/06/2026 | 10/06/2026 | keys.ts |
| **Ngày 4** | • Tạo reloop-core-table (On-Demand, PITR) và bucket reloop-device-images; xét chi phí: bỏ nạp/rút tiền ngân hàng, chuyển sang trả tiền khi bàn giao, chọn Lambda arm64 | 10/07/2026 | 10/07/2026 | DynamoDB / S3 Console |
| **Ngày 5** | • User pool Cognito có xác minh email và group (Admins, FinanceAdmins, Partners); trigger đăng ký ghi USER#sub / PROFILE; JWT authorizer cho route riêng tư | 10/08/2026 | 10/08/2026 | Tài liệu Amazon Cognito |
| **Ngày 6** | • Dựng ứng dụng Vite + React reloop-ui, gắn Amplify Authenticator, giao diện màu emerald; thử trọn luồng đăng ký → xác minh email → đăng nhập | 10/09/2026 | 10/09/2026 | reloop-ui |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu cách mẫu adapter giữ nghiệp vụ tách khỏi AWS, nên test chạy được mà không tốn tiền AWS.
* Hiểu cách JWT của Cognito mang ID người dùng và group để API Gateway kiểm trên mọi route riêng tư.

### **Cài đặt & Thiết lập môi trường**

* reloop-core-table (On-Demand, PITR) và bucket reloop-device-images (riêng tư) ở ap-southeast-1.
* User pool Cognito có xác minh email, group người dùng và JWT authorizer trên HTTP API.

### **Kỹ năng thực hành & Vận hành**

* Liệt kê mọi cách truy vấn trong keys.ts trước khi viết code truy vấn.
* Trình diễn cho nhóm luồng đăng ký và đăng nhập đầu tiên chạy được trên ứng dụng React.
