---
title: "Worklog tuần 9"
date: 2026-11-07
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

# **Nhật ký tuần 9: Phòng thủ tấn công Visual Prompt Injection với Rekognition OCR và Bedrock Guardrails**

## **1. Mục tiêu trong tuần**

* Phòng chống tấn công Visual Prompt Injection (kẻ tấn công dán giấy ghi chú vào ảnh nhằm lừa mô hình AI phân loại sai thiết bị).
* Xây dựng pipeline kiểm tra văn bản kết hợp OCR và Bedrock Guardrail trong backend/src/storage/textScreener.ts.
* Giữ các bài đăng có ảnh bị gắn cờ ở trạng thái PENDING_REVIEW để Quản trị viên duyệt thủ công trước khi xuất bản.

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Thiết kế bộ lọc 2 bước: Rekognition DetectText đọc chữ trong ảnh -> Bedrock Guardrail kiểm tra tấn công prompt | 10/06/2025 | 10/06/2025 | AWS Rekognition & Bedrock |
| **Ngày 3** | • Cấu hình aws_bedrock_guardrail.ai với bộ lọc PROMPT_ATTACK = HIGH trong file infra/ai.tf | 10/07/2025 | 10/07/2025 | infra/ai.tf |
| **Ngày 4** | • Viết RekognitionGuardrailScreener (bỏ qua Guardrail nếu độ dài chữ < 12 ký tự để logo nhãn hiệu đi qua bình thường) | 10/08/2025 | 10/08/2025 | textScreener.ts |
| **Ngày 5** | • Lưu bản ghi IMGFLAG#<imageKey> vào DynamoDB khi phát hiện nghi vấn và chuyển bài đăng vào hàng đợi REVIEWQ#LISTING | 10/09/2025 | 10/09/2025 | listingService.ts |
| **Ngày 6** | • Kiểm thử tấn công thử nghiệm: chặn thành công câu lệnh tiếng Anh; phát hiện điểm mù khi Rekognition đọc sai dấu tiếng Việt in trên giấy | 10/10/2025 | 10/10/2025 | Kiểm thử AWS Dev |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Phát hiện lỗ hổng bảo mật thực tế: Rekognition.DetectText nhận diện dấu tiếng Việt chưa chuẩn xác, làm biến dạng câu lệnh tấn công thành chuỗi ký tự ASCII lạ vượt qua Bedrock Guardrail.
* Bổ sung cơ chế quét từ khóa tiếng Việt không dấu (bo qua huong dan, system prompt, ignore previous) để vá lỗ hổng nhận diện OCR này.

### **Thiết lập & cấu hình môi trường**

* Kích hoạt biến môi trường AI_GUARDRAIL_ID, AI_GUARDRAIL_VERSION cho hàm Lambda và tạo metric filter ImagesTextFlagged trên CloudWatch.

### **Kỹ năng thực hành & vận hành hệ thống**

* Xác minh toàn diện: tải ảnh có kèm câu lệnh tấn công in trên giấy bị phát hiện ngay lập tức, bài đăng tự động chuyển sang PENDING_REVIEW và hiển thị văn bản OCR cho Admin thẩm định.
