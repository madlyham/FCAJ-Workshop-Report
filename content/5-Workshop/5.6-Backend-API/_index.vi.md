---
title : "Backend Lambda & HTTP API Gateway"
date : 2026-11-14
weight : 6
chapter : false
pre : " <b> 5.6. </b> "
---

Trong phần này bạn xây dựng tầng xử lý chính cho toàn ứng dụng:
- IAM Role tối thiểu quyền **`reloop2-api-lambda-role`**
- Hàm **Lambda Node.js 22 (ARM64) `reloop2-api`** (`512 MB`, timeout `180 giây`)
- **HTTP API Gateway (`reloop2-api`)** tích hợp **JWT Authorizer** trỏ về Cognito, 7 route rõ ràng, CORS và giới hạn lưu lượng **20 req/s (burst 50)** trên stage `$default`
- Trigger Cognito **Pre-SignUp** gọi về `reloop2-api` để chặn đăng ký trùng email

![Phạm vi Phần 5.6: HTTP API Gateway, API Lambda, Cognito & S3](/images/5-Workshop/5.6/architecture.png)

---

### Phần A — Tạo IAM Role tối thiểu quyền (`reloop2-api-lambda-role`)

1. Vào **IAM -> Roles -> Create role**, chọn Trusted entity **AWS service -> Lambda**.

![Chọn Lambda làm Trusted entity](/images/5-Workshop/5.6/01-role-trusted-entity.png)

2. Gắn **`AWSLambdaBasicExecutionRole`** (kèm Permissions Boundary nếu tài khoản nhóm yêu cầu).

![Permissions boundary nếu có](/images/5-Workshop/5.6/02-role-permissions-boundary.png)

3. Đặt tên **`reloop2-api-lambda-role`**, gắn tags và bấm **Create role**.

![Xem lại tên và tags của reloop2-api-lambda-role](/images/5-Workshop/5.6/03-role-name-review.png)

![Đã tạo xong reloop2-api-lambda-role](/images/5-Workshop/5.6/04-role-created.png)

