---
title : "Dọn dẹp Tài nguyên & Terraform IaC"
date : 2026-11-14
weight : 13
chapter : false
pre : " <b> 5.13. </b> "
---

Vì **AWS WAFv2 tính phí duy trì theo giờ/tháng** ngay cả khi không có lưu lượng, hãy xóa toàn bộ tài nguyên thử nghiệm `reloop2-*` theo đúng **thứ tự phụ thuộc ngược** ngay sau khi hoàn thành kiểm thử Phần 5.12. Nếu dùng chung tài khoản với môi trường khác, luôn kiểm tra đúng tiền tố `reloop2` trước khi xác nhận xóa.

---

### Phần A — Thứ tự Xóa chuẩn trên AWS Console

1. **Disable & Xóa CloudFront Distribution (`Global`):** chọn Distribution -> **Disable**, đợi trạng thái chuyển `Disabled` -> bấm **Delete**. Việc xóa Distribution trước giúp giải phóng ràng buộc tới Edge WAF, OAC, CloudFront Functions và Response Headers Policy.

![Disable CloudFront Distribution trước khi xóa](/images/5-Workshop/5.13/01-cf-disable.png)

![Xóa CloudFront Distribution khi đã Disabled](/images/5-Workshop/5.13/08-delete-cf-waf.png)

2. **Xóa EventBridge Scheduled Rule (`reloop2-sweep`, `ap-southeast-1`)**.

![Xóa rule reloop2-sweep](/images/5-Workshop/5.13/02-delete-eventbridge.png)

3. **Xóa CloudWatch Alarms (`reloop2-*`), Dashboard `ReLoop2-Backend-Health` & SNS Topic (`reloop2-alarms`)**.

![Xóa 2 CloudWatch Metric Alarms](/images/5-Workshop/5.13/03-delete-monitoring.png)

4. **Xóa Regional WAF (`reloop2-auth`, `ap-southeast-1`)**: gỡ liên kết với User Pool rồi bấm Delete.

![Xóa Regional WAF reloop2-auth](/images/5-Workshop/5.13/04-delete-waf-auth.png)

5. **Xóa HTTP API Gateway (`reloop2-api`, `ap-southeast-1`)**.

![Xóa HTTP API reloop2-api](/images/5-Workshop/5.13/05-delete-apigw.png)

6. **Xóa Amazon Bedrock Guardrail (`reloop2-ai-guardrail`)**.

![Xóa Bedrock Guardrail reloop2-ai-guardrail](/images/5-Workshop/5.13/06-delete-guardrail.png)

7. **Xóa Cognito Domain (`reloop2-auth`) & User Pool (`reloop2-user-pool`):** xóa domain prefix trước, sau đó tích **Deactivate deletion protection** và gõ tên `reloop2-user-pool` để xóa.

![Tắt Deletion Protection và xóa User Pool](/images/5-Workshop/5.13/07-delete-cognito.png)

8. **Xóa tài nguyên phụ thuộc CloudFront (`Global / us-east-1`):** khi Distribution đã xóa xong, lần lượt xóa **Global WAF `reloop2-web`**, **Response Headers Policy `reloop2-security-headers`**, **OAC `reloop2-web`**, và hai **CloudFront Functions (`reloop2-api-prefix`, `reloop2-spa-rewrite`)**.

![Xóa Edge WAF reloop2-web](/images/5-Workshop/5.13/08b-delete-waf-web.png)

![Xóa Response Headers Policy reloop2-security-headers](/images/5-Workshop/5.13/08c-delete-cf-rhp.png)

![Xóa CloudFront Function reloop2-spa-rewrite](/images/5-Workshop/5.13/08d-delete-cf-functions.png)

9. **Làm rỗng (Empty) & Xóa cả 2 bucket S3 (`reloop2-web-7k3q`, `reloop2-images-7k3q`):** luôn bấm **Empty** (gõ `permanently delete`) để dọn sạch mọi phiên bản object trước khi bấm **Delete bucket**.

![Empty bucket S3 trước khi xóa](/images/5-Workshop/5.13/09a-empty-s3.png)

![Xóa bucket S3 đã rỗng](/images/5-Workshop/5.13/09-delete-s3.png)

10. **Xóa cả 2 hàm Lambda (`reloop2-api`, `reloop2-post-confirmation`) & Log Groups (`/aws/lambda/reloop2-*`):** lưu ý xóa Lambda không tự động xóa Log Group, nên hãy vào CloudWatch Logs xóa thủ công cả hai Log Group.

![Xóa hai hàm Lambda reloop2](/images/5-Workshop/5.13/10-delete-lambda.png)

![Xóa thủ công CloudWatch Log Groups của hai Lambda](/images/5-Workshop/5.13/10b-delete-logs.png)

11. **Xóa bảng DynamoDB (`reloop2-core-table`):** bỏ tích chọn tạo bản sao lưu trước khi xóa để không phát sinh phí lưu trữ backup.

![Xóa bảng DynamoDB không giữ lại backup](/images/5-Workshop/5.13/11-delete-ddb.png)

12. **Xóa 2 IAM Roles (`reloop2-api-lambda-role`, `reloop2-post-confirmation-role`) & AWS Budget (`reloop2-budget`)**.

