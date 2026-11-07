---
title: "Nhật ký công việc Tuần 7"
date: 2026-11-07
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

# **Nhật ký công việc Tuần 7: Tải ảnh an toàn S3, Kiểm duyệt Rekognition & Khởi động Buildrathon**

## **1. Mục tiêu tuần**

* Xây dựng luồng tải ảnh an toàn lên S3 qua Presigned POST ticket (POST /uploads/presign).
* Tích hợp Amazon Rekognition (DetectModerationLabels) tự động kiểm duyệt và chặn ảnh không an toàn.
* Cấu hình S3 Lifecycle rules tự động dọn dẹp các tệp ảnh mồ côi và tối ưu hóa chi phí.
* Tham gia Sự kiện 1: Khởi động Buildrathon (CMC Global) tại Bitexco Financial Tower để liên kết hạ tầng serverless với suy luận AI Agent đa phương thức.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Viết module S3ImageStore: cấp presigned POST ticket hiệu lực 300s (giới hạn tối đa 5MB, tối đa 6 ảnh/bài đăng) | 09/21/2026 | 09/21/2026 | Tài liệu AWS S3 SDK |
| **Ngày 3** | • Khóa quyền theo tiền tố người dùng (listings/<userId>/) với hàm assertOwnImageKeys() ngăn chặn gán ảnh trái phép | 09/22/2026 | 09/22/2026 | imageStore.ts |
| **Ngày 4** | • Hiện thực RekognitionModerator gọi hàm DetectModerationLabels (ngưỡng tin cậy MinConfidence: 70) | 09/23/2026 | 09/23/2026 | Tài liệu AWS Rekognition |
| **Ngày 5** | • Tự động xóa ảnh vi phạm khỏi S3, ghi log metric ImagesRejected và trả về lỗi 422 IMAGE_REJECTED | 09/24/2026 | 09/24/2026 | moderateUpload() |
| **Ngày 6** | • Thiết lập vòng đời S3 Lifecycle: xóa ảnh pending không gắn bài sau 1 ngày, lưu trữ ảnh bài đăng 120 ngày | 09/25/2026 | 09/25/2026 | infra/*.tf |
| **Ngày 7** | • Tham gia [Sự kiện 1: Khởi động Buildrathon – Code the Future cùng CMC Global](../../4-eventparticipated/4.1-event1/) (10:30 – 12:00 tại Bitexco Financial Tower). Khám phá Generative AI, quy trình Agentic AI và kiến trúc RAG. | 09/26/2026 | 09/26/2026 | Sự kiện 1 / CMC Global & AWS |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Nắm vững cơ chế gắn tag đối tượng S3 (state=pending -> moderation=passed -> state=attached) giúp S3 Lifecycle tự động dọn rác hoàn toàn miễn phí mà không cần máy chủ cron job.
* Liên kết kiến trúc serverless trên AWS với khả năng suy luận của AI Agent và mô hình RAG dựa trên các chia sẻ tại sự kiện Khởi động Buildrathon tại Bitexco.

### **Cài đặt & Thiết lập môi trường**

* Cấu hình IMAGE_BUCKET=reloop-device-images vào backend cùng fallback DisabledImageStore cho môi trường offline test.
* Thiết lập chính sách S3 CORS và Bucket Policy chặt chẽ, chỉ cho phép presigned upload hợp lệ.

### **Kỹ năng thực hành & Vận hành**

* Kiểm thử thực tế tải ảnh linh kiện hợp lệ và ảnh thử nghiệm vi phạm; xác nhận assertModerated() chặn đứng mọi hành vi lách luật.
* Tham dự trọn vẹn Sự kiện 1 (Khởi động Buildrathon), mở rộng mạng lưới kết nối cùng các chuyên gia giải pháp AWS.
