---
title : "Frontend SPA, CloudFront & Origin Access"
date : 2026-11-14
weight : 8
chapter : false
pre : " <b> 5.8. </b> "
---

Trong phần này bạn lưu trữ ứng dụng React/Vite SPA trong bucket S3 hoàn toàn riêng tư (`reloop2-web-7k3q`), hợp nhất frontend và `/api/*` dưới cùng một tên miền HTTPS của **Amazon CloudFront** thông qua **Origin Access Control (OAC)**, gắn 2 **CloudFront Functions**, ép buộc các **Security Headers**, chặn truy cập trực tiếp vào API Gateway bằng `x-origin-verify`, và hoàn tất bước **cập nhật ngược (backfill) CORS & Cognito**.

![Phạm vi Phần 5.8: CloudFront, S3 Web, OAC & Định tuyến Edge](/images/5-Workshop/5.8/architecture.png)

---

### Phần A — Tạo Web Bucket riêng tư (`reloop2-web-7k3q`) & Upload mã nguồn Build

1. Vào **S3 -> Create bucket** tại **`ap-southeast-1`**, đặt tên **`reloop2-web-7k3q`**, giữ **Block all public access ON**, gắn tag và bật **SSE-S3 + Bucket Key**.

![Đặt tên bucket reloop2-web-7k3q](/images/5-Workshop/5.8/01-s3-create-bucket-name.png)

![Giữ Block all public access bật](/images/5-Workshop/5.8/02-s3-block-public-access.png)

![Tags và mã hóa bucket web](/images/5-Workshop/5.8/03-s3-tags-create.png)

![Đã tạo reloop2-web-7k3q](/images/5-Workshop/5.8/04-s3-bucket-created.png)

2. Build ứng dụng React (`npm run build`) với biến `VITE_API_BASE=/api`, sau đó upload `index.html` và thư mục `assets/` lên `reloop2-web-7k3q`.

![Chọn file build gốc để tải lên](/images/5-Workshop/5.8/05-s3-upload-files.png)

![Upload file gốc thành công](/images/5-Workshop/5.8/06-s3-upload-succeeded.png)

![Danh sách file ở thư mục gốc bucket](/images/5-Workshop/5.8/07-s3-objects-root.png)

![Tải lên thư mục assets](/images/5-Workshop/5.8/08-s3-upload-assets.png)

![Upload thư mục assets thành công](/images/5-Workshop/5.8/09-s3-assets-succeeded.png)

---

### Phần B — Tạo 2 CloudFront Functions (`cloudfront-js-2.0`)

3. Mở **CloudFront -> Functions -> Create function**:

![Tạo mới CloudFront Function](/images/5-Workshop/5.8/10-cf-create-function.png)

- **Function 1: `reloop2-spa-rewrite`** — viết lại mọi đường dẫn SPA thành `/index.html`, chỉ cho qua các file tĩnh có đuôi thật sự (giúp đường dẫn chat có dấu chấm dạng `<partnerId>.<listingId>` vẫn load đúng React App!):

```javascript
function handler(event) {
  var req = event.request;
  // Only real asset extensions pass; chat route "<partnerId>.<listingId>" also contains a dot
  if (!/\.(js|mjs|css|map|html|png|jpe?g|gif|svg|ico|webp|avif|txt|json|xml|webmanifest|woff2?|ttf)$/i.test(req.uri)) req.uri = '/index.html';
  return req;
}
```

![Code của reloop2-spa-rewrite](/images/5-Workshop/5.8/11-cf-spa-rewrite-code.png)

![Publish reloop2-spa-rewrite sang LIVE](/images/5-Workshop/5.8/12-cf-spa-rewrite-published.png)

- **Function 2: `reloop2-api-prefix`** — cắt tiền tố `/api` trước khi chuyển tiếp yêu cầu sang API Gateway:

```javascript
function handler(event) {
  var req = event.request;
  req.uri = req.uri.replace(/^\/api(?=\/)/, '');
  return req;
}
```

![Code của reloop2-api-prefix](/images/5-Workshop/5.8/13-cf-api-prefix-code.png)

![Publish reloop2-api-prefix sang LIVE](/images/5-Workshop/5.8/14-cf-api-prefix-published.png)

---

### Phần C — Tạo Response Headers Policy & OAC

4. Vào **CloudFront -> Policies -> Response headers -> Create**: đặt tên **`reloop2-security-headers`**, bật `Strict-Transport-Security`, `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy: strict-origin-when-cross-origin`, `frame-ancestors 'none'`, cùng custom header `Content-Security-Policy-Report-Only`.

![Cấu hình các Security Headers chuẩn](/images/5-Workshop/5.8/15-cf-response-headers-security.png)

![Thêm header Content-Security-Policy-Report-Only](/images/5-Workshop/5.8/16-cf-response-headers-custom.png)

![Đã tạo xong reloop2-security-headers](/images/5-Workshop/5.8/17-cf-response-headers-created.png)

5. Vào **CloudFront -> Security -> Origin access -> Create control setting**, tạo OAC tên **`reloop2-web`** (chọn *Sign requests* + S3).

![Tạo OAC reloop2-web](/images/5-Workshop/5.8/18-cf-oac-create.png)

