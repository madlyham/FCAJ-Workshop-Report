---
title: "Nhật ký công việc Tuần 7"
date: 2026-11-07
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

# **Nhật ký công việc Tuần 7: Giao diện mới, Phòng thủ Prompt Injection, Chuyển sang Kimi K3 và Gấu bông Thông minh**

## **1. Mục tiêu tuần**

* Làm lại giao diện theo thiết kế của PO: Chợ công khai, cổng đối tác và cổng Admin.
* Chặn chữ độc hại trong ảnh điều khiển AI (prompt injection).
* Khắc phục kết quả tiếng Việt kém của AI; tham dự Sự kiện 5 (Gấu bông thông minh cùng Operation Smile Việt Nam).

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Tham gia [Sự kiện 5: Gấu bông thông minh cho trẻ em – Hợp tác cùng Operation Smile Việt Nam](../../4-eventparticipated/4.5-event5/) (13:30 – 15:30 tại Văn phòng AWS Việt Nam, EC2 Tầng 36 Bitexco). Lắp ráp và lập trình gấu bông IoT tương tác hỗ trợ bệnh nhi. Bắt đầu làm giao diện mới theo thiết kế của PO. | 10/26/2026 | 10/26/2026 | Sự kiện 5 / Operation Smile & AWS |
| **Ngày 3** | • Rekognition DetectText đọc chữ trong ảnh; Bedrock Guardrail (PROMPT_ATTACK, HIGH) lọc nội dung; textScreener (ngưỡng 12 ký tự) gắn cờ tin vào IMGFLAG / REVIEWQ#LISTING để Admin duyệt | 10/27/2026 | 10/27/2026 | Tài liệu Bedrock Guardrails |
| **Ngày 4** | • Đánh giá trên ảnh thiết bị thật: tiếng Việt của Nova Pro kém; chuyển AI sang Kimi K3 trên Bedrock (28/10). Cùng ngày, hai máy deploy code khác nhau lên cùng một Lambda, cho thấy rõ cần một đường deploy duy nhất | 10/28/2026 | 10/28/2026 | Bảng đánh giá AI |
| **Ngày 5** | • Từ điển linh kiện tiếng Việt; tách kết quả AI thành observedTextAndLabels và identifiedComponents; sửa lỗi dấu tiếng Việt phát hiện khi red-team | 10/29/2026 | 10/29/2026 | Từ điển, analyzer.ts |
| **Ngày 6** | • Phát hành giao diện mới (Chợ công khai, cổng đối tác 2 cấp, cổng Admin); chạy lại đánh giá AI: độ chính xác trên bộ thử của nhóm tăng từ khoảng 40% lên 92% | 10/30/2026 | 10/30/2026 | reloop-ui, đánh giá AI |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu rằng chữ trong ảnh cũng là dữ liệu người dùng và có thể mang tấn công prompt injection.
* Học cách chọn model theo kết quả đo trên dữ liệu của chính mình, không theo tên tuổi.

### **Cài đặt & Thiết lập môi trường**

* Guardrail (PROMPT_ATTACK HIGH) áp cho đầu vào/đầu ra AI và chữ đọc được trong ảnh.
* Model AI chuyển sang Kimi K3 trên Bedrock, vẫn dùng Converse với tool choice bắt buộc.

### **Kỹ năng thực hành & Vận hành**

* Red-team AI bằng ảnh chứa lệnh ẩn; tin bị gắn cờ giờ phải chờ Admin duyệt.
* Tham gia tình nguyện tại sự kiện Gấu bông thông minh, lắp ráp gấu bông IoT cho trẻ em cùng Operation Smile Việt Nam.
