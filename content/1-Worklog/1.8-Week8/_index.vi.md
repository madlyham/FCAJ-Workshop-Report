---
title: "Nhật ký công việc Tuần 8"
date: 2026-11-07
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

# **Nhật ký công việc Tuần 8: Ghép tin chạy nền, Các đợt QA, WAF và Tài liệu cho Lập trình viên**

## **1. Mục tiêu tuần**

* Tự động ghép mỗi tin mới với chi nhánh bên mua ở gần, chạy ở nền.
* Tìm và sửa lỗi qua các đợt QA có cấu trúc và lần load test đầu tiên.
* Bảo vệ web và đăng nhập bằng AWS WAF, viết tài liệu cho lập trình viên.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Ghép tin chạy nền bằng geohash + khoảng cách Haversine: mỗi tin được gửi tới mọi chi nhánh đã duyệt có vùng phục vụ (1–15 km) bao phủ; tin trong 5 km được xếp trước | 11/02/2026 | 11/02/2026 | matching.ts |
| **Ngày 3** | • Tổng hợp 5 đợt QA: 146 mục được ghi nhận và xếp ưu tiên (03/11) | 11/03/2026 | 11/03/2026 | Bảng theo dõi QA |
| **Ngày 4** | • Load test lần đầu (loadtest.mjs, 80 request song song): 26% lỗi 5xx khi giới hạn Lambda là 10; xin và được nâng giới hạn lên 1.000 | 11/04/2026 | 11/04/2026 | loadtest.mjs, Service Quotas |
| **Ngày 5** | • Giới hạn AI 20 lượt phân tích/người/ngày (AI_DAILY_LIMIT); lưu gợi ý của AI cạnh giá trị người bán chốt (AILABEL) | 11/05/2026 | 11/05/2026 | aiService.ts |
| **Ngày 6** | • Gắn AWS WAF cho CloudFront (bộ luật có sẵn + giới hạn tốc độ) và cho user pool Cognito (giới hạn đăng nhập) (06/11); viết RELOOP_TECHNICAL_REFERENCE (hơn 30 mẫu khóa, toàn bộ route API) | 11/06/2026 | 11/06/2026 | infra/waf.tf, RELOOP_TECHNICAL_REFERENCE |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu cách tiền tố geohash thu hẹp vùng tìm kiếm để chỉ kiểm khoảng cách Haversine chính xác với chi nhánh ở gần.
* Hiểu rằng giới hạn Lambda chạy song song mặc định của tài khoản mới có thể là nút thắt đầu tiên khi tải tăng.

### **Cài đặt & Thiết lập môi trường**

* Hai WAF web ACL: reloop-dev-web (CloudFront) và reloop-dev-auth (Cognito).
* Giới hạn Lambda song song nâng từ 10 lên 1.000; giới hạn AI mỗi ngày đặt 20 lượt/người.

### **Kỹ năng thực hành & Vận hành**

* Đóng các mục QA ưu tiên cao nhất và kiểm thử lại các luồng liên quan.
* Viết tài liệu tham chiếu để thành viên mới tìm được mọi mẫu khóa và route ở một nơi.
