---
title : "Bảo vệ Edge & Cognito với AWS WAFv2"
date : 2026-11-14
weight : 9
chapter : false
pre : " <b> 5.9. </b> "
---

Trong phần này bạn triển khai 2 tường lửa **AWS WAFv2** bảo vệ hai mặt trận khác nhau:
1. **Edge Web ACL (`reloop2-web`)** tại **Global (`us-east-1`)** gắn lên CloudFront — chặn DDoS/spam bằng rate-limit phân tầng và bộ quy tắc IP/Payload của AWS.
2. **Regional Web ACL (`reloop2-auth`)** tại **Singapore (`ap-southeast-1`)** gắn trực tiếp lên **Cognito User Pool** — giới hạn tốc độ brute-force đăng nhập / spam đăng ký tối đa `300 lượt / 5 phút / IP`.

![Phạm vi Phần 5.9: WAF Edge CloudFront & WAF Regional Cognito](/images/5-Workshop/5.9/architecture.png)

---

### Phần A — Tạo Edge Web ACL (`reloop2-web` tại Global / `us-east-1`)

{{% notice warning %}}
Bắt buộc chuyển phạm vi trên AWS WAF về **Global (CloudFront)** (`us-east-1`) để tạo WAF cho CloudFront.
{{% /notice %}}

1. Mở **AWS WAF -> Web ACLs**, chọn **Global (CloudFront)**, bấm **Create web ACL**.

![Danh sách Web ACL tại Global CloudFront](/images/5-Workshop/5.9/01-waf-list-cloudfront.png)

2. Đặt tên **`reloop2-web`**, mô tả `ReLoop 2: IP rate limits, bad IPs, common attack patterns - CloudFront`, và gắn tài nguyên là **CloudFront distribution** của bạn.

![Gắn CloudFront vào reloop2-web](/images/5-Workshop/5.9/02-waf-web-associate-cloudfront.png)

![Thông tin Bước 1 của reloop2-web](/images/5-Workshop/5.9/03-waf-web-step1.png)

3. Thêm **5 quy tắc** theo thứ tự ưu tiên `0..4`:
   - **Priority 0 — `rate-limit-public-api`:** Giới hạn **`100` request / `60` giây / IP** cho các URI bắt đầu bằng `/api/auth/`, `/api/feed/public` hoặc `/api/fees`. Trả về mã **`429`** JSON + header `retry-after: 60`.

![Cấu hình giới hạn public API 100 req/phút](/images/5-Workshop/5.9/04-waf-rule-rate-limit-public-top.png)

![Điều kiện URI và phản hồi 429 JSON](/images/5-Workshop/5.9/05-waf-rule-rate-limit-public-bottom.png)

   - **Priority 1 — `rate-limit-per-ip`:** Trần tổng toàn site **`1000` request / `60` giây / IP**.

![Giới hạn tổng 1000 req/phút mỗi IP](/images/5-Workshop/5.9/06-waf-rule-rate-limit-per-ip.png)

   - **Priority 2, 3, 4 — AWS Managed Rules (Miễn phí):** `AmazonIpReputationList`, `KnownBadInputsRuleSet`, và `CommonRuleSet` (đặt **Override `Count`** cho `SizeRestrictions_BODY` và `GenericRFI_BODY` để tránh chặn nhầm JSON tin đăng có mô tả dài hoặc URL bản đồ).

![Chọn 3 bộ quy tắc quản lý miễn phí của AWS](/images/5-Workshop/5.9/07-waf-free-managed-rules.png)

![Override SizeRestrictions_BODY và GenericRFI_BODY sang Count](/images/5-Workshop/5.9/08-waf-crs-overrides.png)

4. Kiểm tra đủ 5 rules, thứ tự priority, bật CloudWatch metrics & sampled requests, rồi bấm **Create web ACL**.

![Danh sách 5 rule đã thêm](/images/5-Workshop/5.9/09-waf-web-step2-rules.png)

![Kiểm tra thứ tự ưu tiên Priority](/images/5-Workshop/5.9/10-waf-web-priority.png)

![Bật CloudWatch Metrics cho từng rule](/images/5-Workshop/5.9/11-waf-web-metrics.png)

![Xem lại toàn bộ cấu hình trước khi tạo](/images/5-Workshop/5.9/12-waf-web-review.png)

![reloop2-web đã tạo thành công](/images/5-Workshop/5.9/13-waf-web-created.png)

![Xác nhận CloudFront xuất hiện ở tab Associated resources](/images/5-Workshop/5.9/14-waf-web-associated.png)

---

### Phần B — Tạo Regional Auth Web ACL (`reloop2-auth` tại `ap-southeast-1`)

5. Chuyển vùng sang **Asia Pacific (Singapore) `ap-southeast-1`** -> **Create web ACL**.

![Danh sách Web ACL tại Singapore](/images/5-Workshop/5.9/15-waf-list-singapore.png)

6. Đặt tên **`reloop2-auth`** và gắn trực tiếp vào **Cognito User Pool `reloop2-user-pool`**.

![Chọn tài nguyên Cognito User Pool](/images/5-Workshop/5.9/16-waf-auth-associate-cognito.png)

![Tóm tắt Bước 1 reloop2-auth](/images/5-Workshop/5.9/17-waf-auth-step1.png)

7. Thêm **2 rules**: **`rate-limit-auth`** (`300` request / `300` giây / IP lọc theo header `x-amzn-cognito-operation-name` khớp 7 hành động auth) và **`AWSManagedRulesAmazonIpReputationList`**.

![Soạn JSON rule rate-limit-auth](/images/5-Workshop/5.9/18-waf-auth-rule-rate-limit-json.png)

![Hai rule trong reloop2-auth](/images/5-Workshop/5.9/19-waf-auth-step2-rules.png)

8. Rà soát và tạo **`reloop2-auth`**, kiểm tra User Pool đã được bảo vệ.

![Xem lại cấu hình reloop2-auth](/images/5-Workshop/5.9/20-waf-auth-review.png)

![reloop2-auth đã được tạo](/images/5-Workshop/5.9/21-waf-auth-created.png)

![Xác nhận liên kết bảo vệ Cognito User Pool](/images/5-Workshop/5.9/22-waf-auth-associated.png)
