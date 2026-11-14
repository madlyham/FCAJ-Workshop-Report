---
title : "Lưu trữ Ảnh S3 Riêng tư, CORS & Lifecycle"
date : 2026-11-14
weight : 5
chapter : false
pre : " <b> 5.5. </b> "
---

Ảnh thiết bị do người dùng tải lên được đẩy trực tiếp từ trình duyệt vào bucket **Amazon S3** riêng tư (`reloop2-images-<suffix>`, ví dụ `reloop2-images-7k3q`) thông qua **presigned URL** ngắn hạn do Lambda cấp. **Block All Public Access** luôn bật, CORS cho phép trình duyệt upload an toàn, và 3 **Lifecycle rules** tự động dọn ảnh rác chưa gắn tin sau 1 ngày và thu hồi dung lượng sau 90 ngày.

![Phạm vi Phần 5.5: Amazon S3 Media Bucket](/images/5-Workshop/5.5/architecture.png)

---

### Bước 1 — Tạo bucket riêng tư `reloop2-images-<suffix>`

1. Vào **Amazon S3 -> Buckets** tại **`ap-southeast-1`**, bấm **Create bucket**.

![Danh sách S3 Buckets](/images/5-Workshop/5.5/01-s3-buckets.png)

2. Ở mục **General configuration**:
   - **AWS Region:** `ap-southeast-1`
   - **Bucket name:** `reloop2-images-7k3q` (thay `7k3q` bằng hậu tố duy nhất toàn cầu của bạn)

![Tạo bucket reloop2-images-7k3q](/images/5-Workshop/5.5/02-create-bucket-form.png)

3. Giữ nguyên tích chọn **Block all public access** để ảnh không bị truy cập công khai trái phép.

![Giữ nguyên Block all public access](/images/5-Workshop/5.5/03-block-public-access.png)

4. Gắn tags (`Owner=team`, `Project=reloop2`, `Purpose=workshop`), bật mã hóa mặc định **SSE-S3 (`AES256`) + Bucket Key**, rồi bấm **Create bucket**.

![Cấu hình mã hóa SSE-S3 và tags](/images/5-Workshop/5.5/04-tags-encryption.png)

![Bucket reloop2-images-7k3q đã sẵn sàng](/images/5-Workshop/5.5/05-bucket-created.png)

---

### Bước 2 — Cấu hình CORS cho phép upload trực tiếp từ trình duyệt

5. Mở bucket `reloop2-images-7k3q` -> tab **Permissions** -> mục **Cross-origin resource sharing (CORS)** -> bấm **Edit** và dán cấu hình JSON sau (ở Phần **5.8** ta sẽ thêm domain CloudFront):

```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["PUT", "POST", "GET"],
    "AllowedOrigins": ["http://localhost:5173"],
    "ExposeHeaders": ["ETag"]
  }
]
```

![Nhập JSON cấu hình CORS](/images/5-Workshop/5.5/06-cors-edit.png)

![Đã lưu cấu hình CORS](/images/5-Workshop/5.5/07-cors-saved.png)

---

### Bước 3 — Tạo 3 Lifecycle Rules tối ưu chi phí

6. Vào tab **Management -> Lifecycle rules** -> **Create lifecycle rule** cho cả 3 quy tắc:

| Tên Rule | Phạm vi lọc | Hành động |
| --- | --- | --- |
| `reloop2-listing-images-unattached` | Tiền tố `listings/` VÀ object tag `state = pending` | Hết hạn sau **1 ngày** |
| `reloop2-listing-images-retention` | Tiền tố `listings/` | Hết hạn sau **90 ngày** |
| `reloop2-abort-incomplete-uploads` | Tiền tố `listings/` | Hủy multipart upload lỗi sau **1 ngày** |

![Rule 1: Xóa ảnh pending chưa gắn tin sau 1 ngày](/images/5-Workshop/5.5/08-lifecycle-unattached.png)

![Rule 2: Lưu trữ ảnh tin đăng tối đa 90 ngày](/images/5-Workshop/5.5/09-lifecycle-retention.png)

![Rule 3: Dọn multipart upload dở dang](/images/5-Workshop/5.5/10-lifecycle-abort-uploads.png)

7. Xác nhận cả **3 Lifecycle rules** đều ở trạng thái **Enabled**.

![Cả 3 Lifecycle rules đã được kích hoạt](/images/5-Workshop/5.5/11-lifecycle-rules-list.png)
