---
title: "Nhật ký công việc Tuần 9"
date: 2026-11-22
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

## **Nhật ký công việc Tuần 9 — Rà soát bảo mật, bản vá gia cố, Đề xuất Phần 2 và Sự kiện Cloud Mastery**

## **1. Mục tiêu tuần**

* Rà soát bảo mật toàn diện đối với IAM role, phân quyền Cognito JWT, cơ chế khóa nguồn `x-origin-verify` trên CloudFront và bộ luật WAF trên CloudFront.
* Triển khai các bản vá gia cố bảo mật và xác thực lại toàn bộ hệ thống bằng smoke test.
* Rà soát chi phí thực tế trên AWS Cost Explorer so với số dư credit còn lại và nộp Đề xuất (Phần 2).
* Tham dự Sự kiện 6 (Cloud Mastery) tại Văn phòng AWS Việt Nam.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Thứ 2** | • Rà soát bảo mật các policy IAM theo nguyên tắc quyền tối thiểu, kiểm tra claim Cognito JWT cùng phân quyền 4 nhóm (`Admins`, `FinanceAdmins`, `Partners`, `Owners`) và điều kiện quyền sở hữu trên DynamoDB | 09/11/2026 | 09/11/2026 | [Thực hành bảo mật IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html), [JWT của Cognito user pool](https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-using-tokens-with-identity-providers.html), [Nhóm trong Cognito user pool](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-user-groups.html), [Biểu thức điều kiện DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.ConditionExpressions.html) |
| **Thứ 3** | • Kiểm tra cơ chế bắt buộc header bí mật `x-origin-verify` từ CloudFront tới API Gateway (chặn truy cập trực tiếp bỏ qua CloudFront) và rà soát CloudFront WAF web ACL duy nhất (3 bộ luật AWS managed + 2 giới hạn tốc độ theo IP) | 10/11/2026 | 10/11/2026 | [Header tùy chỉnh gửi tới origin CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/add-origin-custom-headers.html), [Web ACL của WAF](https://docs.aws.amazon.com/waf/latest/developerguide/web-acl.html), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`infra/waf.tf`) |
| **Thứ 4** | • Triển khai các bản vá gia cố bảo mật (siết kiểm tra quyền sở hữu/vai trò, chuẩn hóa thông báo lỗi an toàn, siết kiểm tra dữ liệu đầu vào); chạy lại `smoke-aws.py` xác nhận không phát sinh lỗi hồi quy | 11/11/2026 | 11/11/2026 | [Trụ cột Bảo mật Well-Architected](https://docs.aws.amazon.com/wellarchitected/latest/framework/security.html), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`smoke-aws.py`) |
| **Thứ 5** | • Rà soát chi phí từng dịch vụ trên AWS Cost Explorer đối chiếu với số dư credit AWS và xác nhận stack 12 dịch vụ (+ IAM) duy trì ở mức ~$11.70/tháng ($10.00 CloudFront WAF + ~$1.70 theo mức sử dụng) | 12/11/2026 | 12/11/2026 | [AWS Cost Explorer](https://docs.aws.amazon.com/cost-management/latest/userguide/ce-what-is.html), [Áp dụng AWS credits](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/useconsolidatedbilling-credits.html) |
| **Thứ 6** | • Hoàn thiện và **nộp Đề xuất (Phần 2)**: cập nhật kiến trúc 12 dịch vụ AWS quản lý (+ IAM), bảng chi phí thực tế từ Cost Explorer và kết quả gia cố bảo mật | 13/11/2026 | 13/11/2026 | [Đề xuất](../../2-proposal/) |
| **Thứ 7** | • Tham dự [Sự kiện 6: Cloud Mastery – Buổi chia sẻ về Cloud cho sinh viên](../../4-eventparticipated/4.6-event6/) (buổi sáng, Văn phòng AWS Việt Nam). Hỏi đáp mở kéo dài với sinh viên về định hướng và chuyên môn Cloud, sau đó chơi Quiz.com trực tiếp | 14/11/2026 | 14/11/2026 | [Sự kiện 6](../../4-eventparticipated/4.6-event6/) |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu cách phòng thủ nhiều lớp kết hợp lọc tại biên (CloudFront + WAF), khóa nguồn (`x-origin-verify`), xác thực nhóm quyền JWT và điều kiện ghi trên DynamoDB.
* Nắm quy trình đối chiếu dữ liệu chi phí thực tế từ Cost Explorer với ước tính kiến trúc trước khi chốt đề xuất dự án.

### **Cài đặt & Thiết lập môi trường**

* Các policy IAM quyền tối thiểu, kiểm tra JWT 4 nhóm Cognito, khóa nguồn `x-origin-verify` và luật CloudFront WAF đã được xác thực trên hệ thống thật.
* Đã nộp Đề xuất (Phần 2) ngày 13/11/2026 kèm số liệu Cost Explorer thực tế.

### **Kỹ năng thực hành & Vận hành**

* Triển khai đầy đủ các bản vá gia cố bảo mật và vượt qua smoke test trọn luồng không có lỗi hồi quy.
* Xác nhận mức chi phí vận hành (~$11.70/tháng) nằm gọn trong ngân sách credit AWS còn lại.
