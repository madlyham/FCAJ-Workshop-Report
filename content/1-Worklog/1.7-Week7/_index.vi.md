---
title: "Nhật ký công việc Tuần 7"
date: 2026-11-07
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

# **Nhật ký công việc Tuần 7 — Giao diện mới, phòng thủ prompt injection, chuyển sang Kimi K3 và Gấu bông thông minh**

## **1. Mục tiêu tuần**

* Làm lại giao diện theo thiết kế của Product Owner: chợ công khai, cổng đối tác và cổng Admin.
* Ngăn văn bản độc hại trong ảnh thao túng AI (prompt injection).
* Khắc phục kết quả tiếng Việt kém của AI; tham dự Sự kiện 5 (Gấu bông thông minh cùng Operation Smile Việt Nam).

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Thứ 2** | • Tham gia [Sự kiện 5: Gấu bông thông minh cho trẻ em – Hoạt động vì cộng đồng phối hợp cùng Operation Smile Vietnam](../../4-eventparticipated/4.5-event5/) (13:30 – 15:30 tại Văn phòng AWS Việt Nam, Phòng EC2, Tầng 36 Bitexco). Lắp ráp và lập trình gấu bông IoT tương tác hỗ trợ bệnh nhi. Bắt đầu làm giao diện mới theo thiết kế của Product Owner. | 26/10/2026 | 26/10/2026 | Sự kiện 5 / Operation Smile & AWS |
| **Thứ 3** | • Rekognition `DetectText` đọc chữ trong ảnh; Bedrock Guardrail (`PROMPT_ATTACK`, `HIGH`) lọc nội dung; `textScreener` (ngưỡng 12 ký tự) gắn cờ tin vào `IMGFLAG` / `REVIEWQ#LISTING` để Admin duyệt | 27/10/2026 | 27/10/2026 | Tài liệu Bedrock Guardrails |
| **Thứ 4** | • Đánh giá trên ảnh thiết bị thật: tiếng Việt của Nova Pro kém; chuyển AI sang Kimi K3 trên Bedrock (28/10/2026). Cùng ngày, hai máy triển khai code khác nhau lên cùng một Lambda, cho thấy rõ cần một luồng triển khai duy nhất | 28/10/2026 | 28/10/2026 | Bảng đánh giá AI |
| **Thứ 5** | • Từ điển linh kiện tiếng Việt; tách kết quả AI thành `observedTextAndLabels` và `identifiedComponents`; sửa lỗi dấu tiếng Việt phát hiện khi red-team | 29/10/2026 | 29/10/2026 | Từ điển, `analyzer.ts` |
| **Thứ 6** | • Phát hành giao diện mới (chợ công khai, cổng đối tác 2 cấp, cổng Admin); chạy lại đánh giá AI: độ chính xác trên bộ thử của nhóm tăng từ khoảng 40% lên 92% | 30/10/2026 | 30/10/2026 | `reloop-ui`, đánh giá AI |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu rằng chữ trong ảnh cũng là dữ liệu người dùng và có thể mang tấn công prompt injection.
* Học cách chọn model theo kết quả đo trên dữ liệu của chính mình, không theo tên tuổi.

### **Cài đặt & Thiết lập môi trường**

* Bedrock Guardrail (`PROMPT_ATTACK HIGH`) áp cho đầu vào/đầu ra AI và chữ đọc được trong ảnh.
* Model AI chuyển sang Kimi K3 trên Bedrock tại `ap-southeast-1`, vẫn dùng Converse với tool choice bắt buộc.

### **Kỹ năng thực hành & Vận hành**

* Red-team AI bằng ảnh chứa lệnh ẩn; tin bị gắn cờ giờ phải chờ Admin duyệt.
* Tham gia tình nguyện tại sự kiện Gấu bông thông minh, lắp ráp gấu bông IoT cho trẻ em cùng Operation Smile Việt Nam.
