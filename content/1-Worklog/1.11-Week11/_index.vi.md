---
title: "Nhật ký công việc Tuần 11"
date: 2026-11-07
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

# **Nhật ký công việc Tuần 11: Hạ tầng Dưới dạng Mã (IaC), Kiểm thử Live AWS & Cloud & AI Meetup**

## **1. Mục tiêu tuần**

* Đồng bộ toàn bộ hạ tầng bằng Terraform (infra/*.tf) trên nhánh tính năng feature/doi-tac-2-cap.
* Triển khai giao diện React lên S3 + CloudFront (https://d1cjl1tvcp0r6q.cloudfront.net) và xóa bỏ các tài nguyên thử nghiệm thủ công.
* Kiểm chứng tác vụ quét nền EventBridge chu kỳ 15 phút, bảng điều khiển CloudWatch và kịch bản 25 bước kiểm thử trực tiếp trên AWS.
* Tham dự Sự kiện 4 (Cloud & AI Infrastructure Meetup) tại Bitexco Financial Tower để phân tích thông lượng lưu trữ đối tượng và kiến trúc phân phối GPU.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Rà soát trạng thái Terraform state trên S3 và định nghĩa tài nguyên trong thư mục infra/*.tf | 10/19/2026 | 10/19/2026 | infra/*.tf |
| **Ngày 3** | • Di chuyển từ User Pool thủ công sang reloop-dev-user-pool do Terraform quản lý và thống nhất hàm Lambda reloop-dev-api | 10/20/2026 | 10/20/2026 | infra/ & Task O3 |
| **Ngày 4** | • Kiểm thử tác vụ EventBridge chu kỳ 15 phút (LISTING_EXPIRE, TX_REMIND, TX_AUTO_COMPLETE và sinh hóa đơn 10.000 VNĐ) | 10/21/2026 | 10/21/2026 | modules/jobs & billing |
| **Ngày 5** | • Kiểm tra bảng giám sát CloudWatch reloop-dev-overview và 8 cảnh báo (UnhandledErrors, AiFailures, p95 latency) | 10/22/2026 | 10/22/2026 | infra/monitoring.tf |
| **Ngày 6** | • Chạy kiểm thử tự động trực tiếp trên AWS với AWS_PROFILE=reloop; toàn bộ 25/25 bước vượt qua (ALL PASS) | 10/23/2026 | 10/23/2026 | scripts/smoke-aws.py |
| **Ngày 7** | • Tham dự [Sự kiện 4: Cloud & AI Infrastructure Meetup](../../4-eventparticipated/4.4-event4/) (10:30 – 12:00 tại Bitexco Financial Tower). Tìm hiểu sâu về lưu trữ đối tượng cho AI (chuẩn S3 API ở quy mô lớn), tối ưu cụm GPU phục vụ LLM và kiến trúc bộ nhớ router. | 10/24/2026 | 10/24/2026 | Sự kiện 4 / OMZ, Viettel & AWS |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Chứng kiến sức mạnh của Infrastructure as Code (deploy.sh) loại bỏ triệt để sai sót con người—một lệnh duy nhất biên dịch TypeScript, đóng gói Lambda arm64, áp dụng Terraform và đồng bộ giao diện Vite lên CloudFront.
* Kiểm chứng chiến lược thông lượng S3 và bộ nhớ đệm CloudFront SPA dựa trên các mô hình lưu trữ đối tượng thực tế được chia sẻ tại Cloud & AI Infrastructure Meetup.

### **Cài đặt & Thiết lập môi trường**

* Cấu hình CloudFront Origin Access Control (OAC SigV4) giữ S3 bucket riêng tư 100% trong khi phân phối ứng dụng web qua HTTPS.
* Thiết lập kho lưu trữ trạng thái S3 remote backend kết hợp khóa bảng DynamoDB chống xung đột.

### **Kỹ năng thực hành & Vận hành**

* Vượt qua 107 bài unit test Vitest cục bộ (billing, state machines, AI, auth) và đạt điểm tuyệt đối 25/25 kịch bản live smoke test trên AWS.
* Tham dự trọn vẹn Sự kiện 4 tại Bitexco, tiếp thu các kỹ thuật vận hành lưu trữ tải cao và điều phối GPU.
