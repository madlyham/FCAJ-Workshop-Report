---
title: "Nhật ký công việc Tuần 8"
date: 2026-11-07
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

## **Nhật ký công việc Tuần 8 — Ghép tin chạy nền, các đợt QA, WAF và tài liệu kỹ thuật**

## **1. Mục tiêu tuần**

* Tự động ghép mỗi tin mới với chi nhánh bên mua ở gần, chạy nền (bất đồng bộ).
* Tìm và sửa lỗi qua các đợt QA có cấu trúc và lần load test đầu tiên.
* Bảo vệ lớp biên CloudFront và API công khai bằng AWS WAF, viết tài liệu kỹ thuật cho lập trình viên.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Thứ 2** | • Tái cấu trúc bước ghép chi nhánh từ luồng đồng bộ ban đầu ở Tuần 6 thành tác vụ chạy nền bất đồng bộ bằng geohash + khoảng cách Haversine (`matching.ts`): mỗi tin được gửi tới mọi chi nhánh đã duyệt có vùng phục vụ (1–15 km) bao phủ và xếp ưu tiên tin trong bán kính 5 km | 02/11/2026 | 02/11/2026 | [Tài liệu Amazon DynamoDB](https://docs.aws.amazon.com/dynamodb/), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`matching.ts`) |
| **Thứ 3** | • Tổng hợp 5 đợt QA: 146 mục được ghi nhận và xếp ưu tiên (03/11/2026) | 03/11/2026 | 03/11/2026 | [Repository ReLoop](https://github.com/madlyham/ReLoop), [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) |
| **Thứ 4** | • Load test lần đầu (`loadtest.mjs`, 80 request song song): 26% lỗi `5xx` khi giới hạn Lambda là 10; xin và được nâng giới hạn lên 1.000 | 04/11/2026 | 04/11/2026 | [Tài liệu AWS Lambda](https://docs.aws.amazon.com/lambda/), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`loadtest.mjs`) |
| **Thứ 5** | • Giới hạn AI 20 lượt phân tích/người/ngày (`AI_DAILY_LIMIT`); lưu gợi ý của AI cạnh giá trị người bán chốt (`AILABEL`) | 05/11/2026 | 05/11/2026 | [Tài liệu Amazon Bedrock](https://docs.aws.amazon.com/bedrock/), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`aiService.ts`) |
| **Thứ 6** | • Cấu hình một AWS WAF web ACL duy nhất cho CloudFront (3 bộ luật AWS managed + 2 giới hạn tốc độ theo IP: 100 request/phút cho API công khai và 1.000 request/phút toàn hệ thống) ngày 06/11/2026; viết `RELOOP_TECHNICAL_REFERENCE` (hơn 30 mẫu khóa, toàn bộ route API) | 06/11/2026 | 06/11/2026 | [Tài liệu AWS WAF](https://docs.aws.amazon.com/waf/), [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`infra/waf.tf`) |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu cách tiền tố geohash thu hẹp vùng tìm kiếm để chỉ kiểm tra khoảng cách Haversine chính xác với chi nhánh ở gần.
* Hiểu rằng giới hạn Lambda chạy song song mặc định của tài khoản mới có thể là nút thắt đầu tiên khi tải tăng.

### **Cài đặt & Thiết lập môi trường**

* Một CloudFront WAF web ACL duy nhất ($10.00/tháng) với 3 bộ luật AWS managed và 2 giới hạn tốc độ theo IP (100 request/phút API công khai, 1.000 request/phút toàn hệ thống).
* Giới hạn Lambda song song nâng từ 10 lên 1.000; giới hạn AI mỗi ngày đặt 20 lượt/người.

### **Kỹ năng thực hành & Vận hành**

* Khắc phục các lỗi QA ưu tiên cao nhất và kiểm thử lại các luồng liên quan.
* Viết tài liệu kỹ thuật tham chiếu để thành viên mới tìm được mọi mẫu khóa và route ở một nơi.
