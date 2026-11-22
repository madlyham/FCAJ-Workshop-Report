---
title : "Cleanup & Terraform Reference"
date : 2026-11-21
weight : 12
chapter : false
pre : " <b> 5.12. </b> "
---

Delete every `reloop2` resource created in Modules **5.3–5.10** in safe reverse dependency order so zero ongoing charges remain (especially AWS WAFv2).

---

### Part A — Reverse-Order Teardown Checklist

1. **Start disabling CloudFront first (Global):** Open **CloudFront -> Distributions -> `<dist-id>`**:
   - Remove the associated WAF (`reloop2-web`) and detach `reloop2-spa-rewrite` / `reloop2-api-prefix` from the two behaviors.
   - Click **Disable** (takes ~2–4 minutes while you delete the regional services below).
2. **EventBridge (`ap-southeast-1`):** Open `reloop2-sweep` -> remove target `reloop2-api` -> delete rule `reloop2-sweep`.
3. **Monitoring & Alerts (`ap-southeast-1`):**
   - Delete CloudWatch alarm **`reloop2-lambda-errors`**.
   - Delete SNS topic **`reloop2-alerts`** (and any confirmed subscriptions).
   - Delete CloudWatch Log Groups **`/aws/lambda/reloop2-api`** and **`/aws/lambda/reloop2-post-confirmation`**.
4. **AI Processing (`ap-southeast-1`):** Open **Amazon Bedrock -> Guardrails** -> delete **`reloop2-ai-guardrail`** (deletes `DRAFT` and Version `1`).
5. **API Backend (`ap-southeast-1`):** Delete HTTP API Gateway **`reloop2-api`**.
6. **Sign-up & Sign-in (`ap-southeast-1`):** Open **Cognito -> `reloop2-user-pool`**:
   - Under **Branding -> Domain**, delete domain `reloop2-auth` (or your suffixed domain prefix).
   - Under **Overview -> Delete user pool**, uncheck/deactivate **Deletion protection** and delete `reloop2-user-pool`.
7. **Lambdas & IAM Roles:**
   - Delete Lambda functions **`reloop2-api`** and **`reloop2-post-confirmation`** (`ap-southeast-1`).
   - Open **IAM -> Roles** -> delete **`reloop2-api-lambda-role`** and **`reloop2-post-confirmation-role`** (inline policies are removed with the role).
8. **Data Storage (`ap-southeast-1`):**
   - Delete DynamoDB table **`reloop2-core-table`**.
   - Empty and delete both S3 buckets: **`reloop2-images-<suffix>`** and **`reloop2-web-<suffix>`**.
9. **Finish Global Edge (`Global / us-east-1`):**
   - Once CloudFront `<dist-id>` shows **Disabled + Deployed**, delete the distribution.
   - Delete CloudFront Origin Access Control **`reloop2-web-oac`** and Functions **`reloop2-spa-rewrite`** + **`reloop2-api-prefix`**.
   - Open **AWS WAF & Shield -> Global (CloudFront)** -> delete Web ACL **`reloop2-web`**.

![CloudFront Distributions list confirming reloop2 distribution deleted](/images/5-Workshop/5.12/01-cleanup-cloudfront.png)

![AWS WAF Global Web ACLs list confirming reloop2-web deleted](/images/5-Workshop/5.12/02-cleanup-waf.png)

---

### Part B — Verify Zero Leftover `reloop2` Resources via AWS CLI

Run this quick read-only check in your terminal and confirm every command returns `[]`:

```bash
aws cloudfront list-distributions --query "DistributionList.Items[?contains(Comment || '', 'reloop2')].Id"
aws wafv2 list-web-acls --scope CLOUDFRONT --region us-east-1 --query "WebACLs[?contains(Name,'reloop2')].Name"
aws s3api list-buckets --query "Buckets[?contains(Name,'reloop2')].Name"
aws dynamodb list-tables --region ap-southeast-1 --query "TableNames[?contains(@,'reloop2')]"
aws cognito-idp list-user-pools --max-results 60 --region ap-southeast-1 --query "UserPools[?contains(Name,'reloop2')].Name"
aws apigatewayv2 get-apis --region ap-southeast-1 --query "Items[?contains(Name,'reloop2')].Name"
aws lambda list-functions --region ap-southeast-1 --query "Functions[?contains(FunctionName,'reloop2')].FunctionName"
aws bedrock list-guardrails --region ap-southeast-1 --query "guardrails[?contains(name,'reloop2')].name"
aws events list-rules --region ap-southeast-1 --query "Rules[?contains(Name,'reloop2')].Name"
aws cloudwatch describe-alarms --region ap-southeast-1 --query "MetricAlarms[?contains(AlarmName,'reloop2')].AlarmName"
aws sns list-topics --region ap-southeast-1 --query "Topics[?contains(TopicArn,'reloop2')].TopicArn"
```

