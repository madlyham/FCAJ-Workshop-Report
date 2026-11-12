---
title: "Nhật ký công việc Tuần 11"
date: 2026-11-07
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

# **Nhật ký công việc Tuần 11: Chuyển Terraform State, Dọn dẹp Tài nguyên và Rà soát Chi phí**

## **1. Mục tiêu tuần**

* Đưa toàn bộ Terraform state về một nơi an toàn, có versioning cho từng môi trường.
* Xóa các tài nguyên cũ còn sót lại từ giai đoạn dựng tay ban đầu.
* So sánh chi phí thực với ước tính và xác nhận credit đủ dùng tới 28/02/2027.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Lên kế hoạch chuyển state: liệt kê mọi tài nguyên, sao lưu các file state hiện có | 11/23/2026 | 11/23/2026 | Tài liệu Terraform |
| **Ngày 3** | • Chuyển state sang backend S3 có versioning (mỗi môi trường một key) và xác nhận terraform plan không có thay đổi | 11/24/2026 | 11/24/2026 | infra/backend.tf |
| **Ngày 4** | • Tìm các tài nguyên tạo tay trong tuần 1–5 (user pool cũ, API thử, bucket thực hành) mà Terraform không quản lý | 11/25/2026 | 11/25/2026 | AWS Console, Resource Explorer |
| **Ngày 5** | • Xóa các tài nguyên không dùng sau khi nhóm đồng ý; chạy lại smoke test trên dev và production | 11/26/2026 | 11/26/2026 | smoke-aws.py |
| **Ngày 6** | • Rà soát chi phí trên Cost Explorer so với ước tính (khoảng 18,70 USD/tháng, phần lớn là WAF); xác nhận credit đủ chạy tới 28/02/2027 | 11/27/2026 | 11/27/2026 | AWS Cost Explorer |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Học cách chuyển Terraform state an toàn mà không tạo lại tài nguyên đang chạy.
* Hiểu rằng phần lớn hóa đơn là chi phí cố định của WAF, còn các dịch vụ tính theo mức dùng dưới 1 USD/tháng.

### **Cài đặt & Thiết lập môi trường**

* Backend state S3 có versioning, mỗi môi trường một key.
* Tài khoản đã dọn sạch tài nguyên sót lại không được quản lý.

### **Kỹ năng thực hành & Vận hành**

* Xác nhận terraform plan sạch sau khi chuyển state rồi mới xóa tài nguyên.
* Viết bản tóm tắt chi phí ngắn cho báo cáo cuối kỳ.
