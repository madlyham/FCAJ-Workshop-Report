---
title: "Worklog tuần 7"
date: 2026-11-07
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

# **Nhật ký tuần 7: Quy trình upload ảnh S3 an toàn, kiểm duyệt bằng Rekognition và vòng đời dữ liệu**

## **1. Mục tiêu trong tuần**

* Xây dựng luồng tải ảnh S3 an toàn bằng Presigned POST ticket tạm thời (POST /uploads/presign).
* Tích hợp kiểm duyệt nội dung tự động bằng Amazon Rekognition (DetectModerationLabels) để chặn ảnh không phù hợp.
* Cấu hình vòng đời S3 Lifecycle rules để tự động dọn dẹp các tệp ảnh chưa liên kết và ảnh cũ sau thời gian định sẵn.

## **2. Kế hoạch thực hiện trong tuần**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Ngày 2** | • Viết module S3ImageStore: cấp presigned POST ticket hiệu lực 300s (giới hạn tối đa 5MB, tối đa 6 ảnh/bài đăng) | 09/22/2025 | 09/22/2025 | Tài liệu AWS S3 SDK |
| **Ngày 3** | • Khóa quyền theo tiền tố người dùng (listings/<userId>/) với hàm assertOwnImageKeys() ngăn chặn gán ảnh trái phép | 09/23/2025 | 09/23/2025 | imageStore.ts |
| **Ngày 4** | • Triển khai RekognitionModerator gọi API DetectModerationLabels với ngưỡng tin cậy MinConfidence: 70 | 09/24/2025 | 09/24/2025 | Tài liệu AWS Rekognition |
| **Ngày 5** | • Tự động xóa ảnh vi phạm khỏi S3, ghi nhận chỉ số ImagesRejected lên CloudWatch và trả mã lỗi 422 IMAGE_REJECTED | 09/25/2025 | 09/25/2025 | moderateUpload() |
| **Ngày 6** | • Cấu hình vòng đời S3: xóa ảnh pending chưa liên kết sau 1 ngày và xóa ảnh bài đăng sau 120 ngày | 09/26/2025 | 09/26/2025 | infra/*.tf |

## **3. Kết quả đạt được**

### **Nền tảng lý thuyết**

* Nắm vững cơ chế gắn thẻ S3 object (state=pending -> moderation=passed -> state=attached) giúp S3 Lifecycle tự động dọn dẹp ảnh rác hoàn toàn miễn phí mà không cần viết cron job.

### **Thiết lập & cấu hình môi trường**

* Cấu hình biến môi trường IMAGE_BUCKET=reloop-device-images kèm adapter giả lập DisabledImageStore cho môi trường kiểm thử offline.

### **Kỹ năng thực hành & vận hành hệ thống**

* Kiểm thử tải ảnh linh kiện hợp lệ và ảnh vi phạm thử nghiệm; xác nhận hàm assertModerated() chặn đứng mọi hành vi bỏ qua bước kiểm duyệt.
