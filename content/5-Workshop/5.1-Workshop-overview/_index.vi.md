---
title : "Tổng quan Workshop"
date : 2026-11-21
weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---

### Bạn sẽ xây dựng gì

**ReLoop** kết nối người có thiết bị điện tử cũ với các đối tác sửa chữa và tái chế đã được duyệt, đồng thời dùng AI kiểm duyệt và đọc ảnh thiết bị để tin đăng luôn sạch, có cấu trúc và chính xác. Bạn sẽ triển khai toàn bộ hệ thống `reloop2` hoàn toàn serverless tại vùng **Asia Pacific (Singapore) `ap-southeast-1`**, kết hợp phân phối và bảo vệ biên toàn cầu bằng **Amazon CloudFront** và **AWS WAF**.

![Kiến trúc tổng thể ReLoop trên AWS](/images/5-Workshop/5.1/overview.png)

### Giải thích kiến trúc theo đúng mũi tên 1 → 10

Mỗi học phần trong workshop khớp trực tiếp với các mũi tên đánh số và đường kết nối phụ trên sơ đồ:

| Bước | Mũi tên trên sơ đồ | Điều gì xảy ra | Xây dựng ở |
| --- | --- | --- | --- |
| **1** | **Users → CloudFront** (`HTTPS (TLS)`) | Trình duyệt kết nối HTTPS tới CloudFront. **AWS WAF (`reloop2-web`)** được gắn kèm (`associated web ACL`) để chặn IP xấu, tấn công web phổ biến và giới hạn tần suất yêu cầu. | [5.3](../5.3-global-edge/) |
| **2** | **CloudFront → S3 (website)** (`static files (OAC)`) | CloudFront đọc các tệp giao diện React riêng tư từ `reloop2-web-<suffix>` qua Origin Access Control (OAC) và điều hướng tuyến SPA ngay tại CloudFront. | [5.3](../5.3-global-edge/) |
| **3** | **Users → Cognito** (`sign up / sign in`) | Người dùng đăng ký và đăng nhập tại **Amazon Cognito** (`reloop2-user-pool`). Sau khi xác nhận tài khoản, Cognito kích hoạt `post-confirmation trigger` gọi **AWS Lambda (Post-confirm)** để tự tạo hồ sơ `Owner` trong DynamoDB (`create profile`). | [5.4](../5.4-sign-up-and-sign-in/) |
| **4** | **CloudFront → API Gateway** (`/api/* + x-origin-verify`) | Các yêu cầu `/api/*` được cắt tiền tố `/api` tại CloudFront rồi chuyển tiếp tới **Amazon API Gateway** kèm tiêu đề bí mật `x-origin-verify` nhằm chặn truy cập trực tiếp bỏ qua CloudFront. | [5.5](../5.5-api-backend/) |
| **5** | **API Gateway → Lambda (API)** (`invoke`) | API Gateway kiểm tra mã JWT của các tuyến bảo vệ qua Cognito (`verify JWT (JWKS)`), sau đó gọi **AWS Lambda (`reloop2-api`)** chạy Node.js 22 trên ARM64. | [5.5](../5.5-api-backend/) |
| **6** | **Lambda (API) ↔ DynamoDB** (`read/write users, listings & invoices`) | Lambda đọc và ghi hồ sơ người dùng, đối tác, tin đăng thiết bị, bộ hẹn giờ hết hạn và hóa đơn phí theo tháng trong một bảng on-demand duy nhất (`reloop2-core-table`). | [5.6](../5.6-dynamodb/) |
| **7** | **Lambda (API) ↔ S3 (photos)** (`presign & tag`) | Khi người bán đính kèm ảnh thiết bị, Lambda cấp URL ký sẵn (presigned URL) ngắn hạn và gắn thẻ trạng thái cho ảnh trong `reloop2-images-<suffix>`. | [5.7](../5.7-s3-photos/) |
| **8** | **Users ↔ S3 (photos)** (`upload / view photos (presigned URL)`) | Trình duyệt tải ảnh trực tiếp lên S3 riêng tư và xem ảnh tin đăng qua URL ký sẵn — không đẩy dữ liệu ảnh đi qua Lambda. | [5.7](../5.7-s3-photos/) |
| **9** | **Lambda (API) ↔ Rekognition** (`image moderation`) | Lambda gọi **Amazon Rekognition** để chặn ảnh không phù hợp và đọc chữ từ tem/nhãn thông số trên thiết bị. | [5.8](../5.8-ai-processing/) |
| **10** | **Lambda (API) ↔ Bedrock** (`AI analysis + Guardrail`) | Lambda lọc chữ trích xuất qua **Amazon Bedrock Guardrail** (`apac.guardrail.v1:0`) và gọi **Amazon Bedrock (`global.moonshotai.kimi-k3`)** tại `ap-southeast-1` để tự động điền tiêu đề, loại máy, hãng, tình trạng và mô tả lỗi. | [5.8](../5.8-ai-processing/) |

**Các đường vận hành nền (mũi tên nét đứt không đánh số):**

