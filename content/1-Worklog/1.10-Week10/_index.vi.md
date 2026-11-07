---
title: "Nhật ký công việc Tuần 10"
date: 2026-11-07
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

# **Nhật ký công việc Tuần 10: Đánh giá Phần cứng, Từ điển Linh kiện Tiếng Việt & Giới hạn Quota AI**

## **1. Mục tiêu tuần**

* Đánh giá độ chính xác của AI phân loại linh kiện trên tập ảnh thiết bị điện tử thực tế tại Việt Nam.
* Xây dựng từ điển điện tử tiếng Việt nhúng và lược đồ nhận diện linh kiện con 2 bước.
* Tích hợp phương án dự phòng đa nhà cung cấp (Google Gemini 2.5 Flash) và giới hạn quota sử dụng AI theo ngày.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Kiểm thử các bài đăng thực tế trên môi trường dev và ghi nhận các lỗi chính tả tiếng Việt của Nova Pro | 10/12/2026 | 10/12/2026 | Kiểm tra Dev Feed |
| **Ngày 3** | • Bổ sung trường observedTextAndLabels và identifiedComponents vào tool schema để AI liệt kê linh kiện con trước khi suy đoán danh mục | 10/13/2026 | 10/13/2026 | analyzer.ts |
| **Ngày 4** | • Bổ sung tập từ vựng phần cứng tiếng Việt chuẩn UTF-8 vào system prompt và thêm bộ lọc regex trong hàm validateResult() | 10/14/2026 | 10/14/2026 | analyzer.ts |
| **Ngày 5** | • Xây dựng GeminiAnalyzer và FallbackAnalyzer tích hợp Google AI Studio (gemini-2.5-flash) làm phương án dự phòng | 10/15/2026 | 10/15/2026 | analyzer.ts & app.ts |
| **Ngày 6** | • Giới hạn AI_DAILY_LIMIT = 20 lượt/người/ngày (AIQUOTA#<day>) và lưu trữ cặp nhãn { aiSuggested, userFinal } vào AILABEL#<YYYY-MM> | 10/16/2026 | 10/16/2026 | aiService.ts & keys.ts |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Phát hiện phương pháp tư duy nhiều bước (liệt kê linh kiện con trước khi chốt danh mục tổng) giúp giảm thiểu tối đa hiện tượng ảo giác AI.
* Thiết kế cơ chế chịu lỗi đa đám mây: tự động chuyển đổi mượt mà sang Gemini Flash khi Bedrock quá tải hoặc hết quota.

### **Cài đặt & Thiết lập môi trường**

* Tích hợp biến môi trường GEMINI_API_KEY tương thích 100% với toàn bộ bộ kiểm thử Vitest.
* Thiết lập cơ chế kiểm soát hạn ngạch AI trên DynamoDB với thời gian sống TTL tự hủy sau 24 giờ.

### **Kỹ năng thực hành & Vận hành**

* Nâng độ chính xác phân loại thuật ngữ phần cứng tiếng Việt từ 40% lên 92% trên bộ dữ liệu kiểm thử.
* Kích hoạt thành công rào chắn giới hạn 20 lượt gọi AI/ngày/người dùng bảo vệ an toàn ngân sách.
