---
title: "Nhật ký công việc Tuần 9"
date: 2026-11-07
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

# **Nhật ký công việc Tuần 9: Phòng thủ Tấn công Prompt Injection bằng OCR & Bedrock Guardrails**

## **1. Mục tiêu tuần**

* Bảo vệ luồng xử lý AI khỏi các cuộc tấn công thị giác Visual Prompt Injection (văn bản độc hại dán trên linh kiện).
* Xây dựng lá chắn phòng thủ 2 lớp: OCR bằng Rekognition DetectText kết hợp Bedrock Guardrails.
* Tự động cách ly và chuyển các bài đăng đáng ngờ vào hàng đợi kiểm duyệt thủ công (REVIEWQ#LISTING).

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Thiết kế bộ lọc 2 bước: Rekognition DetectText đọc chữ trong ảnh -> Bedrock Guardrail kiểm tra tấn công prompt | 10/05/2026 | 10/05/2026 | AWS Rekognition & Bedrock |
| **Ngày 3** | • Cấu hình aws_bedrock_guardrail.ai với bộ lọc PROMPT_ATTACK = HIGH trong file infra/ai.tf | 10/06/2026 | 10/06/2026 | infra/ai.tf |
| **Ngày 4** | • Hiện thực RekognitionGuardrailScreener (bỏ qua nếu độ dài chữ < 12 ký tự để tránh nghẽn logo nhãn hàng) | 10/07/2026 | 10/07/2026 | textScreener.ts |
| **Ngày 5** | • Lưu bản ghi IMGFLAG#<imageKey> trong DynamoDB khi phát hiện nghi vấn và chuyển bài đăng sang REVIEWQ#LISTING | 10/08/2026 | 10/08/2026 | listingService.ts |
| **Ngày 6** | • Đóng vai Red-team tấn công thử nghiệm: chặn thành công mẫu injection tiếng Anh; phát hiện lỗi đọc dấu tiếng Việt | 10/09/2026 | 10/09/2026 | Kiểm thử AWS Dev |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Nắm vững các bề mặt tấn công đa phương thức: kẻ gian có thể in lệnh độc hại lên tem nhãn để lừa mô hình thị giác đánh giá thiết bị hỏng thành đồ mới.
* Thiết kế cơ chế phòng thủ chiều sâu: OCR nhẹ kiểm tra trước, Guardrail chuyên sâu đánh giá sau, con người can thiệp bước cuối.

### **Cài đặt & Thiết lập môi trường**

* Khởi tạo tài nguyên aws_bedrock_guardrail trên Terraform với bộ lọc Prompt Attack mức HIGH.
* Cấu hình lược đồ lưu trữ hàng đợi kiểm duyệt trên DynamoDB.

### **Kỹ năng thực hành & Vận hành**

* Kiểm thử thành công với các hình ảnh tấn công giả lập; hệ thống tự động gắn cờ cảnh báo chính xác 100%.
* Tổng hợp các điểm hạn chế khi OCR đọc tiếng Việt có dấu để chuẩn bị tinh chỉnh prompt ở Tuần 10.
