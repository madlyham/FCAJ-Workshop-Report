---
title: "Nhật ký công việc Tuần 7"
date: 2026-11-07
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

## **Nhật ký công việc Tuần 7 — Giao diện mới, phòng thủ prompt injection, chuyển sang Kimi K3 và Gấu bông thông minh**

## **1. Mục tiêu tuần**

* Làm lại giao diện theo thiết kế của Product Owner: chợ công khai, cổng đối tác và cổng Admin.
* Ngăn văn bản độc hại trong ảnh thao túng AI (prompt injection).
* Khắc phục kết quả tiếng Việt kém của AI; tham dự Sự kiện 5 (Gấu bông thông minh cùng Operation Smile Việt Nam).

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Thứ 2** | • Tham gia [Sự kiện 5: Gấu bông thông minh cho trẻ em – Hoạt động vì cộng đồng phối hợp cùng Operation Smile Vietnam](../../4-eventparticipated/4.5-event5/) (13:30 – 15:30 tại Văn phòng AWS Việt Nam, Phòng EC2, Tầng 36 Bitexco), cùng lắp ráp bộ quà gấu bông tích hợp module âm thanh tương tác cho các bệnh nhi. Bắt đầu làm giao diện mới theo thiết kế của Product Owner. | 26/10/2026 | 26/10/2026 | [Sự kiện 5](../../4-eventparticipated/4.5-event5/), [Repository ReLoop](https://github.com/madlyham/ReLoop) |
| **Thứ 3** | • Tích hợp Rekognition `DetectText` đọc chữ trong ảnh, lọc văn bản trích xuất qua Bedrock `ApplyGuardrail` (`PROMPT_ATTACK`, chỉ kiểm tra đầu vào mức `HIGH`, `output_strength = NONE`) trước khi gọi LLM, và cấu hình `textScreener` (ngưỡng 12 ký tự) gắn cờ tin vào `IMGFLAG` / `REVIEWQ#LISTING` để Admin duyệt | 27/10/2026 | 27/10/2026 | [Amazon Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html), [Tài liệu Amazon Rekognition](https://docs.aws.amazon.com/rekognition/) |
| **Thứ 4** | • Đánh giá trên ảnh thiết bị thật: tiếng Việt của Nova Pro chưa đạt yêu cầu, nên nhóm chuyển sang `Kimi K3` (`global.moonshotai.kimi-k3`) trên Bedrock (28/10/2026) sau khi kiểm tra chi phí theo token vẫn rất thấp (~$0.87/tháng trong tháng 10) và nằm gọn trong số dư credit còn lại. Cùng ngày, hai máy triển khai mã nguồn khác nhau lên cùng một Lambda, bộc lộ lỗ hổng của quy trình thủ công thống nhất ở Tuần 3 và thúc đẩy chuyển sang triển khai bắt buộc qua CI | 28/10/2026 | 28/10/2026 | [Tài liệu Amazon Bedrock](https://docs.aws.amazon.com/bedrock/), [Tài liệu AWS Lambda](https://docs.aws.amazon.com/lambda/) |
| **Thứ 5** | • Từ điển linh kiện tiếng Việt; tách kết quả AI thành `observedTextAndLabels` và `identifiedComponents`; sửa lỗi dấu tiếng Việt phát hiện khi red-team | 29/10/2026 | 29/10/2026 | [Tài liệu Amazon Bedrock](https://docs.aws.amazon.com/bedrock/), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`analyzer.ts`) |
| **Thứ 6** | • Phát hành giao diện mới (chợ công khai, cổng đối tác 2 cấp, cổng Admin); chạy lại đánh giá AI, giúp cải thiện rõ rệt độ chính xác nhận diện thiết bị trên bộ ảnh kiểm thử nội bộ | 30/10/2026 | 30/10/2026 | [Tài liệu Amazon CloudFront](https://docs.aws.amazon.com/cloudfront/), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`reloop-ui`) |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu rằng chữ trong ảnh cũng là dữ liệu người dùng và có thể mang tấn công prompt injection.
* Học cách chọn model theo kết quả đo trên dữ liệu của chính mình, không theo tên tuổi.

### **Cài đặt & Thiết lập môi trường**

* Bedrock Guardrail (`PROMPT_ATTACK`, chỉ kiểm tra đầu vào mức `HIGH`, `output_strength = NONE`) được gọi qua `ApplyGuardrail` trên văn bản ảnh do Rekognition trích xuất trước khi gọi Kimi K3.
* Model AI chuyển sang `Kimi K3` (`global.moonshotai.kimi-k3`) trên Bedrock tại `ap-southeast-1`, vẫn dùng Converse với tool choice bắt buộc và duy trì mức chi phí theo token thấp (~$0.87/tháng trong tháng 10).

### **Kỹ năng thực hành & Vận hành**

* Red-team AI bằng ảnh chứa lệnh ẩn; tin bị gắn cờ giờ phải chờ Admin duyệt.
* Tham gia tình nguyện tại sự kiện Gấu bông thông minh, lắp ráp bộ quà gấu bông tích hợp module âm thanh tương tác cho các bệnh nhi cùng Operation Smile Việt Nam.
