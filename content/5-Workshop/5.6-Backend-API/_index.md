---
title : "Backend Lambda & HTTP API Gateway"
date : 2026-11-14
weight : 6
chapter : false
pre : " <b> 5.6. </b> "
---

In this module you create the core backend compute and routing tier:
- Least-privilege IAM execution role **`reloop2-api-lambda-role`**
- **Node.js 22 ARM64** backend API Lambda **`reloop2-api`** (`512 MB`, `180s` timeout)
- **Amazon API Gateway HTTP API (`reloop2-api`)** with a Cognito **JWT authorizer**, 7 explicit routes, CORS, and `$default` stage rate throttling (`20 req/s`, burst `50`)
- Cognito **PreSignUp Lambda trigger** attached to `reloop2-api` for alias duplicate-email prevention

![Module 5.6 Focus: HTTP API Gateway, API Lambda, Cognito & S3](/images/5-Workshop/5.6/architecture.png)

---

### Part A — Create Least-Privilege IAM Role (`reloop2-api-lambda-role`)

1. Open **IAM -> Roles -> Create role** -> Trusted entity **AWS service -> Lambda**.

![Trusted entity Lambda](/images/5-Workshop/5.6/01-role-trusted-entity.png)

2. Attach **`AWSLambdaBasicExecutionRole`** (plus your lab's Permissions Boundary if applicable).

![Permissions boundary selection](/images/5-Workshop/5.6/02-role-permissions-boundary.png)

3. Name the role **`reloop2-api-lambda-role`**, add standard tags, and click **Create role**.

![Review and name reloop2-api-lambda-role](/images/5-Workshop/5.6/03-role-name-review.png)

![Role created confirmation](/images/5-Workshop/5.6/04-role-created.png)

4. Open `reloop2-api-lambda-role` -> **Add permissions -> Create inline policy** (`reloop2-api-access`) granting least-privilege access to DynamoDB (`reloop2-core-table` + `GSI1`), S3 (`listings/*`), Bedrock (`InvokeModel` + `ApplyGuardrail`), Rekognition (`DetectModerationLabels`, `DetectText`), self-invocation, Cognito `ListUsers`, and CloudWatch Logs:

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

![Inline policy JSON editor](/images/5-Workshop/5.6/05-inline-policy-json.png)

![Review reloop2-api-access policy](/images/5-Workshop/5.6/06-inline-policy-review.png)

![Final attached + inline permissions on role](/images/5-Workshop/5.6/07-role-permissions-final.png)

---

### Part B — Create Backend Lambda (`reloop2-api`)

5. Open **AWS Lambda -> Create function**:
   - **Function name:** `reloop2-api`
   - **Runtime:** `Node.js 22.x`
   - **Architecture:** **`arm64`** (Graviton2 delivers ~20% better price-performance)
   - **Execution role:** Use an existing role -> `reloop2-api-lambda-role`
   - **Tags:** `Owner=team`, `Project=reloop2`, `Purpose=workshop`

![Select reloop2-api-lambda-role](/images/5-Workshop/5.6/08-lambda-custom-role.png)

![Configure workshop tags](/images/5-Workshop/5.6/09-lambda-tags.png)

![Create function summary](/images/5-Workshop/5.6/10-lambda-create-form.png)

![Lambda function reloop2-api created](/images/5-Workshop/5.6/11-lambda-created.png)

6. Upload the compiled backend bundle `reloop2-api.zip` (`index.js` + `index.js.map`).

![Upload reloop2-api deployment package](/images/5-Workshop/5.6/12-lambda-upload-zip.png)

![Deployment package updated](/images/5-Workshop/5.6/13-lambda-code-uploaded.png)

7. Go to **Configuration -> General configuration -> Edit**:
   - **Memory:** `512 MB`
   - **Timeout:** `3 min 0 sec` (`180` seconds — handles multimodal Bedrock latency cleanly)
   - **Description:** `ReLoop 2 backend API (workshop)`

![Edit General configuration 512 MB and 3 min](/images/5-Workshop/5.6/14-lambda-basic-settings.png)

![Updated general configuration summary](/images/5-Workshop/5.6/15-lambda-general-config.png)

8. Go to **Configuration -> Environment variables -> Edit** and set:

| Key | Value / Purpose |
| --- | --- |
| `STAGE` | `aws` |
| `AUTH_MODE` | `cognito` |
| `TABLE_NAME` | `reloop2-core-table` |
| `IMAGE_BUCKET` | `reloop2-images-7k3q` |
| `COGNITO_CLIENT_ID` | `<your reloop2-web-client Client ID>` |
| `AI_MODEL_ID` | `global.moonshotai.kimi-k3` |
| `ORIGIN_VERIFY_SECRET` | `<generate strong 32-byte random hex>` (shared with CloudFront in Module 5.8!) |
| `NODE_OPTIONS` | `--enable-source-maps` |

{{% notice warning %}}
Keep **`ORIGIN_VERIFY_SECRET`** strictly private (never hardcode it in frontend code or commit it to Git). ReLoop checks this header in constant time (`crypto.timingSafeEqual`) and rejects direct calls to `*.execute-api.ap-southeast-1.amazonaws.com` once enabled.
{{% /notice %}}

![Add Lambda environment variables](/images/5-Workshop/5.6/16-lambda-env-vars.png)

![Environment variables saved](/images/5-Workshop/5.6/17-lambda-env-vars-saved.png)

![Verify STAGE=aws and ORIGIN_VERIFY_SECRET](/images/5-Workshop/5.6/37-lambda-env-stage.png)

---

### Part C — Build HTTP API Gateway (`reloop2-api`)

9. Open **API Gateway -> Create API -> HTTP API -> Build**:
   - **API name:** `reloop2-api`
   - **Integration:** Lambda -> `reloop2-api` (payload format `2.0`)

![Choose HTTP API in API Gateway](/images/5-Workshop/5.6/18-apigw-choose-http.png)

![Add Lambda integration reloop2-api](/images/5-Workshop/5.6/19-apigw-integration.png)

10. Define all **7 routes** (6 unauthenticated public/auth/CORS routes + 1 catch-all `ANY /{proxy+}` route for protected endpoints):

| Method | Resource Path | Authorization |
| --- | --- | --- |
| `POST` | `/auth/session` | None |
| `POST` | `/auth/logout` | None |
| `POST` | `/auth/refresh` | None |
| `GET` | `/feed/public` | None |
| `GET` | `/fees` | None |
| `OPTIONS` | `/{proxy+}` | None (CORS preflight) |
| `ANY` | `/{proxy+}` | **JWT Authorizer (`cognito`)** |

![Define 7 HTTP API routes](/images/5-Workshop/5.6/20-apigw-routes.png)

11. Keep `$default` stage with **Auto-deploy** enabled, review, and click **Create**.

![Configure $default stage with auto-deploy](/images/5-Workshop/5.6/21-apigw-stage-default.png)

![Review HTTP API settings](/images/5-Workshop/5.6/22-apigw-review.png)

![HTTP API reloop2-api created](/images/5-Workshop/5.6/23-apigw-created.png)

12. Go to **Authorization -> Manage authorizers -> Create**:
    - **Authorizer type:** `JWT`
    - **Name:** `cognito`
    - **Identity source:** `$request.header.Authorization`
    - **Issuer URL:** `https://cognito-idp.ap-southeast-1.amazonaws.com/<your-user-pool-id>`
    - **Audience:** `<your reloop2-web-client Client ID>`
    Then attach `cognito` specifically to **`ANY /{proxy+}`** (`Attach authorizer`), leaving `/auth/*`, `/feed/public`, `/fees`, and `OPTIONS /{proxy+}` open!

![Route ANY /{proxy+} before attaching authorizer](/images/5-Workshop/5.6/24-auth-route-no-authorizer.png)

![Create JWT authorizer pointing to Cognito pool](/images/5-Workshop/5.6/25-jwt-authorizer-form.png)

![JWT authorizer attached to ANY /{proxy+}](/images/5-Workshop/5.6/26-jwt-authorizer-attached.png)

13. Go to **Develop -> CORS -> Configure**:
    - **Access-Control-Allow-Origin:** `http://localhost:5173` (CloudFront origin added in Module **5.8**)
    - **Access-Control-Allow-Headers:** `authorization`, `content-type`, `idempotency-key`
    - **Access-Control-Allow-Methods:** `*`
    - **Access-Control-Max-Age:** `3600`
    - **Access-Control-Allow-Credentials:** `No` (`false`)

![Empty API Gateway CORS screen](/images/5-Workshop/5.6/27-cors-empty.png)

![Fill API Gateway CORS headers and methods](/images/5-Workshop/5.6/28-cors-form.png)

![API Gateway CORS saved](/images/5-Workshop/5.6/29-cors-saved.png)

14. Go to **Deploy -> Stages -> `$default` -> Throttling -> Edit**:
    - **Rate limit:** `20` requests/second
    - **Burst limit:** `50` requests

![Stage throttling before edit](/images/5-Workshop/5.6/30-throttling-before.png)

![Configure 20 req/s rate limit and 50 burst](/images/5-Workshop/5.6/31-throttling-form.png)

![Throttling limits saved](/images/5-Workshop/5.6/32-throttling-saved.png)

15. Inspect **Develop -> Integrations** and Lambda **Configuration -> Permissions -> Resource-based policy statements** to verify API Gateway holds explicit invoke permissions for every route pattern (`/auth/session`, `/auth/logout`, `/auth/refresh`, `/feed/public`, `/fees`, `/{proxy+}`).

![API Gateway integration details](/images/5-Workshop/5.6/33-integration-details.png)

![Lambda resource-based policy statements](/images/5-Workshop/5.6/34-lambda-resource-policy.png)

---

### Part D — Attach Pre-SignUp Trigger in Cognito

16. Return to **Cognito -> `reloop2-user-pool` -> Extensions -> Lambda triggers -> Add Lambda trigger**:
    - **Trigger type:** **Sign-up -> Pre sign-up trigger**
    - **Lambda function:** `reloop2-api`
    This calls `Cognito ListUsers` before registration finishes to block duplicate-email sign-ups across different sign-in casing or aliases.

![Select Pre sign-up trigger targeting reloop2-api](/images/5-Workshop/5.6/35-presignup-trigger-form.png)

![Both Pre sign-up and Post confirmation triggers attached](/images/5-Workshop/5.6/36-presignup-trigger-added.png)
