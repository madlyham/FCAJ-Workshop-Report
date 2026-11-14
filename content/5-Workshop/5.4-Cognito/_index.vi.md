---
title : "Xác thực Cognito & Đồng bộ Hồ sơ"
date : 2026-11-14
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

Trong phần này bạn tạo **Amazon Cognito User Pool (`reloop2-user-pool`)**, cấu hình 4 nhóm phân quyền RBAC (`Admins`, `FinanceAdmins`, `Partners`, `Owners`), thiết lập domain Managed Login v2 (`reloop2-auth`) và tạo **Lambda Post-Confirmation (`reloop2-post-confirmation`, Python 3.12)** để tự động ghi hồ sơ người dùng mới vào DynamoDB ngay sau khi xác nhận email.

![Phạm vi Phần 5.4: Cognito, Lambda Post-Confirmation & DynamoDB](/images/5-Workshop/5.4/architecture.png)

---

### Phần A — Tạo User Pool & Cấu hình Đăng nhập

1. Mở **Amazon Cognito -> User pools** tại **`ap-southeast-1`**, bấm **Create user pool**.

![Trang Cognito User pools](/images/5-Workshop/5.4/01-cognito-pools.png)

2. Trong bước **Set up your application**:
   - Chọn **Single-page application (SPA)**
   - Đặt tên App client là `reloop2-web-client`
   - Chọn **Email** làm định danh đăng nhập, yêu cầu các thuộc tính `email` và `name` khi đăng ký, sau đó bấm **Create user directory**.

![Cấu hình ứng dụng SPA và đăng nhập bằng Email](/images/5-Workshop/5.4/02-setup-app.png)

3. Khi pool khởi tạo xong, kiểm tra User Pool ID và bấm **Go to overview**.

![Khởi tạo User Pool hoàn tất](/images/5-Workshop/5.4/03-pool-created.png)

4. Ở trang **Overview**, bấm **Rename**, đổi tên thành `reloop2-user-pool` và lưu lại.

![Đổi tên User Pool thành reloop2-user-pool](/images/5-Workshop/5.4/04-rename-pool.png)

![Tổng quan reloop2-user-pool](/images/5-Workshop/5.4/05-pool-overview.png)

5. Kiểm tra **Authentication -> Authentication methods**: bật **Password**, tắt MFA (**No MFA**) để luồng thử nghiệm gọn nhẹ (khi chạy thực tế có thể bật TOTP/SMS).

![Phương thức xác thực mật khẩu](/images/5-Workshop/5.4/06-auth-methods-password.png)

6. Tại **Authentication -> Sign-in**: xác nhận đăng nhập bằng **Email** và không phân biệt hoa/thường.

![Cấu hình Sign-in](/images/5-Workshop/5.4/07-sign-in.png)

7. Tại **Sign-up**: xác nhận cho phép tự đăng ký, tự động xác minh qua email và bật **Account recovery** bằng **Email (`verified_email`, ưu tiên 1)**.

![Cài đặt khôi phục tài khoản qua Email](/images/5-Workshop/5.4/08-account-recovery.png)

![Cài đặt mẫu tin nhắn xác nhận email](/images/5-Workshop/5.4/09-verification-message.png)

8. Gắn tags chuẩn workshop (`Owner=team`, `Project=reloop2`, `Purpose=workshop`) và xác nhận **Deletion protection** đang **Active** (ta sẽ chủ động tắt ở Phần 5.13 khi dọn dẹp).

![Gắn tags cho User Pool](/images/5-Workshop/5.4/10-pool-tags.png)

![Deletion protection đang bật](/images/5-Workshop/5.4/11-deletion-protection.png)

---

### Phần B — Tạo các Nhóm phân quyền (Groups)

9. Vào **User management -> Groups**, tạo đủ **4 nhóm**:

| Tên nhóm | Precedence | Mô tả |
| --- | --- | --- |
| `Admins` | `1` | Quản trị viên vận hành & duyệt hồ sơ |
| `FinanceAdmins` | `1` | Quản trị tài chính (duyệt STK, lệnh rút) |
| `Partners` | `2` | Cửa hàng sửa chữa & thu mua đã xác minh |
| `Owners` | `3` | Chủ thiết bị đăng tin bán/tái chế |

![Tạo nhóm Admins](/images/5-Workshop/5.4/12-create-group-admins.png)

![Danh sách 4 nhóm RBAC](/images/5-Workshop/5.4/13-groups-list.png)

---

### Phần C — Cấu hình App Client & Domain Managed Login

10. Mở **Applications -> App clients -> `reloop2-web-client`**: kiểm tra **Authentication flows** có **`ALLOW_USER_SRP_AUTH`** và **`ALLOW_REFRESH_TOKEN_AUTH`**, thời hạn Access/ID Token là **60 phút**, Refresh Token là **5 ngày**, bật **Prevent user existence errors**.

![Thông tin App client reloop2-web-client](/images/5-Workshop/5.4/14-app-client.png)

![Cấu hình Auth flows và thời hạn token](/images/5-Workshop/5.4/15-app-client-auth-flows.png)

11. Vào tab **Login pages** -> bấm **Edit**:
    - Tạm đặt **Allowed callback URLs:** `http://localhost:5173/auth/callback`
    - Tạm đặt **Allowed sign-out URLs:** `http://localhost:5173/` (ở Phần **5.8** ta sẽ bổ sung URL CloudFront!)
    - OAuth 2.0 grant types: **Authorization code grant** (`code`)
    - Scopes: `openid`, `email`, `phone`

![Trang Login pages trước khi chỉnh sửa](/images/5-Workshop/5.4/16-login-pages-before.png)

![Điền callback URL và sign-out URL](/images/5-Workshop/5.4/17-login-pages-signout.png)

![Đã lưu cài đặt Login pages](/images/5-Workshop/5.4/18-login-pages-after.png)

12. Vào **Branding -> Domain**, thay domain mặc định bằng prefix **`reloop2-auth`** với **Managed login version `2`**.

![Domain tự sinh ban đầu](/images/5-Workshop/5.4/19-domain-auto.png)

![Tạo domain prefix reloop2-auth](/images/5-Workshop/5.4/20-domain-create.png)

![Domain reloop2-auth đã sẵn sàng](/images/5-Workshop/5.4/21-domain-reloop2-auth.png)

---

### Phần D — Tạo IAM Role & Lambda Post-Confirmation (Python 3.12)

Ngay khi người dùng xác nhận mã OTP email, Cognito gọi đồng bộ Lambda `reloop2-post-confirmation` để ghi bản ghi hồ sơ `Owner` vào `reloop2-core-table`.

13. Vào **IAM -> Roles -> Create role**, chọn Trusted entity là **AWS service -> Lambda**.

![Chọn dịch vụ Lambda làm Trusted entity](/images/5-Workshop/5.4/22-role-trusted-lambda.png)

14. Gắn policy quản lý **`AWSLambdaBasicExecutionRole`** (nếu tài khoản nhóm có Permissions Boundary như `TeamAppRoleBoundary` thì chọn thêm; tài khoản cá nhân để trống).

![Chọn quyền và Permissions boundary (nếu có)](/images/5-Workshop/5.4/23-role-permissions-boundary.png)

15. Đặt **Role name:** `reloop2-post-confirmation-role`, gắn tag và tạo Role.

![Xem lại và tạo reloop2-post-confirmation-role](/images/5-Workshop/5.4/24-role-review.png)

![Role đã được tạo](/images/5-Workshop/5.4/25-role-created.png)

16. Mở `reloop2-post-confirmation-role` -> **Add permissions -> Create inline policy (JSON)** để cấp đúng quyền `dynamodb:PutItem` trên bảng `reloop2-core-table`:

![Chi tiết Role trước khi gắn Inline policy](/images/5-Workshop/5.4/26-role-details.png)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PutUserProfile",
      "Effect": "Allow",
      "Action": "dynamodb:PutItem",
      "Resource": "arn:aws:dynamodb:ap-southeast-1:123456789012:table/reloop2-core-table"
    }
  ]
}
```

![Nhập JSON inline policy PutUserProfile](/images/5-Workshop/5.4/27-inline-policy-json.png)

17. Đặt tên inline policy là `DynamoDBWriteAccess` và lưu lại.

![Xem lại inline policy DynamoDBWriteAccess](/images/5-Workshop/5.4/28-inline-policy-review.png)

18. Chuyển sang **AWS Lambda -> Create function**:
    - **Function name:** `reloop2-post-confirmation`
    - **Runtime:** `Python 3.12`, **Architecture:** `x86_64`
    - **Execution role:** Chọn Role vừa tạo `reloop2-post-confirmation-role`

![Chọn Execution role cho Lambda](/images/5-Workshop/5.4/29-lambda-pick-role.png)

![Biểu mẫu tạo hàm Lambda reloop2-post-confirmation](/images/5-Workshop/5.4/30-lambda-create-form.png)

![Đã tạo xong hàm Lambda](/images/5-Workshop/5.4/31-lambda-created.png)

19. Tải lên file zip mã nguồn `lambda_function.py` (`reloop2-post-confirmation.zip` với `ConditionExpression="attribute_not_exists(PK)"` chống ghi đè trùng lặp):

```python
import datetime
import os
import boto3

dynamodb = boto3.client("dynamodb")
TABLE_NAME = os.environ["TABLE_NAME"]

def lambda_handler(event, context):
    if event.get("triggerSource") != "PostConfirmation_ConfirmSignUp":
        return event

    attrs = event["request"]["userAttributes"]
    user_id = attrs["sub"]
    email = attrs.get("email", "")
    name = attrs.get("name", "Unknown")
    role = "Owner"
    timestamp = datetime.datetime.utcnow().isoformat() + "Z"

    try:
        dynamodb.put_item(
            TableName=TABLE_NAME,
            Item={
                "PK": {"S": f"USER#{user_id}"},
                "SK": {"S": "PROFILE"},
                "GSI1PK": {"S": f"ROLE#{role}"},
                "GSI1SK": {"S": f"USER#{user_id}"},
                "email": {"S": email},
                "fullName": {"S": name},
                "role": {"S": role},
                "status": {"S": "ACTIVE"},
                "createdAt": {"S": timestamp},
            },
            ConditionExpression="attribute_not_exists(PK)",
        )
    except Exception as exc:
        print(f"Failed to write user to DynamoDB: {exc}")

    return event
```

![Upload file zip mã nguồn Lambda](/images/5-Workshop/5.4/32-lambda-upload-zip.png)

![Cập nhật code thành công](/images/5-Workshop/5.4/33-lambda-code-updated.png)

20. Kiểm tra **General configuration** (`128 MB`, timeout `3 giây`) và thêm biến môi trường **Environment variables**: `TABLE_NAME = reloop2-core-table`.

![Kiểm tra cấu hình bộ nhớ và timeout](/images/5-Workshop/5.4/34-lambda-general-config.png)

![Thêm biến môi trường TABLE_NAME](/images/5-Workshop/5.4/35-lambda-env-table-name.png)

![Đã lưu biến môi trường](/images/5-Workshop/5.4/36-lambda-env-saved.png)

---

### Phần E — Gắn Trigger Post-Confirmation vào Cognito

21. Quay lại `reloop2-user-pool` -> **Extensions -> Lambda triggers**, bấm **Add Lambda trigger**.

![Danh sách Lambda triggers ban đầu trống](/images/5-Workshop/5.4/37-pool-extensions-empty.png)

22. Chọn **Sign-up -> Post confirmation trigger**, chọn hàm `reloop2-post-confirmation` và bấm **Add Lambda trigger**.

![Chọn Post confirmation trigger](/images/5-Workshop/5.4/38-trigger-post-confirmation.png)

![Đã gắn thành công trigger Post confirmation](/images/5-Workshop/5.4/39-trigger-added.png)