---

### Part C — Terraform Infrastructure-as-Code Reference

If you prefer reproducible Infrastructure as Code over manual Console clicks, clone the companion repository **[github.com/madlyham/ReLoop](https://github.com/madlyham/ReLoop)**. Its modular [`terraform/`](https://github.com/madlyham/ReLoop/tree/main/terraform) directory models this exact 12-service architecture (`provider.tf`, `data.tf`, `variables.tf`, `frontend.tf`, `security.tf`, `identity.tf`, `api.tf`, `storage.tf`, `ai.tf`, `events.tf`, `monitoring.tf`, `outputs.tf`) and references the included `zips/` and `cloudfront-functions/` directly:

```bash
git clone https://github.com/madlyham/ReLoop.git
cd ReLoop/terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars (bucket_suffix, alert_email, origin_verify_secret)
terraform init
terraform plan
terraform apply
```

After `terraform apply` finishes, return to the repository root (`cd ..`), run `python frontend/configure.py` with the printed Cognito outputs, and sync `frontend/build/` to the S3 web bucket (see the repository [README](https://github.com/madlyham/ReLoop#option-2--deploy-with-terraform-reproducible-iac)). When finished, empty both S3 buckets, set `cognito_deletion_protection = "INACTIVE"` in `terraform.tfvars`, run `terraform apply` first to disable deletion protection on the User Pool, and then run `terraform destroy`.

---

### Part D — Troubleshooting, Lessons Learned & Future Roadmap

#### Issues Encountered & How We Solved Them

| # | Issue Encountered | Root Cause | How We Solved It |
| --- | --- | --- | --- |
| 1 | **IAM Role creation denied (`AccessDenied`)** | Team account IAM policy requires a permissions boundary on every newly created application role. | Attached the required permissions boundary (`TeamAppRoleBoundary`) to both `reloop2-api-lambda-role` and `reloop2-post-confirmation-role`. |
| 2 | **API Gateway routes failed with `/api` prefix mismatch** | CloudFront routes `/api/*` to the API Gateway origin, while backend routes are registered without the `/api` prefix (e.g. `/feed/public`). | Added CloudFront Function `reloop2-api-prefix` on the `/api/*` behavior to strip `/api` at the edge before forwarding to API Gateway. |
| 3 | **Direct API Gateway calls bypassed CloudFront & WAF** | Default `execute-api` endpoints remain publicly reachable unless explicitly locked to CloudFront. | Configured CloudFront to send the `x-origin-verify` secret header and verified it in `reloop2-api` with constant-time `timingSafeEqual`, rejecting direct calls with `403 DIRECT_ACCESS_FORBIDDEN`. |
| 4 | **Bedrock invocation in Singapore & prompt injection in photo text** | Cross-region model routing and untrusted text printed on device labels posed reliability and prompt-injection risks. | Used `global.moonshotai.kimi-k3` via Converse API in `ap-southeast-1` and screened Rekognition-extracted text through Amazon Bedrock Guardrail (`apac.guardrail.v1:0`) before LLM analysis. |
| 5 | **26% `5xx` errors under 80-request burst load test** | Account Lambda concurrency started at `10`, saturating workers before throttling could shape burst traffic. | Raised Lambda concurrency to `1,000`, configured API Gateway throttling (`20 req/s`, burst `50`), and attached CloudFront WAF per-IP rate limits returning clean `429` responses — eliminating `5xx` errors on re-test. |

#### Future Roadmap

- **Custom Email Delivery with Amazon SES:** Move beyond Cognito's default ~50 emails/day sender limit to a verified Amazon SES domain for public sign-ups and notifications.
- **Real-Time WebSocket Chat:** Replace the current 5-second HTTP chat polling with Amazon API Gateway WebSocket APIs for instant buyer–seller messaging and offers.
- **GitHub Actions OIDC Terraform CD:** Automate `terraform plan` on pull requests and approved `terraform apply` runs using keyless GitHub Actions OIDC credentials.
- **Multi-City Expansion:** Expand ReLoop beyond Ho Chi Minh City using the existing location-agnostic geohash + Haversine matching engine and modular Terraform stacks.
