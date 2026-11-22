---
title: "Đề xuất (Proposal)"
date: 2026-11-22
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

## ReLoop

*Nền tảng mua bán thiết bị điện tử cũ, hỏng có AI hỗ trợ theo kiến trúc serverless trên AWS*

### 1. Tóm tắt tổng quan
ReLoop là nền tảng web mua bán giúp người dùng tại Việt Nam bán thiết bị điện tử cũ hoặc hỏng (điện thoại, laptop, màn hình, linh kiện) cho các tiệm sửa chữa, đơn vị thu mua và cơ sở tái chế gần mình. Dự án do **AWSS3nt1n4L**, nhóm 5 thành viên thuộc chương trình AWS First Cloud AI Journey (FCAJ) tại TP. Hồ Chí Minh, xây dựng trong 12 tuần thực tập (14/09–04/12/2026). Người bán tải ảnh thiết bị lên, Amazon Bedrock sẽ tự động gợi ý điền sẵn thông tin tin đăng. Tin sau đó được kết nối tới mọi đơn vị thu mua đã được duyệt có bán kính phục vụ của chi nhánh (1–15 km) bao gồm vị trí người bán, và giao dịch được chốt qua báo giá của bên mua hoặc mức giá hai bên thỏa thuận trong chat.

Theo số liệu nền của môi trường dev tính đến **08/11/2026** (bao gồm giai đoạn dev đầu tiên từ **10/10 đến 08/11/2026**), nền tảng ghi nhận 14 tài khoản đăng ký, 12 tin đang mở của 7 người bán và khoảng 31.000 request API (bao gồm cả lưu lượng kiểm thử tự động QA, smoke test và load test); số dư credit AWS tính đến **21/11/2026** còn **189,80 USD**, hiệu lực đến 28/02/2027. Thiết kế serverless tự động mở rộng mà không cần tái cấu trúc: tài khoản chạy ở hạn mức thực thi đồng thời theo vùng tiêu chuẩn mặc định 1.000 của AWS Lambda (tài khoản mới thường bắt đầu ở mức 10 và cần gửi yêu cầu nâng hạn mức), trong khi API Gateway giới hạn lưu lượng HTTP ở mức 20 request/giây (burst 50). Nền tảng sử dụng 12 dịch vụ AWS được quản lý (cùng AWS IAM cho phân quyền tối thiểu): **CloudFront, AWS WAF, S3, Cognito, API Gateway, Lambda, DynamoDB, Rekognition, Bedrock, EventBridge, CloudWatch và SNS**. Khách xem chợ công khai không cần tài khoản; người dùng đã đăng nhập (`Owners`) có thể nhắn tin và mua hàng; đối tác được Admin duyệt (`Partners`) được mở khóa quyền đăng bán (Cấp 1) hoặc thu mua và gửi báo giá (Cấp 2); còn `Admins` và `FinanceAdmins` kiểm duyệt nội dung bị gắn cờ và quản lý hóa đơn phí hằng tháng.