- **EventBridge → Lambda (API)** (`expire listings every 15 min`): Quy tắc `reloop2-sweep` gọi `reloop2-api` mỗi 15 phút để tự động đóng (chuyển sang hết hạn) các tin đăng đang mở đã quá hạn ([Học phần 5.9](../5.9-eventbridge/)).
- **Lambda (API) → CloudWatch** (`logs & metrics`) **→ SNS** (`alarm → email Admin`): Nhật ký Lambda lưu giữ 7 ngày, và cảnh báo `reloop2-lambda-errors` gửi thông báo qua chủ đề SNS `reloop2-alerts` tới email quản trị viên ([Học phần 5.10](../5.10-monitoring/)).

### Căn cứ lựa chọn dịch vụ

| Dịch vụ AWS đã chọn | Thay cho | Lý do lựa chọn (Chi phí · Mở rộng · Độ sẵn sàng) |
| --- | --- | --- |
| **API Gateway (HTTP API) + Lambda (`arm64`)** | EC2 / ECS | 0 USD khi rảnh, tự mở rộng tới 1.000 lượt song song, sẵn sàng cao Multi-AZ mặc định, chip Graviton `arm64` tiết kiệm ~20% chi phí. |
| **DynamoDB On-Demand (Single-Table)** | Amazon RDS | Không tốn phí máy chủ 24/7 (~$0,10/tháng ở quy mô workshop/dev), nhân bản Multi-AZ mặc định, tích hợp sẵn PITR & TTL. |
| **S3 + CloudFront (OAC) + Presigned URL** | Đẩy tệp qua backend | Độ bền 11 số 9 (`99,999999999%`), giảm tải cho Lambda, tối ưu băng thông (CloudFront Free Tier 1 TB/tháng), khóa kín bucket riêng tư. |
| **Cognito + Rekognition + Bedrock (Kimi K3 & Guardrail)** | Tự dựng Auth / tự host GPU | Quản lý hoàn toàn, serverless trả theo lượt dùng (10.000 MAU miễn phí; không tốn phí GPU rảnh), có sẵn kiểm duyệt ảnh và Guardrail bảo vệ. |

### Điểm nhấn bảo mật

| Khu vực trên sơ đồ | Cơ chế bảo vệ |
| --- | --- |
| **Global edge** | AWS WAF (`reloop2-web`, phạm vi CloudFront): giới hạn 100 req/phút cho API công khai, 1.000 req/phút/IP toàn cục, cùng 3 bộ quy tắc quản lý bởi AWS |
| **Cô lập Origin** | Cả hai bucket S3 đều bật Block Public Access (`reloop2-web` chỉ cho CloudFront OAC, `reloop2-images` chỉ qua presigned URL); `reloop2-api` từ chối mọi yêu cầu thiếu tiêu đề `x-origin-verify` |
| **Định danh** | Cognito User Pool (gói Essentials) bật chính sách mật khẩu, xác minh email, bảo vệ xóa `ACTIVE`, Auth Code PKCE và kiểm tra JWT (`JWKS`) trên tuyến `ANY /{proxy+}` của API Gateway |
| **An toàn AI** | Kiểm duyệt ảnh bằng Rekognition kết hợp Bedrock Guardrail (bậc `STANDARD`, mức `HIGH` cho Violence, Hate, Sexual, Insults, Misconduct và Prompt Attack) |
| **IAM tối thiểu quyền** | Hai vai trò Lambda tách biệt (`reloop2-post-confirmation-role` và `reloop2-api-lambda-role`), giới hạn đúng bảng `reloop2-core-table`, tiền tố `listings/*` và các hành động AI/nhật ký cần thiết |

### Ước tính chi phí Workshop

Hoàn thành học phần **5.2–5.11** và dọn dẹp ngay trong ngày ở học phần **5.12** tiêu tốn dưới **1,00 USD**:

| Dịch vụ | Mức sử dụng trong Workshop | Chi phí ước tính trong ngày |
| --- | --- | --- |
| **Amazon CloudFront & S3** | Hai bucket riêng tư (<20 MB), <1 GB lưu lượng | $0,00 (Free Tier) |
| **AWS WAFv2** | **1 Web ACL (`reloop2-web`)** + 5 quy tắc, tính theo ~1 ngày | ~$0,35 (hoặc ~$10/tháng nếu để chạy 30 ngày) |
| **Amazon Cognito** | Gói Essentials, 1–5 tài khoản thử | $0,00 (Free Tier: 10.000 MAU) |
| **API Gateway & Lambda** | ~100 lượt gọi, 512 MB ARM64 | $0,00 (Free Tier) |
| **Amazon DynamoDB** | Đọc/ghi theo yêu cầu (<5 MB, bật PITR) | ~$0,01 |
| **Rekognition & Bedrock** | Vài lượt kiểm duyệt ảnh + Guardrail + Kimi K3 | ~$0,05–$0,25 |
| **EventBridge, CloudWatch & SNS** | 1 quy tắc, 2 nhóm nhật ký, 1 cảnh báo, 1 chủ đề SNS | $0,00 (Free Tier) |
| **Tổng cộng (dựng & xóa trong ngày)** | Chạy thử đủ luồng + dọn dẹp ở 5.12 | **< 1,00 USD** |

{{% notice warning %}}
Mỗi Web ACL của AWS WAFv2 tính phí **$5/tháng + $1/tháng cho mỗi quy tắc** ngay cả khi không có lưu lượng. Hãy thực hiện [Học phần 5.12](../5.12-cleanup-and-iac/) ngay sau khi hoàn tất [Học phần 5.11](../5.11-end-to-end-verification/) để tránh phát sinh phí kéo dài.
{{% /notice %}}
