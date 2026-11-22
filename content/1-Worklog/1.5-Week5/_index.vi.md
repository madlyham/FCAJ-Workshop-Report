---
title: "Nhật ký công việc Tuần 5"
date: 2026-11-07
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

## **Nhật ký công việc Tuần 5 — Tải ảnh an toàn lên S3, kiểm duyệt Rekognition và AI điền tin với Bedrock Nova Pro**

## **1. Mục tiêu tuần**

* Cho người bán tải ảnh thẳng lên S3 an toàn, có kiểm tra kích thước, định dạng và quyền sở hữu.
* Tự động chặn ảnh không phù hợp bằng Amazon Rekognition.
* Chọn model AI tính phí theo token phù hợp với hạn mức credit AWS và xây trợ lý AI điền tin đầu tiên.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Thứ 2** | • `S3ImageStore`: presigned POST (300 giây, tối đa 5 MB, JPEG/PNG/WebP, tối đa 6 ảnh mỗi tin); `assertOwnImageKeys` để người dùng chỉ gắn được ảnh của chính mình | 12/10/2026 | 12/10/2026 | [Tài liệu Amazon S3](https://docs.aws.amazon.com/s3/), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`imageStore.ts`) |
| **Thứ 3** | • Rekognition `DetectModerationLabels` (`MinConfidence 70`); ảnh không phù hợp trả `422 IMAGE_REJECTED`; lifecycle xóa ảnh chưa gắn sau 1 ngày và mọi ảnh sau 90 ngày | 13/10/2026 | 13/10/2026 | [Tài liệu Amazon Rekognition](https://docs.aws.amazon.com/rekognition/) |
| **Thứ 4** | • Kiểm tra Billing → Credits → dịch vụ áp dụng; bỏ SageMaker và Rekognition Custom Labels (tính phí theo giờ, cần dữ liệu huấn luyện); chọn Amazon Nova Pro (`apac.amazon.nova-pro-v1:0`) cho giai đoạn dựng nguyên mẫu ban đầu để bám sát biểu giá theo token của model chính chủ AWS trên Bedrock | 14/10/2026 | 14/10/2026 | [AWS Billing & Cost Explorer](https://docs.aws.amazon.com/cost-management/latest/userguide/), [Tài liệu Amazon Bedrock](https://docs.aws.amazon.com/bedrock/) |
| **Thứ 5** | • Viết `BedrockAnalyzer` bằng Converse API với `toolChoice` bắt buộc để model phải trả JSON đúng schema `AiResult` (`temperature 0`, `maxTokens 2048`) | 15/10/2026 | 15/10/2026 | [Tài liệu Amazon Bedrock](https://docs.aws.amazon.com/bedrock/), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`analyzer.ts`) |
| **Thứ 6** | • Chạy phân tích AI chạy nền (bất đồng bộ) qua Lambda tự gọi (`InvocationType=Event`) và thử trên ảnh laptop, linh kiện thật | 16/10/2026 | 16/10/2026 | [Tài liệu AWS Lambda](https://docs.aws.amazon.com/lambda/), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`aiService.ts`) |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu vì sao giai đoạn dựng nguyên mẫu ban đầu ưu tiên model Nova chính chủ của Amazon (tính theo token, không tốn phí khi không chạy, phù hợp rõ ràng với credit khuyến mãi AWS) thay vì các endpoint tính theo giờ như SageMaker hoặc gói Marketplace bên thứ ba.
* Hiểu cách policy của presigned POST áp dụng ràng buộc kích thước và định dạng tệp ngay phía S3, không chỉ ở trình duyệt.

### **Cài đặt & Thiết lập môi trường**

* Luồng ảnh: presign → tải thẳng → kiểm duyệt → gắn tag; lifecycle 1 ngày (chưa gắn) / 90 ngày (tất cả).
* `AI_MODEL_ID=apac.amazon.nova-pro-v1:0`, dùng Converse tool use khóa theo schema `AiResult`.

### **Kỹ năng thực hành & Vận hành**

* Thử Nova Pro với ảnh tem máy Dell Latitude 5490; model trả JSON hợp lệ đúng schema ngay lần đầu.
* Kiểm tra và xác nhận người dùng không thể gắn key ảnh của người khác vào tin đăng.
