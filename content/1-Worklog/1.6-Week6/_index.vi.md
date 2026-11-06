---
title: "Worklog tuần 6"
date: 2026-11-07
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

# **Nhật ký tuần 6: Xác thực người dùng qua Amazon Cognito và tích hợp giao diện React Amplify**

## **1. Mục tiêu trong tuần**

* Thiết lập quy trình đăng ký, đăng nhập người dùng với Amazon Cognito (ReLoop-user-pool).
* Cấu hình Lambda trigger Post-Confirmation tự động tạo bản ghi hồ sơ trong DynamoDB khi tài khoản xác thực email.
* Xây dựng và tùy biến giao diện đăng nhập React + Vite cục bộ với thư viện Amplify UI.

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Cấu hình Cognito User Pool và App Client (không dùng client secret để an toàn cho ứng dụng web) | 09/15/2025 | 09/15/2025 | Tài liệu AWS Cognito |
| **Ngày 3** | • Thiết lập trigger Lambda reloop-auth-post-confirmation ghi bản ghi USER#<sub\> / PROFILE vào DynamoDB | 09/16/2025 | 09/16/2025 | AWS Lambda + Cognito |
| **Ngày 4** | • Xử lý lỗi chính sách thực thi PowerShell trên Windows, tạo khung dự án reloop-ui bằng Vite + React, cài đặt aws-amplify | 09/17/2025 | 09/17/2025 | Tài liệu Vite & Amplify |
| **Ngày 5** | • Bổ sung các trường bắt buộc (địa chỉ, số điện thoại, email) vào form đăng ký của component <Authenticator\> | 09/18/2025 | 09/18/2025 | @aws-amplify/ui-react |
| **Ngày 6** | • Tùy biến giao diện đăng nhập theo tone xanh ngọc lục bảo và chuyển phương thức gửi mã OTP Cognito từ SMS sang Email miễn phí | 09/19/2025 | 09/19/2025 | Cognito Console & App.jsx |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Rút ra bài học thực tế với Cognito: 1) Thuộc tính bắt buộc (Required Attributes) bị khóa vĩnh viễn sau khi tạo User Pool, và 2) cần chọn rõ Email verification để không bị lỗi gửi SMS tốn phí qua SNS.

### **Thiết lập & cấu hình môi trường**

* Khởi chạy máy chủ phát triển Vite tại http://localhost:5173 kết nối ổn định với Cognito User Pool tại Singapore.
* Giữ các trường địa chỉ và số điện thoại bắt buộc trong form phục vụ giao nhận thiết bị thực tế.

### **Kỹ năng thực hành & vận hành hệ thống**

* Hoàn thành chu trình đăng ký thử nghiệm trên giao diện ReLoop, xác thực mã OTP email và xác minh bản ghi người dùng xuất hiện trong bảng reloop-core-table.
