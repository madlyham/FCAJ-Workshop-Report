---
title: "Nhật ký công việc Tuần 4"
date: 2026-11-07
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

# **Nhật ký công việc Tuần 4: Kiến trúc ReLoop, Đề xuất Phần 1 và Bắt đầu phát triển**

## **1. Mục tiêu tuần**

* Chốt kiến trúc hệ thống: một Lambda sau HTTP API, mỗi dịch vụ AWS có adapter nhỏ riêng.
* Thiết kế trên giấy mọi cách truy vấn DynamoDB trước khi viết code.
* Hoàn tất kiểm tra chi phí và tính khả thi, nộp Đề xuất (Phần 1).
* Bắt đầu phát triển ReLoop vào thứ Sáu: bảng chính, bucket ảnh, đăng nhập Cognito và giao diện React.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Rà soát kiến trúc: một Lambda + HTTP API, các adapter (Table, ImageStore, Analyzer, AuthProvider) để sau này cùng code chạy trên máy cá nhân với bản giả trong bộ nhớ | 10/05/2026 | 10/05/2026 | Ghi chú kiến trúc |
| **Ngày 3** | • Thiết kế trên giấy mọi cách truy vấn DynamoDB: mẫu khóa PK/SK và GSI1 (USER#, LISTING#, QUOTE#, TXN#…); quy tắc: không quét bảng | 10/06/2026 | 10/06/2026 | Bảng cách truy vấn |
| **Ngày 4** | • Kiểm tra chi phí và tính khả thi: bỏ nạp/rút tiền ngân hàng, chuyển sang trả tiền khi bàn giao, chọn Lambda arm64, DynamoDB On-Demand; soạn bản nháp đề xuất | 10/07/2026 | 10/07/2026 | AWS Pricing Calculator |
| **Ngày 5** | • Hoàn thiện và **nộp Đề xuất (Phần 1)** (vấn đề, kiến trúc, cách truy vấn, ước tính chi phí, lộ trình) | 10/08/2026 | 10/08/2026 | [Đề xuất](../../2-proposal/) |
| **Ngày 6** | • **Bắt đầu phát triển ReLoop:** viết backend/src/store/keys.ts từ bảng cách truy vấn; tạo reloop-core-table (On-Demand, PITR) và bucket reloop-device-images; user pool Cognito có xác minh email, group (Admins, FinanceAdmins, Partners), trigger đăng ký ghi USER#sub / PROFILE và JWT authorizer cho route riêng tư; dựng ứng dụng Vite + React reloop-ui với Amplify Authenticator; thử đăng ký → xác minh email → đăng nhập | 10/09/2026 | 10/09/2026 | Tài liệu Amazon Cognito, reloop-ui |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu cách mẫu adapter giữ nghiệp vụ tách khỏi AWS, nên test chạy được mà không tốn tiền AWS.
* Hiểu cách JWT của Cognito mang ID người dùng và group để API Gateway kiểm trên mọi route riêng tư.

### **Cài đặt & Thiết lập môi trường**

* Đã nộp Đề xuất (Phần 1) ngày 10/08/2026.
* Từ 10/09/2026: reloop-core-table (On-Demand, PITR) và bucket reloop-device-images (riêng tư) ở ap-southeast-1.
* User pool Cognito có xác minh email, group người dùng và JWT authorizer trên HTTP API.

### **Kỹ năng thực hành & Vận hành**

* Liệt kê mọi cách truy vấn trước khi viết code truy vấn, rồi chuyển thành keys.ts ngay ngày đầu phát triển.
* Trình diễn cho nhóm luồng đăng ký và đăng nhập đầu tiên chạy được trên ứng dụng React vào cuối ngày phát triển đầu tiên.