{{% notice tip %}}
**Bản Demo trực tuyến (Live Demo):** [https://d1cjl1tvcp0r6q.cloudfront.net/](https://d1cjl1tvcp0r6q.cloudfront.net/) (bản triển khai HTTPS trực tiếp của ReLoop trên CloudFront)  
**Mã nguồn đồng hành & Terraform Repo:** [https://github.com/madlyham/ReLoop](https://github.com/madlyham/ReLoop)
{{% /notice %}}

#### Thành viên nhóm

| Thành viên | Vai trò |
|---|---|
| Kung Cẩm Thành | Trưởng nhóm (Team Lead) |
| Hoàng Quốc Việt | Trưởng kỹ thuật (Tech Lead) |
| Trần Hoàng Quốc Trung | Kỹ sư Backend |
| Nguyễn Duy Quang | Kỹ sư Frontend |
| Nguyễn Anh Kỳ | An ninh mạng / Tài liệu |

### 2. Bài toán & Giải pháp
#### Vấn đề hiện tại
Theo Global E-waste Monitor 2024 (UNITAR/ITU), năm 2022 thế giới thải ra 62 triệu tấn rác điện tử, nhưng chỉ 22,3% được thu gom và tái chế chính thức. Cũng theo báo cáo này, Việt Nam thải ra khoảng 516.000 tấn (≈5,3 kg mỗi người) năm 2022. Người có thiết bị cũ hoặc hỏng hiếm khi biết ai sẽ mua và thiết bị đáng giá bao nhiêu. Hiện họ phải đăng lên các trang rao vặt tổng hợp hoặc nhóm mạng xã hội, tự mô tả thủ công, gọi từng tiệm và thường không nhận được phản hồi. Các sàn rao vặt tổng hợp như Chợ Tốt hay Facebook Marketplace được thiết kế cho mọi loại mặt hàng nên thiếu các tính năng chuyên biệt cho thiết bị điện tử cũ:

- Tự động kết nối tin đăng với các tiệm sửa chữa có bán kính phục vụ bao gồm vị trí người bán.
- Hiển thị ước tính giá ngay từ đầu theo bảng quy tắc giá của từng bên thu mua.
- Lưu lịch sử uy tín gồm điểm đánh giá sao, tỷ lệ hoàn tất/hủy giao dịch và cờ cảnh báo lệch giá dự kiến.

Ở chiều ngược lại, các tiệm sửa chữa nhỏ cũng gặp khoảng trống tương tự: họ thiếu một kênh chi phí thấp để tiếp nhận các thiết bị gần mình phù hợp với danh mục cần thu mua.

#### Giải pháp
ReLoop chạy trọn luồng trên các dịch vụ serverless được quản lý của AWS, không cần vận hành máy chủ:

- **Nhận ảnh (Photo Ingest):** trình duyệt tải tối đa 6 ảnh mỗi tin (JPEG/PNG/WebP, tối đa 5 MB mỗi ảnh) thẳng lên bucket Amazon S3 riêng tư qua presigned POST URL ngắn hạn. Amazon Rekognition kiểm tra từng ảnh để chặn nội dung nhạy cảm và trích xuất chữ in trên nhãn thiết bị. Amazon Bedrock Guardrails lọc phần văn bản đó để gắn cờ nội dung chèn lệnh tấn công AI (prompt injection) hoặc nội dung độc hại để chuyển Admin kiểm duyệt.
- **Xử lý API & AI:** một hàm AWS Lambda (Node.js 22, arm64) đứng sau Amazon API Gateway phục vụ 111 route API và tự kích hoạt bất đồng bộ cho các tác vụ tốn thời gian:
  - AI phân tích ảnh bằng Kimi K3 trên Amazon Bedrock (khoảng 35 giây mỗi lần, đọc tối đa 3 ảnh để gợi ý thông tin tin đăng);
  - ghép tin với các chi nhánh thu mua trong phạm vi phục vụ bằng geohash + Haversine.
- **Tự động hết hạn (Scheduled Expiry):** Amazon EventBridge kích hoạt cùng hàm Lambda này mỗi 15 phút để tự động đóng các tin đăng đã quá hạn 7 ngày.
- **Lưu trữ:** một bảng Amazon DynamoDB on-demand (khóa phân vùng/sắp xếp + 1 Global Secondary Index) lưu mọi dữ liệu: người dùng, đối tác, chi nhánh, quy tắc giá, tin đăng, báo giá, giao dịch, chat, đánh giá, lịch hết hạn tin đăng, hóa đơn và nhật ký kiểm toán (audit log). Lệnh ghi có điều kiện và header `Idempotency-Key` trên các API liên quan tới phí giúp tránh trùng lặp hoặc xung đột dữ liệu. Quy tắc lifecycle của S3 xóa ảnh chưa gắn tin sau 1 ngày và xóa ảnh tin đăng sau 90 ngày.
- **Giao diện web:** ứng dụng web trang đơn (SPA) viết bằng React, phục vụ từ bucket S3 riêng tư qua Amazon CloudFront, gồm chợ công khai, cổng đối tác 2 cấp và cổng Admin.
- **Bảo mật:** Amazon Cognito xử lý đăng ký và đăng nhập với 4 nhóm (`Admins`, `FinanceAdmins`, `Partners`, `Owners`), kích hoạt hàm Lambda Post-confirm để tạo hồ sơ người dùng. API Gateway (HTTP API) xác thực JWT của Cognito trên mọi route riêng tư (không kiểm tra custom origin header). Một AWS WAF web ACL gắn trên CloudFront áp dụng bộ luật do AWS quản lý và giới hạn tốc độ theo IP, trong khi hàm Lambda (`reloop-api`) kiểm tra header bí mật `x-origin-verify` từ CloudFront để từ chối mọi truy cập trực tiếp bỏ qua CloudFront. Hai IAM role riêng biệt theo nguyên tắc quyền tối thiểu giới hạn từng hàm Lambda chỉ truy cập đúng tài nguyên cần thiết.

So với trang rao vặt tổng hợp, ReLoop bổ sung: AI tự điền tin, ghép theo vùng phục vụ, ước tính giá theo bảng quy tắc của bên mua, hoàn tất 2 bước (người bán xác nhận giá cuối, bên mua chấp nhận) và đánh giá hai chiều. ReLoop không giữ tiền hộ: hai bên thanh toán trực tiếp khi bàn giao.

#### Lợi ích và hoàn vốn đầu tư (ROI)
- **Giảm nhập tay:** AI gợi ý tiêu đề, danh mục, hãng, model và tình trạng từ tối đa 3 ảnh đã tải, người bán chỉ cần kiểm tra hoặc chỉnh nhẹ. Thời gian đăng một tin giảm từ khoảng 5 phút nhập tay xuống dưới 1 phút (nhóm ước tính).
- **Ít tin bị bỏ ngỏ:** mỗi tin mới tự động gửi tới mọi chi nhánh bên mua có bán kính phục vụ phù hợp, ưu tiên xếp trước các đơn vị trong vòng 5 km.
- **Độ tin cậy:** các máy trạng thái (state machine) rõ ràng, lệnh ghi DynamoDB có điều kiện và tác vụ nền chống trùng lặp (idempotent) giữ tin đăng, báo giá và giao dịch luôn nhất quán. Hệ thống có 182 test tự động và kiểm chứng trực tiếp trọn luồng trên AWS.
- **Giá trị học tập:** nhóm thực hành thiết kế DynamoDB một bảng, Lambda hướng sự kiện, Amazon Bedrock trả JSON có cấu trúc kèm Guardrail, tinh chỉnh WAF trên CloudFront và Infrastructure as Code bằng Terraform.
- **Chi phí:** khoảng **11,70 USD/tháng (140,40 USD/năm)** ở mức nền môi trường dev ghi nhận tính đến 08/11/2026 (mục 6). Trong đó **10,00 USD** là AWS WAF web ACL trên CloudFront, nên nếu không dùng WAF thì chi phí nền tảng chỉ khoảng **1,70 USD/tháng**. Đến 28/02/2027, số credit AWS còn lại của tài khoản (**189,80 USD** tính đến 21/11/2026) chi trả trọn vẹn mà không tốn tiền mặt.
- **Hoàn vốn:** doanh thu là 10.000đ mỗi giao dịch hoàn tất, người bán trả. Với tỷ giá xấp xỉ 1 USD ≈ 26.000đ (tháng 11/2026), 11,70 USD ≈ 304.200đ. Nền tảng hòa vốn ở **31 giao dịch hoàn tất mỗi tháng**, hoặc **5 giao dịch/tháng** nếu không bật WAF.

### 3. Kiến trúc giải pháp
ReLoop chạy trên kiến trúc hoàn toàn serverless tại **Asia Pacific (Singapore) `ap-southeast-1`**, được bảo vệ và phân phối toàn cầu ở lớp biên bằng Amazon CloudFront và AWS WAF.

![Kiến trúc serverless của ReLoop trên AWS](/images/5-Workshop/5.1/overview.png)

#### Luồng xử lý đầu cuối (Mũi tên 1 → 10)
1. **Users → CloudFront (`HTTPS (TLS)`):** trình duyệt kết nối HTTPS tới CloudFront. **AWS WAF** gắn trực tiếp lên CloudFront (web ACL) để chặn IP độc hại, lỗ hổng web phổ biến và tốc độ truy cập bất thường.
2. **CloudFront → S3 Website (`static files (OAC)`):** CloudFront lấy file ứng dụng React riêng tư từ S3 qua Origin Access Control (OAC) và tự viết lại đường dẫn SPA ngay tại lớp biên.
3. **Users → Cognito (`sign up / sign in`):** người dùng đăng ký và đăng nhập trực tiếp với Amazon Cognito. Khi xác nhận email xong, Cognito kích hoạt **AWS Lambda (Post-confirm)** tạo hồ sơ người dùng ban đầu trong DynamoDB.
4. **CloudFront → API Gateway (`/api/* + x-origin-verify`):** CloudFront bỏ tiền tố `/api` khỏi các request `/api/*` rồi chuyển tiếp tới API Gateway kèm header bí mật `x-origin-verify`.
5. **API Gateway → Lambda (API) (`invoke`):** API Gateway (HTTP API) kiểm chữ ký JWT của Cognito qua JWKS trên mọi route riêng tư (không kiểm tra custom origin header) rồi gọi hàm Lambda API chính (Node.js 22, `reloop-api`), nơi kiểm tra header bí mật `x-origin-verify` từ CloudFront để từ chối mọi truy cập trực tiếp bỏ qua CloudFront.
6. **Lambda (API) ↔ DynamoDB (`read/write users, listings & invoices`):** Lambda đọc/ghi người dùng, chi nhánh đối tác, tin đăng, báo giá, chat, lịch hết hạn tin đăng và hóa đơn phí hằng tháng trong một bảng on-demand duy nhất.
7. **Lambda (API) ↔ S3 Photos (`presign & tag`):** Lambda cấp presigned URL ngắn hạn để tải lên/xem ảnh và gắn thẻ trạng thái kiểm duyệt cũng như trạng thái đính kèm.
8. **Users ↔ S3 Photos (`upload / view photos`):** trình duyệt tải lên và xem ảnh thiết bị trực tiếp với S3 riêng tư qua presigned URL — không chuyển file ảnh qua Lambda.
9. **Lambda (API) ↔ Rekognition (`image moderation`):** Lambda kiểm duyệt ảnh nhạy cảm và trích xuất chữ in trên tem nhãn thiết bị.
10. **Lambda (API) ↔ Bedrock (`AI analysis + Guardrail`):** Lambda lọc chữ trích xuất qua **Amazon Bedrock Guardrails** (`apac.guardrail.v1:0`) rồi gọi **Kimi K3** (`global.moonshotai.kimi-k3`) qua Bedrock từ `ap-southeast-1` (các profile đa vùng này có thể định tuyến suy luận ra ngoài Singapore) để trả về gợi ý tin đăng dạng JSON có cấu trúc.

**Các luồng xử lý nền và vận hành:**
- **EventBridge → Lambda (API) (`expire listings every 15 min`):** lịch chạy mỗi 15 phút quét các mốc hết hạn theo khung thời gian và tự đóng tin đăng quá hạn.
- **Lambda (API) → CloudWatch (`logs & metrics`) → SNS (`alarm → email Admin`):** log có cấu trúc của Lambda lưu 7 ngày; khi lỗi Lambda vượt ngưỡng, alarm gửi email cảnh báo cho Admin qua SNS.

#### Dịch vụ AWS sử dụng
- **Amazon CloudFront:** phân phối HTTPS toàn cầu, phục vụ web React riêng tư từ S3 qua OAC và chuyển tiếp `/api/*` tới API Gateway kèm header bí mật `x-origin-verify` (được kiểm tra tại hàm Lambda `reloop-api`).
- **AWS WAF:** 1 web ACL phạm vi CloudFront gồm 3 bộ luật do AWS quản lý (IP Reputation, Known Bad Inputs, Common Rule Set) và 2 giới hạn tốc độ theo IP trả mã `429` (100 request/phút cho API công khai; 1.000 request/phút cho toàn hệ thống).
- **Amazon S3:** 2 bucket riêng tư (bật Block Public Access) — một chứa bản build web tĩnh (chỉ mở qua OAC) và một chứa ảnh thiết bị (presigned POST/GET kèm lifecycle xóa ảnh chưa dùng sau 1 ngày và xóa mọi ảnh sau 90 ngày).
- **Amazon Cognito:** user pool gói Essentials có xác minh email, Auth Code PKCE và 4 nhóm (`Admins`, `FinanceAdmins`, `Partners`, `Owners`). Trình duyệt giao tiếp thẳng với Cognito; trigger post-confirmation gọi Lambda Post-confirm để tạo hồ sơ trong DynamoDB. Ghi nhận 14 tài khoản đăng ký tính đến 08/11/2026.
- **Amazon API Gateway (HTTP API):** xác thực JWT Cognito (JWKS) trên các route riêng tư (custom origin header như `x-origin-verify` được kiểm tra tại hàm Lambda `reloop-api`) và giới hạn lưu lượng HTTP ở mức 20 request/giây (burst 50).
- **AWS Lambda:** 2 hàm tại `ap-southeast-1`:
  - **Lambda API (`reloop-api`)** (Node.js 22, arm64/Graviton, 512 MB): phục vụ 111 route API, kiểm tra header bí mật `x-origin-verify` từ CloudFront, chạy tác vụ AI/ghép tin bất đồng bộ và job quét định kỳ. Thời gian chạy trung bình quan sát trên CloudWatch môi trường dev là 144 ms; tài khoản chạy ở hạn mức thực thi đồng thời theo vùng tiêu chuẩn mặc định 1.000 của AWS Lambda (tài khoản mới thường bắt đầu ở mức 10 và cần gửi yêu cầu nâng hạn mức), trong khi API Gateway giới hạn lưu lượng HTTP ở mức 20 request/giây (burst 50).
  - **Lambda Post-confirm** (Python 3.12): ghi hồ sơ người dùng ban đầu vào DynamoDB ngay sau khi xác nhận tài khoản Cognito.
- **Amazon DynamoDB:** 1 bảng on-demand (`PK`/`SK` + `GSI1`), bật Point-in-Time Recovery (PITR) và Time-to-Live (TTL), lưu khoảng 5.600 bản ghi (2,4 MB) tính đến 08/11/2026.
- **Amazon Rekognition:** kiểm duyệt nội dung tự động (từ chối ảnh nhạy cảm, ca nghi ngờ chuyển Admin) và nhận diện chữ trong mọi ảnh tải lên.
- **Amazon Bedrock:** được gọi từ `ap-southeast-1`. **Bedrock Guardrail** gói Standard (`apac.guardrail.v1:0`) lọc chữ đọc từ ảnh để chặn prompt injection và nội dung độc hại; **Kimi K3** (`global.moonshotai.kimi-k3`) qua Converse API trả về JSON có cấu trúc cho thông tin thiết bị. Do sử dụng profile đa vùng (`global.moonshotai.kimi-k3` và `apac.guardrail.v1:0`), Bedrock có thể định tuyến suy luận xuyên vùng ra ngoài Singapore. Kết quả được kiểm lại bằng schema chặt ở backend, mỗi người dùng tối đa 20 lượt phân tích AI/ngày.
- **Amazon EventBridge:** 1 lịch định kỳ mỗi 15 phút (`rate(15 minutes)`) kích hoạt job quét hết hạn tin đăng.
- **Amazon CloudWatch:** lưu log của Lambda API trong 7 ngày kèm 1 metric alarm theo dõi lỗi Lambda (ngưỡng ≥ 3 lỗi trong 5 phút).
- **Amazon SNS:** gửi email cảnh báo cho Admin ngay khi alarm CloudWatch chuyển sang trạng thái `ALARM`.
- **AWS IAM:** 2 execution role riêng biệt theo nguyên tắc quyền tối thiểu — một role chỉ có quyền ghi hồ sơ vào DynamoDB cho Lambda Post-confirm, và một role giới hạn chặt vào bảng chính, tiền tố thư mục ảnh S3, ARN model Kimi K3 / Guardrail, CloudWatch Logs và tài nguyên `*` bắt buộc cho Rekognition (theo yêu cầu của AWS IAM) cho Lambda API.

#### Căn cứ lựa chọn dịch vụ

| Dịch vụ AWS đã chọn | Phương án thay thế cân nhắc | Lý do lựa chọn (Chi phí · Khả năng mở rộng · Sẵn sàng & Vận hành) |
|---|---|---|
| **API Gateway (HTTP API) + Lambda (`arm64` Graviton)** | Amazon EC2 hoặc Amazon ECS | **0 USD khi không có tải** (Always Free 1 triệu request + 400.000 GB-s/tháng) và chip Graviton `arm64` tiết kiệm ~20% chi phí tính toán so với `x86_64`; tự mở rộng tới hạn mức vùng tiêu chuẩn mặc định **1.000 phiên thực thi đồng thời** của AWS Lambda (tài khoản mới thường bắt đầu ở mức 10 và cần yêu cầu nâng hạn mức; API Gateway giới hạn lưu lượng HTTP ở **20 request/giây, burst 50**), sẵn sàng cao Multi-AZ mặc định và không cần vá hệ điều hành. |
| **Amazon DynamoDB On-Demand (Single-Table)** | Amazon RDS (MySQL/PostgreSQL) | Không tốn phí máy chủ chạy 24/7 (**~0,10 USD/tháng** ở tải hiện tại); tự mở rộng theo từng yêu cầu; nhân bản Multi-AZ mặc định kèm sẵn **PITR (35 ngày)** và tự xóa bằng **TTL**. |
| **Amazon S3 + CloudFront (OAC) + Presigned URL** | Đẩy tệp ảnh qua backend hoặc mở bucket công khai | **Độ bền dữ liệu đạt 99,999999999%**; giảm tải hoàn toàn dữ liệu ảnh khỏi Lambda (tránh giới hạn payload và tốn RAM); tối ưu băng thông với CloudFront Free Tier (**1 TB + 10 triệu request/tháng**); khóa kín bucket bằng OAC và presigned URL ngắn hạn. |
| **Amazon Cognito + Rekognition + Bedrock (Kimi K3 & Guardrail)** | Tự dựng hệ thống Auth + tự host mô hình GPU | Quản lý hoàn toàn, trả tiền theo lượt dùng (Cognito miễn phí tới **10.000 MAU**, không tốn chi phí duy trì GPU khi không có tải); có sẵn JWT/JWKS, kiểm duyệt ảnh tự động và **Amazon Bedrock Guardrails** chặn prompt injection. |
| **AWS WAF (CloudFront) + EventBridge + CloudWatch / SNS** | Tự vận hành reverse proxy, máy chủ cron & hệ thống giám sát | Giới hạn tốc độ và bộ luật OWASP ở biên không cần bảo trì proxy; lịch chạy serverless mỗi 15 phút cùng log, alarm và email cảnh báo Admin trong Free Tier. |

#### Tuân thủ AWS Well-Architected Framework

| Trụ cột | Cách ReLoop áp dụng |
| --- | --- |
| **Vận hành xuất sắc (Operational Excellence)** | Hạ tầng Terraform IaC mô-đun hóa tái tạo được ([`madlyham/ReLoop/terraform/`](https://github.com/madlyham/ReLoop/tree/main/terraform)) + GitHub Actions CI chạy kiểm thử và build, CloudWatch Logs dạng JSON có cấu trúc (lưu 7 ngày) và cảnh báo lỗi Lambda → gửi email SNS tới Admin. |
| **Bảo mật (Security)** | AWS WAF gắn trên CloudFront (3 bộ luật do AWS quản lý + 2 giới hạn tốc độ theo IP), bucket S3 riêng tư (Block Public Access + OAC + presigned URL ngắn hạn), header bí mật `x-origin-verify` từ CloudFront được hàm Lambda (`reloop-api`) kiểm tra để chặn gọi thẳng bỏ qua CloudFront, xác thực Cognito JWT (`JWKS`) tại API Gateway HTTP API trên `ANY /{proxy+}`, hai IAM role giới hạn chặt vào bảng chính, tiền tố thư mục ảnh S3, ARN model Kimi K3 / Guardrail và tài nguyên `*` bắt buộc cho Rekognition (theo yêu cầu của AWS IAM), kiểm duyệt bằng Rekognition + Bedrock Guardrail và không lưu cứng bí mật trong Git. |
| **Độ tin cậy (Reliability)** | Lớp biên toàn cầu CloudFront + các dịch vụ serverless vùng Multi-AZ (API Gateway giới hạn 20 request/giây / burst 50, Lambda ở hạn mức vùng tiêu chuẩn 1.000 phiên đồng thời, DynamoDB on-demand kèm PITR 35 ngày), độ bền S3 11 số 9 (`99,999999999%`), lệnh ghi DynamoDB có điều kiện & `Idempotency-Key`, lịch EventBridge 15 phút tự đóng tin hết hạn và cơ chế hạ cấp an toàn khi Bedrock gián đoạn (người bán vẫn nhập biểu mẫu thủ công bình thường). |
| **Hiệu năng (Performance Efficiency)** | Bộ nhớ đệm biên CloudFront cho tệp SPA, Lambda Node.js 22 trên ARM64 (Graviton) (thời gian chạy trung bình 144 ms quan sát trên CloudWatch môi trường dev), DynamoDB một bảng kèm `GSI1` và truy vấn chia khung thời gian (không quét toàn bảng), trình duyệt tải ảnh thẳng lên S3 qua presigned POST/GET giúp không đẩy tệp nhị phân qua Lambda và tự gọi bất đồng bộ cho tác vụ phân tích AI ~35 giây. |
| **Tối ưu chi phí (Cost Optimization)** | Serverless trả theo mức dùng nằm phần lớn trong Free Tier (`11,70 USD/tháng` tổng cộng gồm `10,00 USD` AWS WAF trên CloudFront; `1,70 USD/tháng` nếu không bật WAF; `< 1,00 USD` khi chạy workshop và xóa trong ngày), ARM64 Graviton tiết kiệm ~20% chi phí tính toán, lifecycle S3 1 ngày ảnh chờ / 90 ngày lưu trữ, lưu log CloudWatch 7 ngày, giới hạn 20 lượt AI/người/ngày và hướng dẫn dọn dẹp ngược thứ tự đầy đủ. |
| **Tính bền vững (Sustainability)** | Kiến trúc serverless tự thu về 0 khi không có tải giúp loại bỏ máy chủ chạy không tải 24/7; bộ xử lý ARM64 Graviton nâng cao hiệu năng trên mỗi watt điện; quy tắc vòng đời S3 và lưu log 7 ngày giảm thiểu dung lượng lưu trữ dư thừa. |

#### Thiết kế thành phần
- **Tầng biên & Ứng dụng khách (Edge / Client):** ứng dụng web trang đơn (SPA) viết bằng React 18 + TypeScript (Vite) dùng Leaflet + OpenStreetMap để chọn vị trí. Khách xem chợ công khai; người dùng đã đăng nhập (`Owners`) nhắn tin và mua hàng; đối tác được Admin duyệt truy cập cổng đối tác (Cấp 1 – người bán cá nhân: tối đa 3 tin đang mở; Cấp 2 – đối tác doanh nghiệp có chi nhánh, bảng quy tắc giá và báo giá: tối đa 10 tin đang mở); còn `Admins` và `FinanceAdmins` truy cập cổng Admin.
- **Tiếp nhận ảnh (Photo Ingestion):**
  1. `POST /uploads/presign` trả presigned POST URL hạn 5 phút để trình duyệt tải thẳng lên S3 riêng tư.
  2. `POST /uploads/moderate` chạy Rekognition kiểm duyệt và đọc chữ, sau đó gắn thẻ đạt kiểm duyệt cho ảnh an toàn.
  3. Khi tạo tin đăng, ảnh được gắn thẻ đã đính kèm để lifecycle giữ lại qua mốc 1 ngày cho tới hạn 90 ngày.
- **Xử lý (Processing):** router HTTP kiểm tra JWT claims, idempotency key và dữ liệu đầu vào. Các máy trạng thái (state machine) cho Listing, Quote và Transaction chỉ cho phép chuyển trạng thái hợp lệ. Phân tích AI và ghép chi nhánh chạy bất đồng bộ, còn cấu trúc khóa theo khung thời gian (time-bucketed key) giúp job EventBridge 15 phút tìm tin hết hạn mà không phải quét toàn bảng.
- **Lưu trữ (Storage):** mọi truy vấn tuân theo thiết kế khóa một bảng tập trung, không dùng table scan. Bảng tin chợ chia theo tháng, phân trang bằng con trỏ (cursor) có kiểm tra tính hợp lệ và mọi khoản tiền lưu bằng số nguyên VND.
- **Giao diện web (Web Interface):** bảng tin chợ công khai, chat theo từng tin (cập nhật mỗi 5 giây) có gửi mức giá, bảng thao tác giao dịch (hẹn bàn giao, điều chỉnh giá, xác nhận, khiếu nại) và đánh giá hai chiều.
- **Quản lý người dùng (User Management):** Cognito phụ trách đăng ký xác minh email và phân quyền nhóm. Admin duyệt hồ sơ đối tác; Admin tài chính phát hành và xác nhận thanh toán hóa đơn phí hằng tháng. Hóa đơn quá hạn trên 3 ngày sẽ chặn đăng tin mới; quá hạn 7 ngày sẽ khóa tài khoản cho tới khi thanh toán.
- **Giám sát (Monitoring):** log Lambda dạng JSON có cấu trúc lưu 7 ngày trong CloudWatch Logs, kết nối với alarm báo lỗi Lambda gửi email qua SNS tới Admin.

### 4. Triển khai kỹ thuật
#### Các giai đoạn triển khai
1. **Nghiên cứu & kiến trúc (28/09–08/10/2026 — Đã xong):** chuyển bản đặc tả v1.0 (do Product Owner cung cấp khi khởi động dự án, 1.189 đoạn) thành 45 quyết định nghiệp vụ (QĐ-01 → QĐ-45), thiết kế toàn bộ mẫu truy vấn DynamoDB một bảng và chọn kiến trúc Lambda API tập trung sau HTTP API Gateway.
2. **Ước tính chi phí & tính khả thi (05/10–08/10/2026 — Đã xong, nộp Đề xuất Phần 1 ngày 08/10/2026):**
   - thay nạp/rút ngân hàng trực tuyến bằng thanh toán trực tiếp khi bàn giao;
   - chọn DynamoDB on-demand và Lambda arm64 để nằm trong AWS Free Tier ở tải thấp;
   - tách mọi lời gọi AWS qua các adapter nhỏ để nhóm phát triển và chạy test trên máy cá nhân không tốn phí AWS.
3. **Phát triển & triển khai AWS lần đầu (09/10–23/10/2026 — Đã xong):** xây bảng DynamoDB chính, luồng ảnh S3, đăng nhập Cognito + trigger Post-confirm, web React và mã hạ tầng Terraform. Luồng chợ đầu cuối ban đầu lên AWS ngày 19/10 và smoke test tự động trên AWS đạt ngày 22/10.
4. **Tinh chỉnh kiến trúc (26/10–06/11/2026 — Đã xong):**
   - làm lại giao diện theo thiết kế sản phẩm và bổ sung cổng Admin;
   - chuyển AI sang Kimi K3 kèm Bedrock Guardrail gọi từ `ap-southeast-1` (28/10);
   - chuyển ghép chi nhánh sang xử lý geohash bất đồng bộ chạy nền và hoàn tất 5 đợt QA (khắc phục 146 lỗi/ghi nhận, 03/11);
   - nâng giới hạn thực thi đồng thời của Lambda từ mức khởi điểm 10 của tài khoản mới lên hạn mức vùng tiêu chuẩn mặc định 1.000 của AWS Lambda và gắn AWS WAF lên CloudFront (06/11).
5. **Kiểm chứng, hoàn thiện & bàn giao (09/11–04/12/2026 — Đang thực hiện):**
   - *Đã xong (09/11–21/11):* nộp Đề xuất Phần 2 (13/11), chạy lại load test kiểm chứng throttling API Gateway (20 request/giây, burst 50) không còn lỗi 5xx, chuẩn hóa một luồng triển khai kèm IAM user riêng từng thành viên và hoàn thiện tài liệu Workshop tinh gọn trọn luồng đã kiểm chứng trực tiếp xuyên suốt các mũi tên 1 → 10 trên AWS.
   - *Còn lại (23/11–04/12):* rà soát dọn tài nguyên thừa cuối kỳ, đối chiếu chi phí thực tế với credit còn lại, diễn tập demo trực tiếp và đóng gói tài liệu bàn giao.

#### Yêu cầu kỹ thuật
- **Công nghệ ứng dụng (Application Stack):** Node.js 22, TypeScript 5, React 18 + Vite 5, Leaflet, Cognito client SDK, AWS SDK v3, esbuild, Vitest; Python 3.12 cho Lambda Post-confirm và bộ kiểm chứng trọn luồng.
- **Hạ tầng & CI:** Terraform ≥ 1.10 (AWS provider 6.x) và AWS CLI ≥ 2.32 để tái tạo hạ tầng đồng nhất; GitHub Actions chạy typecheck, 182 test tự động và build web cho mỗi pull request.
- **Phần cứng:** chỉ cần laptop của thành viên; không cần phần cứng hay máy chủ tại chỗ.
- **Kỹ năng:** thiết kế DynamoDB một bảng, IAM quyền tối thiểu, thiết kế prompt và Guardrail trên Bedrock, tinh chỉnh luật WAF trên CloudFront, phát triển React SPA và kiểm thử bằng dịch vụ giả lập (fake).

### 5. Lộ trình & Mốc triển khai

| Tuần | Thời gian | Trạng thái | Kết quả bàn giao |
|---|---|---|---|
| Tuần 1 | 14/09–18/09 | Đã xong | Nền tảng AWS: bảo mật tài khoản, IAM, VPC, EC2; làm quen nhóm |
| Tuần 2 | 21/09–26/09 | Đã xong | Kiến thức serverless (S3, DynamoDB, Lambda, API Gateway); khai mạc Buildrathon, chọn ReLoop (26/09) |
| Tuần 3 | 28/09–02/10 | Đã xong | Rút bản đặc tả v1.0 (do Product Owner cung cấp khi khởi động) thành 45 quyết định nghiệp vụ (QĐ-01 → QĐ-45); lập repo + CI; chia việc nhóm |
| Tuần 4 | 05/10–09/10 | Đã xong | Kiến trúc và mẫu truy vấn DynamoDB; đánh giá tính khả thi chi phí; nộp Đề xuất Phần 1 (08/10); khởi chạy bảng chính, Cognito và web React (09/10) |
| Tuần 5 | 12/10–16/10 | Đã xong | Tải ảnh trực tiếp lên S3, kiểm duyệt Rekognition, bản thử AI phân tích tin đầu tiên |
| Tuần 6 | 19/10–24/10 | Đã xong | Dựng môi trường bằng Terraform; luồng chợ đầu cuối ban đầu chạy trên AWS (19/10); smoke test trọn luồng đạt (22/10); lịch EventBridge 15 phút |
| Tuần 7 | 26/10–30/10 | Đã xong | Giao diện mới (chợ công khai, cổng đối tác, cổng Admin); đọc chữ Rekognition + Bedrock Guardrail; chuyển AI sang Kimi K3 (28/10) |
| Tuần 8 | 02/11–06/11 | Đã xong | Chuyển ghép chi nhánh sang xử lý geohash bất đồng bộ chạy nền; 5 đợt QA (khắc phục 146 lỗi/ghi nhận, 03/11); load test → nâng thực thi đồng thời Lambda từ 10 lên hạn mức vùng tiêu chuẩn 1.000; giới hạn 20 lượt phân tích AI/người/ngày; gắn WAF trên CloudFront (06/11) |
| Tuần 9 | 09/11–13/11 | Đã xong | Rà soát và vá lỗi bảo mật; nộp Đề xuất Phần 2 kèm số liệu chi phí thực tế trên AWS (13/11) |
| Tuần 10 | 16/11–21/11 | Đã xong | Chạy lại load test sau tinh chỉnh throttling (20/giây, burst 50); chuẩn hóa luồng triển khai và IAM user riêng; kiểm chứng Workshop trực tiếp trọn luồng (Mũi tên 1 → 10) |
| Tuần 11 | 23/11–27/11 | Dự kiến | Rà soát tài nguyên cuối kỳ, dọn tài nguyên thừa và đối chiếu chi phí với credit còn lại |
| Tuần 12 | 30/11–04/12 | Dự kiến | Báo cáo thực tập cuối kỳ, demo trực tiếp và tài liệu bàn giao |
| Sau ra mắt | 12/2026–02/2027 | Dự kiến | Vận hành trong hạn credit AWS (đến 28/02/2027); thu thập số liệu thực tế cho AI và thuật toán ghép tin |

### 6. Ước tính ngân sách
Ước tính dựa trên bảng giá công khai của AWS cho **`ap-southeast-1` (Singapore)** (có thể tính lại trên [AWS Pricing Calculator](https://calculator.aws/)). Bảng chi tiết từng dòng nằm tại [reloop-cost-estimate.csv](/files/2-proposal/reloop-cost-estimate.csv).

#### Chi phí hạ tầng
Region: `ap-southeast-1` (Singapore) kèm lớp biên toàn cầu CloudFront. Giả định mức dùng phản ánh số liệu nền của môi trường dev tính đến **08/11/2026** (giai đoạn dev đầu tiên **10/10–08/11/2026** trên Cost Explorer và CloudWatch: ~31.000 request API bao gồm cả kiểm thử tự động QA/smoke/load test, 14 tài khoản đăng ký và 12 tin đang mở); số dư credit AWS ghi nhận tính đến **21/11/2026** (còn **189,80 USD** đến 28/02/2027).

| Dịch vụ | USD / tháng | Giả định |
|---|---:|---|
| AWS WAF – web ACL CloudFront | 10,00 | 1 web ACL (5,00 USD) + 5 luật (5 × 1,00 USD) + 0,60 USD / 1 triệu request |
| Amazon Bedrock (Kimi K3 + Guardrail) | 1,00 | Mức dùng thực tế theo tháng (~0,87 USD), giới hạn 20 lượt/người/ngày |
| Amazon Rekognition | 0,30 | Kiểm duyệt nội dung + đọc chữ cho khoảng 70–100 ảnh/tháng |
| Amazon DynamoDB (on-demand) | 0,10 | Khoảng 5.600 bản ghi, 2,4 MB, bật PITR |
| Amazon API Gateway (HTTP API) | 0,10 | Khoảng 31.000 request/tháng |
| Amazon S3 (web + ảnh) | 0,05 | Bản build web riêng tư + ảnh (lifecycle 1 ngày chưa gắn / 90 ngày) |
| Khác (truyền dữ liệu, mục lẻ) | 0,15 | Dự phòng cho các mục truyền tải và sử dụng nhỏ lẻ |
| AWS Lambda (API + Post-confirm) | 0,00 | ~2.250 GB-s/tháng — Always Free (1 triệu request + 400.000 GB-s) |
| Amazon CloudFront | 0,00 | Always Free (1 TB truyền tải + 10 triệu request/tháng) |
| Amazon Cognito | 0,00 | 14 người dùng — Free Tier tới 10.000 MAU |
| Amazon CloudWatch + SNS + EventBridge | 0,00 | Log 7 ngày, 1 alarm, email cảnh báo SNS, lịch 15 phút — Free Tier |
| **Tổng mỗi tháng** | **11,70** | |
| **Tổng 12 tháng** | **140,40** | |

- **Chi phí phần cứng đầu tư ban đầu:** 0 USD.
- **Credit:** tài khoản đang ở gói AWS Free với **189,80 USD** credit còn lại (tính đến 21/11/2026), hiệu lực đến 28/02/2027. Số này dư sức chi trả cho khoảng 3,2 tháng còn lại (≈ 38 USD ở mức 11,70 USD/tháng) mà không tốn tiền mặt.
- **Tùy chọn tiết kiệm:** tạm gỡ AWS WAF web ACL khỏi CloudFront trong giai đoạn nhàn rỗi (không chạy demo/thử nghiệm) giúp giảm chi phí xuống còn khoảng **1,70 USD/tháng**, đổi lại mất lớp giới hạn tốc độ và bộ luật chặn tấn công ở biên.
- *Giá tham khảo theo bảng giá công khai AWS cho `ap-southeast-1` tháng 11/2026 và có thể thay đổi. Các mục tính theo mức dùng sẽ tăng theo lưu lượng truy cập.*

### 7. Đánh giá rủi ro
#### Ma trận rủi ro

| Rủi ro | Mức ảnh hưởng | Xác suất |
|---|---|---|
| R1. Hai thành viên deploy code xung đột lên cùng một hàm Lambda (đã gặp ngày 28/10/2026) | Cao | Trung bình |
| R2. Hết credit hoặc phát sinh chi phí bất ngờ (tài khoản gói Free sẽ bị đóng khi hết credit hoặc hết hạn 6 tháng, có 90 ngày để nâng cấp mở lại trước khi bị xóa vĩnh viễn) | Cao | Thấp |
| R3. Lambda hoặc API bị throttle khi tải tăng đột biến (load test ban đầu với giới hạn 10 phiên Lambda đồng thời gặp 26% lỗi 5xx với 80 request cùng lúc) | Trung bình | Trung bình |
| R4. AI nhận sai thiết bị hoặc gặp văn bản chèn lệnh độc hại (prompt injection) ẩn trong ảnh | Trung bình | Trung bình |
| R5. Truy cập trái phép hoặc lạm dụng web công khai, API hay kho ảnh riêng tư | Cao | Thấp |
| R6. Người bán và người mua chốt giao dịch ngoài nền tảng để né phí | Trung bình | Cao |
| R7. Giới hạn email mặc định của Cognito (~50 email/ngày) chặn đăng ký giữa buổi demo | Trung bình | Trung bình |

#### Chiến lược giảm thiểu
- **R1:** dùng duy nhất một luồng triển khai từ bản commit đã kiểm duyệt, cấp IAM user riêng cho từng thành viên và không dùng root access key.
- **R2:** đối chiếu mọi dịch vụ có phí với số credit còn lại trước khi bật, áp dụng giới hạn cứng 20 lượt phân tích AI/người/ngày và kiểm tra AWS Billing định kỳ.
- **R3:** đã nâng giới hạn thực thi đồng thời của Lambda từ mức khởi điểm 10 lên hạn mức vùng tiêu chuẩn mặc định 1.000 của AWS Lambda; API Gateway giới hạn lưu lượng HTTP ở 20 request/giây (burst 50) và giới hạn tốc độ WAF trên CloudFront trả mã `429` gọn gàng thay vì lỗi 5xx.
- **R4:** AI chỉ gợi ý và người bán xác nhận từng trường trước khi đăng. Rekognition đọc chữ kết hợp Bedrock Guardrail tự gắn cờ ảnh đáng ngờ để Admin duyệt.
- **R5:** AWS WAF trên CloudFront áp bộ luật do AWS quản lý (AWS Managed Rules) và giới hạn tốc độ; bucket S3 riêng tư dùng OAC và presigned URL; API Gateway (HTTP API) xác thực JWT hợp lệ từ Cognito trên các route riêng tư trong khi hàm Lambda (`reloop-api`) kiểm tra header bí mật `x-origin-verify` từ CloudFront để chặn gọi trực tiếp bỏ qua CloudFront; các IAM role giữ quyền tối thiểu.
- **R6:** áp phí gỡ tin khi tin bị xóa trong vòng 72 giờ sau khi hủy giao dịch, khiếu nại phí do Admin tài chính xử lý và gắn cờ tài khoản tái phạm.
- **R7:** lên kế hoạch chuyển sang dịch vụ gửi email tùy chỉnh trước khi mở đăng ký rộng rãi ngoài phạm vi demo nhỏ.

#### Kế hoạch dự phòng
- **Deploy lỗi:** triển khai lại bản commit ổn định gần nhất bằng Terraform và đồng bộ web tĩnh; luôn xem trước thay đổi bằng `terraform plan`.
- **Chi phí tăng đột biến:** tạm gỡ AWS WAF web ACL khỏi CloudFront và hạ ngay giới hạn phân tích AI mỗi ngày.
- **Bedrock gián đoạn:** bước AI điền sẵn là tùy chọn; người bán vẫn tự điền biểu mẫu và đăng tin bình thường.
- **WAF chặn nhầm người dùng thật:** điều chỉnh luật hoặc ngưỡng tốc độ trực tiếp trên WAF web ACL của CloudFront — có hiệu lực ngay ở lớp biên mà không cần phát hành lại code.
- **Lỗi hoặc mất dữ liệu:** khôi phục bảng DynamoDB bằng Point-in-Time Recovery (lùi tối đa 35 ngày); ảnh thiết bị có thể được người bán tải lại.

### 8. Kết quả kỳ vọng
#### Cải tiến kỹ thuật
- Một nền tảng mua bán serverless hoàn chỉnh, hoạt động thực tế trên AWS: 111 route API, 3 cổng giao diện, 182 test tự động và đã kiểm chứng trực tiếp xuyên suốt cả 10 luồng kiến trúc.
- Hạ tầng có thể tái tạo nhất quán bằng mã (IaC), vận hành khoảng **11,70 USD/tháng** (**1,70 USD/tháng** nếu không bật WAF; riêng hạ tầng lõi gồm tính toán, cơ sở dữ liệu, API và lưu trữ dưới **0,30 USD/tháng** ở lưu lượng hiện tại).
- Nền tảng bảo mật đa lớp rõ ràng: bảo vệ biên bằng CloudFront WAF, lưu trữ S3 riêng tư (OAC + presigned URL), kiểm tra header `x-origin-verify` tại Lambda (`reloop-api`), xác thực JWT Cognito tại API Gateway HTTP API và kiểm duyệt ảnh bằng Rekognition + Amazon Bedrock Guardrails.
- Hiệu năng phản hồi nhanh: thời gian chạy trung bình 144 ms của Lambda API quan sát trên CloudWatch môi trường dev, kèm CloudWatch Logs 7 ngày và cảnh báo lỗi tự động qua email SNS.

#### Giá trị lâu dài
- Lưu gợi ý của AI song song với thông tin người bán đã xác nhận tạo nên bộ dữ liệu có nhãn phục vụ đánh giá và nâng cao độ chính xác nhận diện thiết bị về sau.
- Thiết kế backend theo adapter cho phép thay đổi hoặc bổ sung dịch vụ (như gửi email tùy chỉnh, chat WebSocket hay API thanh toán ngân hàng) mà không phải viết lại nghiệp vụ cốt lõi.
- Cùng bộ module Terraform có thể dựng thêm môi trường production riêng hoặc mở rộng sang thành phố khác, vì thuật toán ghép chi nhánh theo geohash không phụ thuộc khu vực.
- Các tiệm sửa chữa và đơn vị tái chế có thêm kênh thu mua ổn định ngay gần mình, đưa nhiều thiết bị hơn vào tái sử dụng và tái chế chính thức thay vì bỏ không trong nhà.
