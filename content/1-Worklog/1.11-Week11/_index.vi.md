---
title: "Worklog tuần 11"
date: 2026-11-07
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

# **Nhật ký tuần 11: Tự động hóa hạ tầng với Terraform, CloudFront SPA và kiểm thử Live Smoke Test**

## **1. Mục tiêu trong tuần**

* Đồng bộ toàn bộ hạ tầng bằng mã nguồn Terraform (infra/*.tf) trên nhánh feature/doi-tac-2-cap.
* Triển khai ứng dụng React lên S3 + CloudFront (https://d1cjl1tvcp0r6q.cloudfront.net) và dọn dẹp các tài nguyên thử nghiệm cũ.
* Xác thực tác vụ định kỳ 15 phút qua EventBridge, bảng điều khiển CloudWatch và bộ kiểm thử tự động 25 bước (live AWS smoke test).

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Rà soát trạng thái Terraform state trên S3 và định nghĩa tài nguyên trong thư mục infra/*.tf | 10/20/2025 | 10/20/2025 | infra/*.tf |
| **Ngày 3** | • Di chuyển từ User Pool thủ công sang reloop-dev-user-pool do Terraform quản lý và thống nhất hàm Lambda reloop-dev-api | 10/21/2025 | 10/21/2025 | infra/ & Task O3 |
| **Ngày 4** | • Kiểm thử tác vụ quét nền EventBridge rate(15 minutes) xử lý hết hạn tin, nhắc nhở giao dịch và tạo hóa đơn phí 10.000 VNĐ | 10/22/2025 | 10/22/2025 | modules/jobs & billing |
| **Ngày 5** | • Kiểm tra Dashboard reloop-dev-overview trên CloudWatch và 8 cảnh báo giám sát hệ thống | 10/23/2025 | 10/23/2025 | infra/monitoring.tf |
| **Ngày 6** | • Chạy script kiểm thử scripts/smoke-aws.py trên môi trường AWS thực tế; toàn bộ 25 bước kiểm thử đều vượt qua (ALL PASS) | 10/24/2025 | 10/24/2025 | scripts/smoke-aws.py |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Hiểu rõ sức mạnh của Hạ tầng dưới dạng mã (Terraform): một kịch bản deploy.sh duy nhất tự động build TypeScript, nén arm64 Lambda, áp dụng Terraform và đồng bộ frontend lên CloudFront.

### **Thiết lập & cấu hình môi trường**

* Cấu hình CloudFront Origin Access Control (OAC SigV4) đảm bảo bucket S3 chứa mã nguồn web được bảo mật 100% private.

### **Kỹ năng thực hành & vận hành hệ thống**

* Vượt qua toàn bộ 107 bài unit test Vitest cục bộ (billing, state machines, AI, auth) và 25/25 kịch bản kiểm thử trực tiếp trên AWS thực tế.
