---
title: "Worklog tuần 10"
date: 2026-11-07
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

# **Nhật ký tuần 10: Đánh giá thiết bị phần cứng thực tế, từ điển điện tử tiếng Việt và hạn ngạch AI**

## **1. Mục tiêu trong tuần**

* Đánh giá hiệu năng Nova Pro trên ảnh thiết bị phần cứng thực tế (mạch ESP32 IoT, chuột không dây Logitech M650 L) và khắc phục lỗi chính tả tiếng Việt.
* Bổ sung từ điển thuật ngữ điện tử tiếng Việt vào prompt, xử lý regex dọn dẹp và xây dựng fallback adapter sang Google AI Studio (Gemini Flash).
* Triển khai giới hạn hạn ngạch AI theo ngày cho người dùng (AIQUOTA) và cơ chế lưu trữ tập dữ liệu gán nhãn do người dùng hiệu chỉnh (AILABEL#<month>).

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Kiểm thử các bài đăng thực tế trên môi trường dev và ghi nhận các lỗi chính tả tiếng Việt của Nova Pro | 10/13/2025 | 10/13/2025 | Kiểm tra Dev Feed |
| **Ngày 3** | • Bổ sung trường observedTextAndLabels và identifiedComponents vào tool schema để AI liệt kê linh kiện con trước khi suy đoán danh mục | 10/14/2025 | 10/14/2025 | analyzer.ts |
| **Ngày 4** | • Đưa danh sách thuật ngữ điện tử tiếng Việt UTF-8 chuẩn vào system prompt kết hợp dọn dẹp regex trong hàm validateResult() | 10/15/2025 | 10/15/2025 | analyzer.ts |
| **Ngày 5** | • Xây dựng GeminiAnalyzer + FallbackAnalyzer sử dụng Google AI Studio (gemini-2.5-flash) với cơ chế tự động chuyển vùng về Bedrock | 10/16/2025 | 10/16/2025 | analyzer.ts & app.ts |
| **Ngày 6** | • Thiết lập giới hạn AI_DAILY_LIMIT = 20 lượt/ngày (AIQUOTA#<day>) và lưu cặp dữ liệu { aiSuggested, userFinal } vào AILABEL#<YYYY-MM> | 10/17/2025 | 10/17/2025 | aiService.ts & keys.ts |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Nhận diện bản chất vấn đề: thị giác của Nova Pro rất tốt (đọc được chữ dập nổi nhỏ trên đáy chuột), nhưng khả năng xuất tiếng Việt trong JSON mode bị méo dấu nếu không được nạp sẵn từ vựng chuyên ngành trong prompt.

### **Thiết lập & cấu hình môi trường**

* Cập nhật prompt, các quy tắc chuẩn hóa văn bản và tích hợp biến GEMINI_API_KEY tùy chọn, tương thích 100% với bộ test Vitest.

### **Kỹ năng thực hành & vận hành hệ thống**

* Biến mỗi thao tác chỉnh sửa thông tin của người dùng thành một dòng dữ liệu huấn luyện (AILABEL#<month>) phục vụ xuất định dạng JSONL sau này.
