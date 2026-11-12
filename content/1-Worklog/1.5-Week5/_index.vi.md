---
title: "Nhật ký công việc Tuần 5"
date: 2026-11-07
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

# **Nhật ký công việc Tuần 5: Tải ảnh an toàn lên S3, Kiểm duyệt Rekognition và AI điền tin với Bedrock Nova Pro**

## **1. Mục tiêu tuần**

* Cho người bán tải ảnh thẳng lên S3 an toàn, có kiểm kích thước, định dạng và quyền sở hữu.
* Tự động chặn ảnh không phù hợp bằng Amazon Rekognition.
* Chọn model AI được credit AWS chi trả và xây trợ lý AI điền tin đầu tiên.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • S3ImageStore: presigned POST (300 giây, tối đa 5 MB, JPEG/PNG/WebP, tối đa 6 ảnh mỗi tin); assertOwnImageKeys để người dùng chỉ gắn được ảnh của chính mình | 10/12/2026 | 10/12/2026 | imageStore.ts |
| **Ngày 3** | • Rekognition DetectModerationLabels (MinConfidence 70); ảnh không phù hợp trả 422 IMAGE_REJECTED; lifecycle xóa ảnh chưa gắn sau 1 ngày và mọi ảnh sau 90 ngày | 10/13/2026 | 10/13/2026 | Tài liệu Amazon Rekognition |
| **Ngày 4** | • Kiểm Billing → Credits → dịch vụ áp dụng; bỏ SageMaker và Rekognition Custom Labels (tính phí theo giờ, cần dữ liệu huấn luyện); chọn Amazon Nova Pro (apac.amazon.nova-pro-v1:0), tính theo token và được credit chi trả | 10/14/2026 | 10/14/2026 | AWS Billing Console, Tài liệu Bedrock |
| **Ngày 5** | • Viết BedrockAnalyzer bằng Converse API với toolChoice bắt buộc để model phải trả JSON đúng schema AiResult (temperature 0, maxTokens 2048) | 10/15/2026 | 10/15/2026 | analyzer.ts |
| **Ngày 6** | • Chạy phân tích AI ở nền (Lambda tự gọi, InvocationType=Event) và thử trên ảnh laptop, linh kiện thật | 10/16/2026 | 10/16/2026 | aiService.ts |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu vì sao model bên thứ ba bán qua AWS Marketplace có thể không dùng được credit khuyến mãi, còn model Nova của Amazon thì dùng được và không tốn tiền khi không chạy.
* Hiểu cách policy của presigned POST ép kích thước và định dạng file ngay phía S3, không chỉ ở trình duyệt.

### **Cài đặt & Thiết lập môi trường**

* Luồng ảnh: presign → tải thẳng → kiểm duyệt → gắn tag; lifecycle 1 ngày (chưa gắn) / 90 ngày (tất cả).
* AI_MODEL_ID=apac.amazon.nova-pro-v1:0, dùng Converse tool use khóa theo schema AiResult.

### **Kỹ năng thực hành & Vận hành**

* Thử Nova Pro với ảnh tem máy Dell Latitude 5490; model trả JSON hợp lệ đúng schema ngay lần đầu.
* Kiểm tra người dùng không thể gắn key ảnh của người khác vào tin đăng.