4. Mở `reloop2-api-lambda-role` -> **Add permissions -> Create inline policy** (`reloop2-api-access`) với phạm vi ARN chính xác cho DynamoDB, S3 `listings/*`, Bedrock (`InvokeModel` + `ApplyGuardrail`), Rekognition, tự gọi chính mình (`SelfInvoke`), Cognito `ListUsers` và Logs:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CoreTable",
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:ConditionCheckItem"
      ],
      "Resource": [
        "arn:aws:dynamodb:ap-southeast-1:123456789012:table/reloop2-core-table",
        "arn:aws:dynamodb:ap-southeast-1:123456789012:table/reloop2-core-table/index/*"
      ]
    },
    {
      "Sid": "ListingImages",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:PutObjectTagging",
        "s3:GetObjectTagging",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::reloop2-images-7k3q/listings/*"
    },
    {
      "Sid": "Bedrock",
      "Effect": "Allow",
      "Action": ["bedrock:InvokeModel"],
      "Resource": [
        "arn:aws:bedrock:*:123456789012:inference-profile/global.moonshotai.kimi-k3",
        "arn:aws:bedrock:*::foundation-model/*"
      ]
    },
    {
      "Sid": "Guardrail",
      "Effect": "Allow",
      "Action": ["bedrock:ApplyGuardrail"],
      "Resource": [
        "arn:aws:bedrock:ap-southeast-1:123456789012:guardrail/*",
        "arn:aws:bedrock:*:123456789012:guardrail-profile/*"
      ]
    },
    {
      "Sid": "Moderation",
      "Effect": "Allow",
      "Action": ["rekognition:DetectModerationLabels", "rekognition:DetectText"],
      "Resource": "*"
    },
    {
      "Sid": "SelfInvoke",
      "Effect": "Allow",
      "Action": ["lambda:InvokeFunction"],
      "Resource": "arn:aws:lambda:ap-southeast-1:123456789012:function:reloop2-api"
    },
    {
      "Sid": "CognitoAliasCheck",
      "Effect": "Allow",
      "Action": ["cognito-idp:ListUsers"],
      "Resource": "arn:aws:cognito-idp:ap-southeast-1:123456789012:userpool/ap-southeast-1_xxxxxxxxx"
    },
    {
      "Sid": "Logs",
      "Effect": "Allow",
      "Action": ["logs:CreateLogStream", "logs:PutLogEvents"],
      "Resource": "arn:aws:logs:ap-southeast-1:123456789012:log-group:/aws/lambda/reloop2-api:*"
    }
  ]
}
```

![Nhập inline policy JSON](/images/5-Workshop/5.6/05-inline-policy-json.png)

![Đặt tên reloop2-api-access và tạo policy](/images/5-Workshop/5.6/06-inline-policy-review.png)

![Quyền hoàn chỉnh của reloop2-api-lambda-role](/images/5-Workshop/5.6/07-role-permissions-final.png)

---

### Phần B — Tạo Lambda Backend (`reloop2-api`)

5. Vào **AWS Lambda -> Create function**:
   - **Function name:** `reloop2-api`
   - **Runtime:** `Node.js 22.x`, **Architecture:** **`arm64`** (tối ưu hiệu năng/chi phí hơn x86_64)
   - **Execution role:** `reloop2-api-lambda-role`

![Chọn custom role reloop2-api-lambda-role](/images/5-Workshop/5.6/08-lambda-custom-role.png)

![Gắn tags cho Lambda](/images/5-Workshop/5.6/09-lambda-tags.png)

![Biểu mẫu tạo hàm reloop2-api](/images/5-Workshop/5.6/10-lambda-create-form.png)

![Tạo xong hàm Lambda reloop2-api](/images/5-Workshop/5.6/11-lambda-created.png)

6. Tải lên gói zip backend `reloop2-api.zip` (`index.js` + `index.js.map`).

![Tải lên zip mã nguồn API](/images/5-Workshop/5.6/12-lambda-upload-zip.png)

![Đã cập nhật gói mã nguồn](/images/5-Workshop/5.6/13-lambda-code-uploaded.png)

7. Vào **Configuration -> General configuration -> Edit**: đặt **Memory `512 MB`**, **Timeout `3 min 0 sec` (`180s`)**.

![Chỉnh bộ nhớ 512 MB và timeout 3 phút](/images/5-Workshop/5.6/14-lambda-basic-settings.png)

![Cấu hình chung đã lưu](/images/5-Workshop/5.6/15-lambda-general-config.png)

8. Vào **Configuration -> Environment variables -> Edit** và điền đủ các biến môi trường:

| Biến | Giá trị / Ý nghĩa |
| --- | --- |
| `STAGE` | `aws` |
| `AUTH_MODE` | `cognito` |
| `TABLE_NAME` | `reloop2-core-table` |
| `IMAGE_BUCKET` | `reloop2-images-7k3q` |
| `COGNITO_CLIENT_ID` | `<Client ID của reloop2-web-client>` |
| `AI_MODEL_ID` | `global.moonshotai.kimi-k3` |
| `ORIGIN_VERIFY_SECRET` | `<chuỗi bí mật ngẫu nhiên 32 byte>` (dùng chung với CloudFront ở Phần 5.8) |
| `NODE_OPTIONS` | `--enable-source-maps` |

{{% notice warning %}}
Tuyệt đối bảo mật **`ORIGIN_VERIFY_SECRET`**, không đưa vào frontend hay Git. Backend kiểm tra header `x-origin-verify` bằng `crypto.timingSafeEqual` để chặn mọi truy cập đi vòng qua CloudFront gọi thẳng vào API Gateway.
{{% /notice %}}

![Nhập danh sách biến môi trường](/images/5-Workshop/5.6/16-lambda-env-vars.png)

![Đã lưu biến môi trường](/images/5-Workshop/5.6/17-lambda-env-vars-saved.png)

![Xác nhận STAGE=aws và các biến chính](/images/5-Workshop/5.6/37-lambda-env-stage.png)

---

### Phần C — Tạo HTTP API Gateway (`reloop2-api`)

9. Vào **API Gateway -> Create API -> HTTP API -> Build**, đặt tên **`reloop2-api`** và chọn integration tới Lambda `reloop2-api`.

![Chọn tạo HTTP API](/images/5-Workshop/5.6/18-apigw-choose-http.png)

![Chọn tích hợp Lambda reloop2-api](/images/5-Workshop/5.6/19-apigw-integration.png)

10. Tạo đầy đủ **7 routes** (6 route công khai/auth/preflight và route tổng `ANY /{proxy+}` có bảo vệ JWT):

| Method | Route Path | Xác thực |
| --- | --- | --- |
| `POST` | `/auth/session` | None |
| `POST` | `/auth/logout` | None |
| `POST` | `/auth/refresh` | None |
| `GET` | `/feed/public` | None |
| `GET` | `/fees` | None |
| `OPTIONS` | `/{proxy+}` | None (CORS preflight) |
| `ANY` | `/{proxy+}` | **JWT Authorizer (`cognito`)** |

![Khai báo 7 route trên HTTP API](/images/5-Workshop/5.6/20-apigw-routes.png)

11. Giữ stage `$default` ở chế độ **Auto-deploy**, xem lại và bấm **Create**.

![Cấu hình stage $default](/images/5-Workshop/5.6/21-apigw-stage-default.png)

![Xem lại cấu hình HTTP API](/images/5-Workshop/5.6/22-apigw-review.png)

![HTTP API reloop2-api đã tạo](/images/5-Workshop/5.6/23-apigw-created.png)

12. Vào **Authorization -> Create JWT authorizer**:
    - **Name:** `cognito`
    - **Identity source:** `$request.header.Authorization`
    - **Issuer URL:** `https://cognito-idp.ap-southeast-1.amazonaws.com/<User-Pool-ID>`
    - **Audience:** `<Client ID của reloop2-web-client>`
    Rồi gắn `cognito` cho đúng route **`ANY /{proxy+}`**.

![Route ANY /{proxy+} trước khi gắn JWT authorizer](/images/5-Workshop/5.6/24-auth-route-no-authorizer.png)

![Tạo JWT authorizer Cognito](/images/5-Workshop/5.6/25-jwt-authorizer-form.png)

![Đã gắn JWT authorizer vào ANY /{proxy+}](/images/5-Workshop/5.6/26-jwt-authorizer-attached.png)

13. Vào **Develop -> CORS -> Configure**, thêm `http://localhost:5173`, Allowed headers `authorization, content-type, idempotency-key`, Allowed methods `*`, Max age `3600` (Phần **5.8** sẽ thêm domain CloudFront).

![Màn hình CORS ban đầu](/images/5-Workshop/5.6/27-cors-empty.png)

![Điền thông số CORS cho API Gateway](/images/5-Workshop/5.6/28-cors-form.png)

![Đã lưu cấu hình CORS](/images/5-Workshop/5.6/29-cors-saved.png)

14. Vào **Deploy -> Stages -> `$default` -> Throttling -> Edit**: đặt **Rate limit `20` req/s**, **Burst limit `50`**.

![Thông số throttling trước khi sửa](/images/5-Workshop/5.6/30-throttling-before.png)

![Đặt Rate limit 20 và Burst 50](/images/5-Workshop/5.6/31-throttling-form.png)

![Đã lưu giới hạn lưu lượng](/images/5-Workshop/5.6/32-throttling-saved.png)

15. Kiểm tra **Integrations** trên API Gateway và **Resource-based policy** trên Lambda để đảm bảo API Gateway có đủ quyền gọi Lambda theo từng route.

![Chi tiết Integration trên API Gateway](/images/5-Workshop/5.6/33-integration-details.png)

![Resource-based policy tự sinh trên Lambda](/images/5-Workshop/5.6/34-lambda-resource-policy.png)

---

### Phần D — Gắn Pre-SignUp Trigger trong Cognito

16. Quay lại Cognito **`reloop2-user-pool` -> Extensions -> Lambda triggers -> Add Lambda trigger**, chọn **Pre sign-up trigger -> `reloop2-api`** để kiểm tra chống trùng lặp email trước khi tạo tài khoản.

![Chọn Pre sign-up trigger cho reloop2-api](/images/5-Workshop/5.6/35-presignup-trigger-form.png)

![Cả 2 trigger Pre sign-up và Post confirmation hoạt động](/images/5-Workshop/5.6/36-presignup-trigger-added.png)