![Xóa cả 2 IAM Roles của Lambda](/images/5-Workshop/5.13/12-delete-iam.png)

![Xóa reloop2-budget trong AWS Budgets](/images/5-Workshop/5.13/12b-delete-budget.png)

---

### Phần B — Kiểm chứng Sạch 100% qua AWS CLI

Chạy nhanh bộ lệnh sau để chắc chắn không còn sót bất kỳ tài nguyên `reloop2-*` nào ở cả `ap-southeast-1` lẫn `us-east-1`:

```bash
aws s3api list-buckets --query "Buckets[?contains(Name,'reloop2')].Name"
aws dynamodb list-tables --region ap-southeast-1 --query "TableNames[?contains(@,'reloop2')]"
aws lambda list-functions --region ap-southeast-1 --query "Functions[?contains(FunctionName,'reloop2')].FunctionName"
aws logs describe-log-groups --region ap-southeast-1 --query "logGroups[?contains(logGroupName,'reloop2')].logGroupName"
aws apigatewayv2 get-apis --region ap-southeast-1 --query "Items[?contains(Name,'reloop2')].Name"
aws cognito-idp list-user-pools --max-results 60 --region ap-southeast-1 --query "UserPools[?contains(Name,'reloop2')].Name"
aws wafv2 list-web-acls --scope CLOUDFRONT --region us-east-1 --query "WebACLs[?contains(Name,'reloop2')].Name"
aws wafv2 list-web-acls --scope REGIONAL --region ap-southeast-1 --query "WebACLs[?contains(Name,'reloop2')].Name"
aws cloudfront list-distributions --query "DistributionList.Items[?contains(Comment || '','reloop2')].Id"
aws iam list-roles --query "Roles[?contains(RoleName,'reloop2')].RoleName"
```

---

### Phần C — Tự động hóa toàn bộ bằng Terraform (`terraform/`)

Khi đã nắm chắc kiến trúc qua Console, bạn có thể dựng lại hoặc hủy bỏ toàn hệ thống chỉ trong vài phút bằng bộ mã **Terraform (>= 1.6.0, provider `hashicorp/aws >= 5.90`)** nằm trong thư mục `terraform/` của repo (đã kiểm chứng import khớp **`71 / 71`** tài nguyên thực tế với **`0 to destroy`**):

| Tệp Terraform | Tài nguyên quản lý |
| --- | --- |
| `provider.tf`, `data.tf`, `variables.tf` | Region `ap-southeast-1` & alias `us_east_1`, managed cache/origin policies và biến đầu vào bảo mật |
| `storage.tf` | DynamoDB (`PK`/`SK`, `GSI1`, PITR, TTL), hai bucket S3 riêng tư, CORS, 3 lifecycle rules, OAC bucket policy |
| `identity.tf` | Cognito User Pool, 4 groups, Managed Login v2 domain, App Client PKCE, `post_confirmation` IAM role & Python Lambda |
| `api.tf` | IAM role & policy cho API Lambda, Node.js 22 `arm64`, HTTP API Gateway, JWT authorizer, 7 routes, throttling |
| `ai.tf` | Bedrock Guardrail (`reloop2-ai-guardrail`, APAC cross-region profile, Standard tier) + Version `1` |
| `frontend.tf`, `functions/*.js` | OAC, 2 CloudFront Functions (`spa-rewrite.js`, `api-prefix.js`), `security-headers` RHP, Distribution 2 Origin |
| `security.tf` | Edge WAF (`reloop2-web`, `us-east-1`) + Regional Cognito WAF (`reloop2-auth`, `ap-southeast-1`) |
| `events.tf`, `monitoring.tf`, `outputs.tf` | EventBridge 15p, Log retention + metric filter, SNS email, 2 Alarms, Dashboard, AWS Budget `$5` |

#### Lưu ý kỹ thuật thực tế khi chạy Terraform

1. **Tránh vòng lặp (dependency cycle) giữa CloudFront và CORS:** CloudFront cần biết API endpoint và S3 web bucket, trong khi API Gateway CORS cần domain CloudFront. Lần `apply` đầu giữ `cloudfront_cors_origins = []`, lấy `cloudfront_domain` từ output rồi cập nhật `cloudfront_cors_origins = ["https://<domain>"]` và chạy `terraform apply` lần thứ hai (đúng như thao tác backfill ở Phần 5.8).
2. **SNS Email `PendingConfirmation`:** AWS chưa cấp ARN thực cho subscription email tới khi chủ hòm thư bấm xác nhận liên kết trong mail.
3. **Không đưa bí mật & state lên Git:** Tạo `terraform.tfvars` từ `terraform.tfvars.example`; tệp `.gitignore` đã chặn sẵn `terraform.tfvars`, `terraform.tfstate*`, `.terraform/` và tệp `.zip`.

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Điền alert_email, origin_verify_secret và đường dẫn file zip Lambda
terraform init
terraform plan
terraform apply
# Cập nhật cloudfront_cors_origins bằng domain vừa tạo và chạy lại:
terraform apply
# Hủy toàn bộ hạ tầng khi xong bài:
terraform destroy
```
