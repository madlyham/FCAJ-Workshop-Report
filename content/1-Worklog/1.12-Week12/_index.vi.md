---
title: "Nhật ký công việc Tuần 12"
date: 2026-11-07
weight: 12
chapter: false
pre: " <b> 1.12. </b> "
---

# **Nhật ký công việc Tuần 12: Tài liệu Kỹ thuật, Gấu bông Thông minh & Tổng duyệt Dự án**

## **1. Mục tiêu tuần**

* Tham gia Sự kiện 5 (Gấu bông thông minh cho trẻ em cùng Operation Smile Việt Nam) ứng dụng kỹ nghệ IoT tạo tác động tích cực cho xã hội.
* Hoàn thiện hệ thống tài liệu dự án và biên soạn cẩm nang kỹ thuật toàn diện RELOOP_TECHNICAL_REFERENCE cho cả nhóm.
* Thực hiện kiểm thử tải nặng (scripts/loadtest.mjs) và xác thực cơ chế khóa lạc quan (putVersioned + withOptimisticRetry) chống tranh chấp dữ liệu.
* Viết báo cáo chuyên sâu Phần D2 và tiến hành tổng duyệt toàn diện kịch bản demo sản phẩm trước hội đồng.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Tham gia [Sự kiện 5: Gấu bông thông minh cho trẻ em – Hợp tác cùng Operation Smile Việt Nam](../../4-eventparticipated/4.5-event5/) (13:30 – 15:30 tại Văn phòng AWS Việt Nam, EC2 Tầng 36 Bitexco). Lắp ráp và lập trình gấu bông IoT tương tác hỗ trợ bệnh nhi. Tổng hợp cấu hình AWS thành tài liệu RELOOP_TECHNICAL_REFERENCE. | 10/26/2026 | 10/26/2026 | Sự kiện 5 / Operation Smile & AWS, RELOOP_TECHNICAL_REFERENCE |
| **Ngày 3** | • Tài liệu hóa hơn 30 mẫu khóa DynamoDB, các chuyển trạng thái giao dịch, mã lỗi AppError và hơn 45 API endpoints | 10/27/2026 | 10/27/2026 | Mã nguồn Backend |
| **Ngày 4** | • Chạy kiểm thử tải scripts/loadtest.mjs (50 users, 20 req/s); xác nhận putVersioned + withOptimisticRetry chặn đứng xung đột chọn trùng báo giá | 10/28/2026 | 10/28/2026 | scripts/loadtest.mjs |
| **Ngày 5** | • Viết báo cáo chuyên sâu Phần D2: Phân tích FinOps Nova Pro, thống kê độ chính xác thực tế và cơ chế phòng thủ OCR + Guardrails | 10/29/2026 | 10/29/2026 | Báo cáo Đồ án (D2) |
| **Ngày 6** | • Tổng duyệt 2 buổi demo trực tiếp toàn diện (luồng Đối tác Cấp 1/2, AI gắn nhãn, khớp bán kính 5km, xuất hóa đơn, chặn ảnh tấn công) và hoàn thiện slide | 10/30/2026 | 10/31/2026 | Kịch bản Demo |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Tổng hợp toàn bộ kiến thức từ những dòng lệnh EC2/CLI cơ bản ở Tuần 1 đến hệ thống serverless hoàn chỉnh trên môi trường production kết hợp AI đa phương thức, phòng thủ thị giác, khóa lạc quan và IaC.
* Trải nghiệm sức mạnh của công nghệ khi được định hướng vì mục tiêu nhân văn qua workshop Gấu bông thông minh, hoàn thiện trọn vẹn hành trình thực tập cả về kỹ thuật lẫn trách nhiệm cộng đồng.

### **Cài đặt & Thiết lập môi trường**

* Bàn giao cẩm nang kỹ thuật tiếng Anh hoàn chỉnh, giúp bất kỳ lập trình viên nào trong nhóm cũng có thể tra cứu cấu hình S3, Cognito, mẫu khóa DynamoDB chỉ trong vài giây.
* Đóng gói kịch bản khởi tạo dữ liệu mẫu (seed data) phục vụ thuyết trình mượt mà, độc lập.

### **Kỹ năng thực hành & Vận hành**

* Xác nhận độ trễ p95 đọc/ghi duy trì xuất sắc dưới ngưỡng mục tiêu trong bài test tải; hoàn thành xuất sắc các buổi tổng duyệt demo ReLoop.
* Tích cực tham gia và hoàn thành tốt nhiệm vụ đại diện cho chương trình AWS FCAJ trong hoạt động thiện nguyện cùng Operation Smile Việt Nam.