![OAC đã được tạo](/images/5-Workshop/5.8/19-cf-oac-created.png)

---

### Phần D — Tạo Distribution, 2 Origin & 2 Cache Behaviors

6. Vào **CloudFront -> Distributions -> Create distribution**, chọn `PriceClass_200`, S3 origin `reloop2-web-7k3q` qua OAC, Default root object `index.html`, và **bỏ qua WAF tự động** (ta sẽ tạo WAF tùy chỉnh ở Phần **5.9**).

![Bước 1 tạo CloudFront Distribution](/images/5-Workshop/5.8/20-cf-step1-get-started.png)

![Bước 2 chọn S3 Web bucket + OAC](/images/5-Workshop/5.8/21-cf-step2-origin.png)

![Bước 2 cấu hình cache mặc định](/images/5-Workshop/5.8/22-cf-step2-cache.png)

![Bước 3 chọn Do not enable security protections](/images/5-Workshop/5.8/23-cf-step3-no-auto-waf.png)

![Bước 4 kiểm tra và tạo Distribution](/images/5-Workshop/5.8/24-cf-step4-review.png)

![Distribution đã khởi tạo](/images/5-Workshop/5.8/25-cf-distribution-created.png)

7. Kiểm tra **General -> Edit**: xác nhận **Default root object** là `index.html` và bật `HTTP/2 and HTTP/3`.

![Kiểm tra Settings chung của Distribution](/images/5-Workshop/5.8/26-cf-edit-settings.png)

8. Tại tab **Origins**, tạo origin thứ hai **`api`** trỏ tới `<api-id>.execute-api.ap-southeast-1.amazonaws.com` (HTTPS only, TLS 1.2) và chèn custom header **`x-origin-verify`** mang giá trị bí mật trùng khớp với Lambda!

![Tab Origins trước khi thêm API Gateway](/images/5-Workshop/5.8/27-cf-origins-tab.png)

![Kiểm tra S3 OAC Origin](/images/5-Workshop/5.8/28-cf-origin-s3-oac.png)

![Tạo Origin API Gateway](/images/5-Workshop/5.8/29-cf-origin-api-top.png)

![Chèn header x-origin-verify](/images/5-Workshop/5.8/30-cf-origin-api-header.png)

![Cả hai Origin S3 và API đã sẵn sàng](/images/5-Workshop/5.8/31-cf-origins-both.png)

9. Tại tab **Behaviors**:
   - **Default (`*`):** Redirect HTTP to HTTPS, `CachingOptimized`, `reloop2-security-headers`, gắn `reloop2-spa-rewrite`.
   - **Tạo thêm `/api/*`:** Trỏ về origin `api`, HTTPS only, đủ mọi HTTP method, **`CachingDisabled`**, **`AllViewerExceptHostHeader`**, `reloop2-security-headers`, và gắn **`reloop2-api-prefix`**.

![Gắn spa-rewrite cho Default (*) behavior](/images/5-Workshop/5.8/32-cf-behavior-default-fn.png)

![Tạo behavior /api/*](/images/5-Workshop/5.8/33-cf-behavior-api-top.png)

![Gắn CachingDisabled, AllViewerExceptHostHeader và api-prefix](/images/5-Workshop/5.8/34-cf-behavior-api-policies.png)

![Hoàn tất cả 2 Behaviors](/images/5-Workshop/5.8/35-cf-behaviors-both.png)

10. Gắn **Bucket Policy OAC** cho `reloop2-web-7k3q` (cấp quyền `s3:GetObject` và `s3:ListBucket` duy nhất cho `AWS:SourceArn` của CloudFront Distribution vừa tạo).

![Dán Bucket Policy OAC cho reloop2-web-7k3q](/images/5-Workshop/5.8/36-s3-web-bucket-policy.png)

---

### Phần E — Bước Backfill bắt buộc: Cập nhật Domain CloudFront vào Cognito & CORS

Ngay khi có domain `https://<dist-domain>.cloudfront.net`, hãy cập nhật ngay 3 nơi sau:

11. **Cognito (`reloop2-web-client` -> Login pages):** thêm callback & sign-out URL HTTPS của CloudFront.

![Cập nhật callback/logout URL trong Cognito](/images/5-Workshop/5.8/37-cognito-backfill-urls.png)

12. **S3 `reloop2-images-7k3q` CORS:** thêm domain CloudFront vào `AllowedOrigins`.

![Cập nhật CORS trên bucket ảnh S3](/images/5-Workshop/5.8/38-s3-images-backfill-cors.png)

13. **API Gateway CORS:** thêm domain CloudFront vào `Access-Control-Allow-Origin`.

![Cập nhật CORS trên API Gateway](/images/5-Workshop/5.8/39-apigw-backfill-cors.png)

14. Tạo một lệnh **Invalidation (`/*`)** trên CloudFront để làm mới bộ đệm ngay lập tức.

![Tạo lệnh Invalidation /*](/images/5-Workshop/5.8/40-cf-invalidation-create.png)

![Lệnh Invalidation đã hoàn tất](/images/5-Workshop/5.8/41-cf-invalidation-created.png)
