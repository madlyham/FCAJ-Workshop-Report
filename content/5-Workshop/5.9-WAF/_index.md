---
title : "Edge & Cognito Security with AWS WAFv2"
date : 2026-11-14
weight : 9
chapter : false
pre : " <b> 5.9. </b> "
---

In this module you add two layered **AWS WAFv2** Web ACLs:
1. **Edge Web ACL (`reloop2-web`)** in **Global (`us-east-1`)** attached directly to your CloudFront distribution — enforces endpoint-specific rate limiting, global IP ceilings, AWS Managed Rules (`AmazonIpReputationList`, `KnownBadInputsRuleSet`, `CommonRuleSet` tuned to avoid false blocks on photo payloads).
2. **Regional Web ACL (`reloop2-auth`)** in **Singapore (`ap-southeast-1`)** attached directly to your **Cognito User Pool** — throttles credential stuffing and sign-up spam against 7 specific Cognito actions (`300 requests / 5 minutes / IP`).

![Module 5.9 Focus: CloudFront Edge WAF & Cognito Regional WAF](/images/5-Workshop/5.9/architecture.png)

---

### Part A — Create Edge Web ACL (`reloop2-web` in `us-east-1`)

{{% notice warning %}}
Switch your Console region to **Global (CloudFront)** or **US East (N. Virginia) `us-east-1`** before creating `reloop2-web`. CloudFront WAF Web ACLs cannot be created from `ap-southeast-1`.
{{% /notice %}}

1. Open **AWS WAF -> Web ACLs**, select **Global (CloudFront)**, and click **Create web ACL**.

![WAF Web ACLs list in Global CloudFront scope](/images/5-Workshop/5.9/01-waf-list-cloudfront.png)

2. Under **Step 1 — Describe web ACL and associate it to AWS resources**:
   - **Name:** `reloop2-web`
   - **Description:** `ReLoop 2: IP rate limits, bad IPs, common attack patterns - CloudFront`
   - **Associated AWS resources:** Click **Add AWS resources** and attach your CloudFront distribution.

![Associate CloudFront distribution to reloop2-web](/images/5-Workshop/5.9/02-waf-web-associate-cloudfront.png)

![Step 1 web ACL details and CloudFront resource](/images/5-Workshop/5.9/03-waf-web-step1.png)

3. Add all **5 rules** in priority order `0..4`:
   - **Priority 0 — `rate-limit-public-api`:** Rate-based rule (`100` requests / `60`-second window per IP) scoped down (`OR`) to URI path prefix (`LOWERCASE`, `STARTS_WITH`) matching `/api/auth/`, `/api/feed/public`, or `/api/fees`. Action: **Block** returning HTTP **`429`** JSON custom response (`rate_limited`, header `retry-after: 60`):
     `{"code":"RATE_LIMITED","message":"Too many requests - wait about 1 minute and try again"}`

![Configure public API 100 req/min rate limit rule](/images/5-Workshop/5.9/04-waf-rule-rate-limit-public-top.png)

![Scope public API rule prefixes and custom 429 response](/images/5-Workshop/5.9/05-waf-rule-rate-limit-public-bottom.png)

   - **Priority 1 — `rate-limit-per-ip`:** Rate-based rule (`1000` requests / `60`-second window per IP across all paths) returning the same HTTP **`429`** custom JSON response.

![Configure global 1000 req/min per-IP ceiling](/images/5-Workshop/5.9/06-waf-rule-rate-limit-per-ip.png)

   - **Priority 2, 3, 4 — AWS Managed Free Rule Groups:**
     - `AWS-AWSManagedRulesAmazonIpReputationList`
     - `AWS-AWSManagedRulesKnownBadInputsRuleSet`
     - `AWS-AWSManagedRulesCommonRuleSet` — **edit sub-rules** and set **`SizeRestrictions_BODY`** and **`GenericRFI_BODY`** overrides to **`Count`** so rich JSON listing payloads or external map URLs do not trigger false `403` blocks!

![Select free AWS Managed Rule Groups](/images/5-Workshop/5.9/07-waf-free-managed-rules.png)

![Override SizeRestrictions_BODY and GenericRFI_BODY to Count](/images/5-Workshop/5.9/08-waf-crs-overrides.png)

4. Verify the 5 rules, confirm **Priority** ordering (`0` to `4`), keep CloudWatch metrics + sampled requests enabled, review, and click **Create web ACL**.

![All 5 rules added in reloop2-web](/images/5-Workshop/5.9/09-waf-web-step2-rules.png)

![Confirm rule priority evaluation order](/images/5-Workshop/5.9/10-waf-web-priority.png)

![Enable CloudWatch metrics and sampled requests](/images/5-Workshop/5.9/11-waf-web-metrics.png)

![Final review before creating reloop2-web](/images/5-Workshop/5.9/12-waf-web-review.png)

![reloop2-web created](/images/5-Workshop/5.9/13-waf-web-created.png)

![Confirm CloudFront distribution listed under Associated resources](/images/5-Workshop/5.9/14-waf-web-associated.png)

---

### Part B — Create Regional Auth Web ACL (`reloop2-auth` in `ap-southeast-1`)

5. Switch back to **Asia Pacific (Singapore) `ap-southeast-1`** in AWS WAF -> **Create web ACL**.

![WAF Web ACLs list switched to Singapore region](/images/5-Workshop/5.9/15-waf-list-singapore.png)

6. Name it **`reloop2-auth`**, Description `ReLoop 2: brute-force and sign-up spam protection - Cognito`, and under **Associated AWS resources** select **Amazon Cognito user pools -> `reloop2-user-pool`**.

![Associate Cognito User Pool to reloop2-auth](/images/5-Workshop/5.9/16-waf-auth-associate-cognito.png)

![Step 1 regional ACL summary](/images/5-Workshop/5.9/17-waf-auth-step1.png)

7. Add **2 rules**:
   - **Priority 0 — `rate-limit-auth`:** Rate-based rule (`300` requests / `300`-second window per IP) scoped down when HTTP header **`x-amzn-cognito-operation-name`** (`EXACTLY`) matches any of: `InitiateAuth`, `RespondToAuthChallenge`, `SignUp`, `ConfirmSignUp`, `ResendConfirmationCode`, `ForgotPassword`, `ConfirmForgotPassword`. Action: **Block**.
   - **Priority 1 — `AWS-AWSManagedRulesAmazonIpReputationList`**.

![JSON rule builder for rate-limit-auth Cognito operations](/images/5-Workshop/5.9/18-waf-auth-rule-rate-limit-json.png)

![Both rules configured in reloop2-auth](/images/5-Workshop/5.9/19-waf-auth-step2-rules.png)

8. Review, create **`reloop2-auth`**, and confirm `reloop2-user-pool` shows under **Associated AWS resources**.

![Review reloop2-auth settings](/images/5-Workshop/5.9/20-waf-auth-review.png)

![reloop2-auth created](/images/5-Workshop/5.9/21-waf-auth-created.png)

![Confirm Cognito pool association](/images/5-Workshop/5.9/22-waf-auth-associated.png)
