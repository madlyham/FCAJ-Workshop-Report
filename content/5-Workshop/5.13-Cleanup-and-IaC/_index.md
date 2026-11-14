---
title : "Cleanup & Infrastructure as Code (Terraform)"
date : 2026-11-14
weight : 13
chapter : false
pre : " <b> 5.13. </b> "
---

Because **AWS WAFv2 charges continuously by the hour/month** even with zero requests, always tear down all `reloop2-*` workshop resources in reverse dependency order once verification finishes. If you work alongside other environments, verify every name starts with `reloop2` before confirming deletion.

---

### Part A — Exact Reverse-Order Console Teardown

1. **Disable & Delete CloudFront Distribution** (`CloudFront -> Distributions`, `Global`): select your distribution -> **Disable** -> wait until status transitions to `Disabled` -> **Delete**. Disabling first breaks dependencies on WAF `reloop2-web`, OAC, Functions, and `reloop2-security-headers`.

![Disable CloudFront distribution first](/images/5-Workshop/5.13/01-cf-disable.png)

![Confirm deleting disabled CloudFront distribution](/images/5-Workshop/5.13/08-delete-cf-waf.png)

2. **Delete EventBridge Scheduled Rule (`reloop2-sweep`)** (`EventBridge -> Rules`, `ap-southeast-1`): deleting the rule removes the scheduled target cleanly.

![Delete EventBridge rule reloop2-sweep](/images/5-Workshop/5.13/02-delete-eventbridge.png)

3. **Delete CloudWatch Alarms, Dashboard & SNS Topic (`reloop2-*`, `ReLoop2-Backend-Health`, `ap-southeast-1`)**: delete `reloop2-lambda-errors`, `reloop2-api-5xx`, Dashboard `ReLoop2-Backend-Health`, and SNS topic `reloop2-alarms` + its email subscription.

![Delete CloudWatch metric alarms reloop2-lambda-errors and reloop2-api-5xx](/images/5-Workshop/5.13/03-delete-monitoring.png)

4. **Delete Regional WAF (`reloop2-auth`, `ap-southeast-1`)**: disassociate from `reloop2-user-pool` if still attached, then delete `reloop2-auth`.

![Delete regional WAF reloop2-auth](/images/5-Workshop/5.13/04-delete-waf-auth.png)

5. **Delete HTTP API Gateway (`reloop2-api`, `ap-southeast-1`)**.

![Delete HTTP API reloop2-api](/images/5-Workshop/5.13/05-delete-apigw.png)

6. **Delete Bedrock Guardrail (`reloop2-ai-guardrail`)**.

![Delete Bedrock Guardrail reloop2-ai-guardrail](/images/5-Workshop/5.13/06-delete-guardrail.png)

7. **Delete Cognito Domain (`reloop2-auth`) & User Pool (`reloop2-user-pool`)**: first delete the domain prefix (`Branding -> Domain`), then click **Delete user pool**, check **Deactivate deletion protection**, and enter `reloop2-user-pool`.

![Deactivate deletion protection and delete reloop2-user-pool](/images/5-Workshop/5.13/07-delete-cognito.png)

8. **Delete CloudFront Edge WAF, OAC, Response Headers Policy & Functions (`Global / us-east-1`)**: once the CloudFront distribution finishes deleting:
   - Delete Global WAF `reloop2-web`
   - Delete Response Headers Policy `reloop2-security-headers`
   - Delete Origin Access Control `reloop2-web`
   - Delete CloudFront Functions `reloop2-api-prefix` and `reloop2-spa-rewrite`

![Delete CloudFront WAF reloop2-web](/images/5-Workshop/5.13/08b-delete-waf-web.png)

![Delete Response Headers Policy reloop2-security-headers](/images/5-Workshop/5.13/08c-delete-cf-rhp.png)

![Delete CloudFront Function reloop2-spa-rewrite](/images/5-Workshop/5.13/08d-delete-cf-functions.png)

9. **Empty & Delete Both S3 Buckets (`reloop2-web-7k3q`, `reloop2-images-7k3q`)**: because versioned or populated S3 buckets refuse direct deletion, select each bucket -> **Empty** -> type `permanently delete`, then click **Delete** -> enter the bucket name.

![Empty S3 bucket objects and versions first](/images/5-Workshop/5.13/09a-empty-s3.png)

![Delete emptied S3 bucket](/images/5-Workshop/5.13/09-delete-s3.png)

10. **Delete Lambda Functions (`reloop2-api`, `reloop2-post-confirmation`) & CloudWatch Log Groups (`/aws/lambda/reloop2-*`)**: note deleting a Lambda does NOT automatically remove its CloudWatch Log Group—delete both log groups explicitly!

