---
title: "Nhật ký công việc Tuần 8"
date: 2026-11-07
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

# **Nhật ký công việc Tuần 8: AI đa phương thức (Nova Pro), Watch Party AI Day & Tọa đàm Dr. Werner**

## **1. Mục tiêu tuần**

* Tham dự Sự kiện 2 (Watch Party AWS Cloud and AI Day Hanoi) và Sự kiện 3 (Fireside Chat cùng CTO Werner Vogels) để tiếp thu nguyên lý tối ưu FinOps và độ bền bỉ của hệ thống phân tán.
* So sánh các phương án mô hình AI (SageMaker, Custom Labels, Claude Haiku, Amazon Nova Pro) nhằm tối ưu nguồn tài trợ AWS Credits.
* Xây dựng adapter phân loại thiết bị bất đồng bộ (BedrockAnalyzer) bằng Amazon Nova Pro với cấu trúc JSON nghiêm ngặt qua Converse API tool schema.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Kiểm tra phần Billing & Cost Management -> Credits -> Sản phẩm áp dụng để xác định dịch vụ AI được tài trợ | 09/28/2026 | 09/28/2026 | AWS Billing Console |
| **Ngày 3** | • Tham dự [Sự kiện 2: Watch Party AWS Cloud and AI Day Hanoi](../../4-eventparticipated/4.2-event2/) (08:00 – 17:00 tại Văn phòng AWS Việt Nam, Bitexco Tầng 26). Tìm hiểu sâu về AI Agent doanh nghiệp, kỹ nghệ nền tảng và tối ưu chi phí FinOps. | 09/29/2026 | 09/29/2026 | Sự kiện 2 / Văn phòng AWS Việt Nam |
| **Ngày 4** | • Loại bỏ SageMaker và Rekognition Custom Labels do tính phí máy chủ theo giờ và đòi hỏi tập dữ liệu huấn luyện quá lớn; đánh giá phương án suy luận serverless | 09/30/2026 | 09/30/2026 | Đánh giá AI nhóm |
| **Ngày 5** | • Chuyển sang Amazon Nova Pro (apac.amazon.nova-pro-v1:0): mô hình chính hãng của Amazon được bảo chứng bởi Credits, tính phí chặt chẽ theo token | 10/01/2026 | 10/01/2026 | Tài liệu Amazon Bedrock |
| **Ngày 6** | • Tham dự [Sự kiện 3: Tọa đàm Fireside Chat cùng Tiến sĩ Werner Vogels](../../4-eventparticipated/4.3-event3/) (10:30 – 12:00 tại Bitexco Financial Tower; Keynote bởi CTO Amazon). Triển khai BedrockAnalyzer sử dụng Converse API với forced toolChoice. | 10/02/2026 | 10/02/2026 | Sự kiện 3 / Keynote Amazon & analyzer.ts |
| **Ngày 7** | • Cấu hình cơ chế gọi bất đồng bộ chạy nền (InvocationType=Event self-invoke) và kiểm thử trên ảnh thực tế bo mạch, laptop | 10/03/2026 | 10/03/2026 | aiService.ts |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu rõ tại sao các mô hình bên thứ ba như Claude Haiku thanh toán qua AWS Marketplace (không được trừ vào AWS Credits), trong khi Amazon Nova Pro được khấu trừ trực tiếp và tiêu tốn 0 USD khi nhàn rỗi.
* Thấm nhuần triết lý 'Everything fails, all the time' của Tiến sĩ Werner Vogels—củng cố thiết kế phân tách sự kiện bất đồng bộ, tính lũy kế (idempotency) và khóa lạc quan cho ReLoop.
* Tiếp thu bài học FinOps từ Watch Party AI Day Hà Nội: chọn đúng kiến trúc và kiểm soát chi phí thực tế quan trọng hơn chạy theo công cụ mới.

### **Cài đặt & Thiết lập môi trường**

* Cấu hình AI_MODEL_ID=apac.amazon.nova-pro-v1:0 với temperature: 0 và maxTokens: 2048.
* Dùng tính năng Tool Use của Converse API ép buộc AI trả về kết quả tuân thủ đúng định dạng TypeScript AiResult schema.

### **Kỹ năng thực hành & Vận hành**

* Thử nghiệm phân tích ảnh tem laptop Dell Latitude 5490 bằng Nova Pro; trích xuất thành công JSON chuẩn xác ngay từ lần gọi đầu tiên.
* Tham dự trọn vẹn cả ngày Sự kiện 2 (Watch Party) và lắng nghe trực tiếp bài phát biểu truyền cảm hứng của CTO Werner Vogels tại Sự kiện 3.
