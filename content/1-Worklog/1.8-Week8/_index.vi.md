---
title: "Worklog tuần 8"
date: 2026-11-07
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

# **Nhật ký tuần 8: Đánh giá mô hình AI đa phương thức Amazon Nova Pro qua Bedrock Converse API**

## **1. Mục tiêu trong tuần**

* So sánh và đánh giá các phương án mô hình AI (SageMaker, Rekognition Custom Labels, Claude Haiku, Amazon Nova Pro) tối ưu cho ngân sách AWS Credits.
* Xây dựng adapter phân loại thiết bị bất đồng bộ (BedrockAnalyzer) sử dụng mô hình Amazon Nova Pro.
* Ép buộc LLM trả về cấu trúc JSON chuẩn thông qua tool schema của Bedrock Converse API thay vì văn bản tự do.

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Kiểm tra phần Billing & Cost Management -> Credits -> Sản phẩm áp dụng để xác định dịch vụ AI được tài trợ | 09/29/2025 | 09/29/2025 | AWS Billing Console |
| **Ngày 3** | • Loại bỏ SageMaker và Rekognition Custom Labels do tính phí máy chủ theo giờ và đòi hỏi tập dữ liệu huấn luyện quá lớn | 09/30/2025 | 09/30/2025 | Đánh giá AI nhóm |
| **Ngày 4** | • Chuyển sang Amazon Nova Pro (apac.amazon.nova-pro-v1:0): mô hình chính chủ của Amazon được trừ cước trực tiếp từ AWS credits | 10/01/2025 | 10/01/2025 | Tài liệu Amazon Bedrock |
| **Ngày 5** | • Lập trình BedrockAnalyzer qua Converse API với tùy chọn bắt buộc toolChoice: 'record_device_analysis' | 10/02/2025 | 10/02/2025 | analyzer.ts |
| **Ngày 6** | • Cấu hình thực thi bất đồng bộ ngầm (InvocationType=Event self-invoke trên Lambda) và kiểm thử với ảnh chụp nhãn laptop thực tế | 10/03/2025 | 10/03/2025 | aiService.ts |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Hiểu rõ việc các mô hình bên thứ ba như Claude Haiku tính cước qua AWS Marketplace (không trừ promotional credits), trong khi Nova Pro của Amazon được trừ thẳng vào credits và có chi phí $0 khi nhàn rỗi.
* Sử dụng kỹ thuật Tool Use của Converse API để khóa chặt định dạng đầu ra của AI vào đúng cấu trúc interface TypeScript AiResult.

### **Thiết lập & cấu hình môi trường**

* Cấu hình AI_MODEL_ID=apac.amazon.nova-pro-v1:0 với nhiệt độ temperature: 0 và giới hạn maxTokens: 2048.

### **Kỹ năng thực hành & vận hành hệ thống**

* Kiểm thử Nova Pro trên ảnh chụp tem máy Dell Latitude 5490; mô hình trích xuất chính xác thông tin cấu hình và trả về JSON chuẩn ngay lần thử đầu tiên.