![Confirm deleting both Lambda functions](/images/5-Workshop/5.13/10-delete-lambda.png)

![Delete CloudWatch Log Groups for both Lambdas](/images/5-Workshop/5.13/10b-delete-logs.png)

11. **Delete DynamoDB Table (`reloop2-core-table`)**: keep *Create an on-demand backup* **unchecked** so you incur zero ongoing backup storage fees, type `confirm`, and delete.

![Delete DynamoDB table without retaining backups](/images/5-Workshop/5.13/11-delete-ddb.png)

12. **Delete IAM Roles (`reloop2-api-lambda-role`, `reloop2-post-confirmation-role`)** & **AWS Budget (`reloop2-budget`)**.

![Delete both Lambda IAM execution roles](/images/5-Workshop/5.13/12-delete-iam.png)

![Delete reloop2-budget in Billing & Cost Management](/images/5-Workshop/5.13/12b-delete-budget.png)

---

### Part B — Verify Zero Leftover Resources via AWS CLI

After Console cleanup, verify across both regions that **zero `reloop2` resources** remain:

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

### Part C — Reproducing Everything with Terraform (`terraform/`)

Now that you understand every piece in the AWS Console, you can deploy or destroy the entire ReLoop stack in minutes using the modular **Terraform (>= 1.6.0, `hashicorp/aws >= 5.90`)** code included in this repository's `terraform/` directory:

| File | Managed Infrastructure |
| --- | --- |
| `provider.tf`, `data.tf`, `variables.tf` | Primary `ap-southeast-1` + `us_east_1` alias, CloudFront managed cache/origin policies, parameterized prefix & secrets |
| `storage.tf` | DynamoDB (`PK`/`SK`, `GSI1`, PITR, TTL), private `images` & `web` S3 buckets, CORS, 3 lifecycle rules, OAC bucket policy |
| `identity.tf` | Cognito User Pool, 4 groups, Managed Login v2 domain, PKCE client, `post_confirmation` IAM role + Python Lambda |
| `api.tf` | API Lambda IAM role + inline policy, Node.js 22 `arm64` Lambda, HTTP API Gateway, JWT authorizer, 7 routes, throttling |
| `ai.tf` | Bedrock Guardrail (`reloop2-ai-guardrail`, APAC cross-region profile, Standard tier) + immutable Version `1` |
| `frontend.tf`, `functions/*.js` | OAC, CloudFront Functions (`spa-rewrite.js`, `api-prefix.js`), `security-headers` RHP, dual-origin CloudFront Distribution |
| `security.tf` | Edge WAF (`reloop2-web`, `us-east-1`) + Regional Cognito WAF (`reloop2-auth`, `ap-southeast-1`) + User Pool association |
| `events.tf`, `monitoring.tf`, `outputs.tf` | EventBridge 15m rule, Log retention + metric filter, SNS email topic, 2 Alarms, CloudWatch Dashboard, `$5` AWS Budget |

#### Observed Engineering Notes from Live Import Verification

This Terraform layout was imported and checked against the live `reloop2` Console deployment (`71 / 71` resources imported, `0 to destroy` in `terraform plan`):

1. **Breaking the CloudFront <-> CORS Dependency Cycle:** CloudFront Distribution depends on the API Gateway domain and S3 website bucket, whereas Cognito callback URLs, S3 `images` CORS, and API Gateway CORS need the **generated CloudFront domain**. Keep `cloudfront_cors_origins = []` on your initial `terraform apply`, read `terraform output cloudfront_domain`, then set `cloudfront_cors_origins = ["https://<domain>"]` and apply once more cleanly (just like Console Part 5.8 Part E).
2. **SNS Email Subscriptions (`PendingConfirmation`):** AWS SNS does not return a subscription ARN until the recipient clicks the confirmation email link, so unconfirmed email subscriptions report `PendingConfirmation` until confirmed.
3. **Never Commit Secrets or State:** Keep your real `terraform.tfvars` (containing `origin_verify_secret` and `alert_email`), `terraform.tfstate*`, `.terraform/`, and zip packages strictly out of Git using `.gitignore` — start by copying `terraform.tfvars.example` to `terraform.tfvars`.

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Populate alert_email, origin_verify_secret, and Lambda zip paths
terraform init
terraform plan
terraform apply
# After getting cloudfront_domain output, set cloudfront_cors_origins in terraform.tfvars and re-apply:
terraform apply
# Full cleanup when finished:
terraform destroy
```
