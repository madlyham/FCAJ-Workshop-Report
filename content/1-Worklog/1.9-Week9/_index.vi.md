---
title: "Nhật ký công việc Tuần 9"
date: 2026-11-07
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

# **Nhật ký công việc Tuần 9: Pentest bằng AWS Security Agent, Sửa lỗi, CSP, Email SES và Budgets**

## **1. Mục tiêu tuần**

* Xem kết quả pentest tự động và sửa mọi mục sửa được.
* Bật Content-Security-Policy chặt cho ứng dụng web.
* Gỡ giới hạn email của Cognito bằng Amazon SES và thêm cảnh báo ngân sách.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Xem kết quả pentest hộp đen bằng AWS Security Agent trên web dev (chạy tuần 09/11; 3,63 task-hour): 7 phát hiện, không có mức cao | 11/09/2026 | 11/09/2026 | Báo cáo AWS Security Agent |
| **Ngày 3** | • Sửa và deploy các phát hiện (header bảo mật, thông báo lỗi, kiểm dữ liệu đầu vào); chạy lại smoke test | 11/10/2026 | 11/10/2026 | PR sửa lỗi, smoke-aws.py |
| **Ngày 4** | • Chuyển Content-Security-Policy từ chế độ chỉ báo cáo sang chặn thật trên CloudFront; kiểm mọi trang xem có tài nguyên bị chặn | 11/11/2026 | 11/11/2026 | infra/web.tf |
| **Ngày 5** | • Chuyển email của Cognito sang Amazon SES để đăng ký không bị chặn bởi giới hạn mặc định (~50 email/ngày) | 11/12/2026 | 11/12/2026 | Tài liệu Amazon SES |
| **Ngày 6** | • Cảnh báo AWS Budgets ở mức 50% / 80% số credit còn lại; rà soát số dư credit và chi phí từng dịch vụ | 11/13/2026 | 11/13/2026 | AWS Billing Console |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu cách pentest hộp đen tự động tìm lỗi từ bên ngoài, giống cách kẻ tấn công nhìn hệ thống.
* Hiểu vì sao CSP nên chạy chế độ chỉ báo cáo trước, rồi mới bật chặn khi không trang nào bị lỗi.

### **Cài đặt & Thiết lập môi trường**

* Header CSP chặt, HSTS và X-Frame-Options được áp trên CloudFront.
* Cognito gửi email qua Amazon SES; cảnh báo AWS Budgets ở mức 50% / 80%.

### **Kỹ năng thực hành & Vận hành**

* Đóng mọi phát hiện pentest sửa được và xác nhận bằng kiểm thử lại.
* Giữ pentest trong ngân sách bằng cách dừng ở khoảng 3,5 task-hour.
