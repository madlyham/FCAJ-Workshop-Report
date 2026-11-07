---
title: "Nhật ký công việc Tuần 6"
date: 2026-11-07
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

# **Nhật ký công việc Tuần 6: Xác thực với Amazon Cognito & Tích hợp Giao diện React/Amplify**

## **1. Mục tiêu tuần**

* Cấu hình Amazon Cognito User Pool quản lý đăng ký, đăng nhập an toàn cho khách hàng và đối tác.
* Kết nối trigger Lambda Post-Confirmation tự động khởi tạo hồ sơ người dùng trong DynamoDB.
* Xây dựng khung ứng dụng web React với AWS Amplify UI và tùy biến giao diện theo nhận diện thương hiệu ReLoop.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Cấu hình Cognito User Pool và App Client (không dùng client secret để an toàn cho ứng dụng web) | 09/14/2026 | 09/14/2026 | Tài liệu AWS Cognito |
| **Ngày 3** | • Thiết lập trigger Lambda reloop-auth-post-confirmation ghi bản ghi USER#<sub\> / PROFILE vào DynamoDB | 09/15/2026 | 09/15/2026 | AWS Lambda + Cognito |
| **Ngày 4** | • Xử lý lỗi RemoteSigned trên PowerShell, khởi tạo dự án reloop-ui với Vite + React, cài đặt thư viện aws-amplify | 09/16/2026 | 09/16/2026 | Vite & Amplify Docs |
| **Ngày 5** | • Tùy biến form đăng ký Amplify <Authenticator> với các trường bắt buộc (địa chỉ, số điện thoại, email) | 09/17/2026 | 09/17/2026 | @aws-amplify/ui-react |
| **Ngày 6** | • Tùy biến ThemeProvider với tông màu xanh ngọc ReLoop; chuyển cơ chế gửi mã từ SMS sang Email miễn phí | 09/18/2026 | 09/18/2026 | Cognito Console & App.jsx |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu rõ kiến trúc JWT token: ID Token chứa thông tin định danh, Access Token dùng ủy quyền API, Refresh Token duy trì phiên làm việc.
* Nắm vững cơ chế Post-Confirmation hook đảm bảo tính nhất quán dữ liệu giữa tài khoản Cognito và CSDL DynamoDB.

### **Cài đặt & Thiết lập môi trường**

* Cấu hình Cognito User Pool với thuộc tính tùy chỉnh và xác thực qua email.
* Tích hợp thành công bộ thư viện giao diện @aws-amplify/ui-react vào ứng dụng Vite.

### **Kỹ năng thực hành & Vận hành**

* Kiểm thử thông suốt luồng: Đăng ký -> Nhận mã OTP qua email -> Kích hoạt tài khoản -> Tự động sinh bản ghi trong DynamoDB.
* Bảo vệ an toàn các endpoint API Gateway bằng bộ xác thực Cognito JWT Authorizer.
