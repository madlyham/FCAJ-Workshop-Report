---
title: "Proposal"
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# RELOOP
## An AI-assisted marketplace for used and broken electronics, built serverless on AWS

### 1. Executive Summary
ReLoop is a web marketplace where people in Vietnam sell used or broken electronics (phones, laptops, monitors, components) to nearby repair shops, buyers and recyclers. It was built by a 5-person team during a 12-week AWS internship [TO BE ADDED: team / organisation name and city]. A seller uploads photos, and Amazon Bedrock pre-fills the listing. The listing then goes to every approved buyer whose branch service area (1–15 km) covers it, and the deal closes through a buyer quote or a price agreed in chat. On 08/11/2026 the dev environment had 14 registered accounts, 12 active listings from 7 sellers and about 31,000 API requests over the first month. The serverless design scales without re-architecture: Lambda concurrency is approved up to 1,000. The core services are CloudFront, AWS WAF, API Gateway, Lambda, DynamoDB, S3, Cognito, Rekognition, Bedrock, EventBridge, CloudWatch and SNS. Guests can browse the market without an account. Signed-in users can chat and buy. Only Admin-approved partners can sell, and only Admin and Finance Admin can moderate content and handle invoices.

### 2. Problem Statement
#### What's the Problem?
The Global E-waste Monitor 2024 (UNITAR/ITU) reports that the world generated 62 million tonnes of e-waste in 2022, and only 22.3% was formally collected and recycled [TO BE ADDED: Vietnam-specific figure, if available]. Owners of an old or broken device rarely know who will take it or what it is worth. Today they post on general classifieds sites or social groups, describe the device by hand, call shops one by one, and often get no answer. General marketplaces such as Chợ Tốt or Facebook Marketplace are built for any kind of goods. They do not:
- match a listing to the shops whose service area covers the seller,
- show a price estimate from the buyer's own pricing rules,
- keep a reputation record that rewards buyers who honour their quotes.

Small repair shops face the same gap from the other side. They have no cheap channel to receive nearby devices that fit what they buy.

#### The Solution
ReLoop runs the whole flow on managed AWS services. There are no servers to run.
- **Ingest:** the browser uploads up to 6 photos per listing (JPEG/PNG/WebP, max 5 MB each) straight to Amazon S3 using presigned POST URLs. Amazon Rekognition checks every photo for unsafe content and reads any text in it. That text goes through Amazon Bedrock Guardrails, so prompt-injection attempts are flagged for Admin review.
- **Processing:** one AWS Lambda function (Node.js 22, arm64) serves 111 API routes behind Amazon API Gateway. It also calls itself asynchronously for slow work:
  - AI photo analysis with Kimi K3 on Bedrock, about 35 s per run;
  - geohash + Haversine matching of listings to buyer branches.

  Amazon EventBridge triggers the same function every 15 minutes to expire listings, auto-complete transactions after 48 hours, send reminders and issue monthly invoices.
- **Storage:** a single Amazon DynamoDB table (PK/SK + one GSI) stores every entity: users, partners, branches, pricing rules, listings, quotes, transactions, chats, reviews, invoices and audit logs. Writes are conditional, and money-related APIs require an `Idempotency-Key`. S3 lifecycle rules delete unused photos after 1 day and all photos after 90 days.
- **Interface:** a React single-page app served from a private S3 bucket through Amazon CloudFront. It has a public market, a partner portal (2 tiers) and an Admin portal.
- **Security:** Amazon Cognito handles sign-in with Admins / FinanceAdmins groups. API Gateway checks a JWT on every private route. Two AWS WAF web ACLs protect the site: one on CloudFront (managed rules + rate limits) and one on the Cognito user pool (login rate limit). A strict Content-Security-Policy is applied, and each IAM permission is limited to exactly what the code needs.

Compared with general classifieds, ReLoop adds AI-filled listings, service-area matching, rule-based price estimates, a two-step completion (seller confirms the final price, buyer accepts) and two-way reviews. ReLoop does not handle payment: buyer and seller pay each other in person at hand-over.

#### Benefits and Return on Investment
- **Less manual input:** AI suggests title, category, brand, model and condition from up to 3 photos. The seller only confirms or edits [TO BE ADDED: measured time per listing with and without AI].
- **Fewer unanswered listings:** every new listing is matched automatically to all buyer branches in range, and listings within 5 km are ranked first.
- **Reliability:** state machines, conditional writes and idempotent background jobs keep listings, quotes and transactions consistent. 182 automated tests and an end-to-end smoke test run against AWS.
- **Learning value:** the team practised single-table DynamoDB design, event-driven Lambda, Bedrock structured output, Terraform IaC, WAF tuning and an automated pentest.
- **Cost:** about **18.70 USD/month (224.40 USD/year)** at the current scale (section 6). 17.00 USD of that is AWS WAF, so without WAF the platform costs about 1.70 USD/month. Until 28/02/2027 the cost is covered by the account's remaining credits (197.14 USD on 08/11/2026).
- **Payback:** revenue is 10,000 VND per completed transaction, paid by the seller. At an assumed rate of 1 USD ≈ 26,000 VND [TO BE ADDED: confirm exchange rate], 18.70 USD ≈ 486,200 VND. The platform therefore breaks even at **49 completed transactions per month**, or 5 per month without WAF.

### 3. Solution Architecture
ReLoop is fully serverless in one region (ap-southeast-1):
- All browser traffic passes AWS WAF and CloudFront. Static files come from a private S3 bucket, and `/api/*` is forwarded to an HTTP API with a secret origin header, so direct calls to API Gateway are rejected.
- One Lambda function holds the business logic. It calls DynamoDB, S3, Rekognition and Bedrock through small adapters, so the same code also runs locally on Node.js with in-memory storage.
- Sign-up and sign-in go directly from the browser to Cognito, protected by a second WAF.
- Logs and custom business metrics flow to CloudWatch, and alarms are sent to the Admin by SNS email.
- All infrastructure is defined in Terraform, with state stored in a versioned S3 bucket.

![ReLoop architecture](/images/2-Proposal/reloop-architecture.png)

*Diagram source: `static/images/2-Proposal/reloop-architecture.drawio` (generated by `diagram/make_architecture.py`).*

#### AWS Services Used
- **Amazon CloudFront:** serves the web app and routes `/api/*` to API Gateway. It adds CSP, HSTS and X-Frame-Options headers and returns a real 404 for missing static files.
- **AWS WAF:** 2 web ACLs.
  - `reloop-dev-web` on CloudFront: 3 AWS managed rule groups plus 2 rate limits returning 429. The limits are 100 requests per minute per IP on the public API and 1,000 requests per minute per IP overall.
  - `reloop-dev-auth` on Cognito: 300 sign-in attempts per 5 minutes per IP, plus IP reputation.
- **Amazon S3:** 3 buckets — web bundle (private, OAC), device photos (presigned POST/GET, tag-based lifecycle) and Terraform state (versioned).
- **Amazon API Gateway (HTTP API):** JWT authorizer on every private route; throttled at 20 requests/s with a burst of 50.
- **AWS Lambda:** `reloop-dev-api`, Node.js 22 on arm64 (Graviton) with 512 MB. It runs the API, the async AI/matching worker, the scheduled jobs and the Cognito pre sign-up trigger. Average duration is 144 ms; concurrency quota is 1,000.
- **Amazon DynamoDB:** one on-demand table with PK/SK and GSI1, PITR and TTL (notifications expire after 90 days). It holds about 5,600 items (2.4 MB).
- **Amazon Cognito:** user pool with email verification and groups Admins, FinanceAdmins, Partners and Owners. It has 14 users.
- **Amazon Rekognition:** moderation labels on every photo (rejects explicit content; borderline cases go to Admin) and text detection.
- **Amazon Bedrock:** Kimi K3 through the Converse API with tool choice, returning structured JSON. A Guardrail (Standard tier) screens AI input/output and text found in photos. Each user is capped at 20 analyses per day.
- **Amazon EventBridge:** 1 rule every 15 minutes that runs the background sweep.
- **Amazon CloudWatch:** logs kept 7 days, custom business metrics, 1 dashboard and 10 alarms (Lambda errors/throttles, API 5xx, p95 > 2 s, AI/job failures, unusual photo text, new disputes).
- **Amazon SNS:** sends alarm emails to Admin.
- **AWS IAM:** one execution role scoped to the core table, the photo prefix, the specific Bedrock model and Guardrail, Rekognition, self-invoke and logs.
- **AWS Security Agent:** automated black-box pentest of the dev site (3.63 task-hours on 08/11/2026).

#### Component Design
- **Edge / Client:** a React 18 + TypeScript SPA (Vite) with Leaflet + OpenStreetMap for picking locations. Guests see the market. After sign-in, users see the partner portal (tier 1: individual sellers, max 3 open listings; tier 2: businesses with branches, pricing rules and quotes, max 10) or the Admin portal.
- **Ingestion:**
  1. `POST /uploads/presign` returns a 5-minute presigned POST, and the browser uploads the photo directly to S3.
  2. `POST /uploads/moderate` runs Rekognition and tags the photo `moderation=passed`.
  3. When a listing is created, its photos are tagged `state=attached`, so the lifecycle rule keeps them.
- **Processing:** an HTTP router handles JWT claims, idempotency keys and input checks. Domain state machines for Listing, Quote and Transaction allow only valid moves (for example, a transaction cancel takes effect after 5 minutes, and completion is auto-accepted after 48 hours). AI analysis and matching run as async self-invocations. A job runner keyed by "time buckets" finds due work without table scans.
- **Storage:** all access patterns are listed in `backend/src/store/keys.ts`; the code never scans the table. The market feed is partitioned by month and paginated with a validated cursor. Money is stored as integer VND.
- **Web Interface:** the public market, chat per listing (5-second polling) with price offers, the transaction drawer (schedule hand-over, adjust price, confirm, dispute) and reviews.
- **User Management:** Cognito sign-up with email verification. The pre sign-up trigger blocks one mailbox from opening several accounts through email aliases (`name+1@…`, dotted Gmail addresses). Admin approves partner applications, and Finance Admin issues and settles monthly invoices. If an invoice is more than 3 days overdue the seller cannot post new listings; after 7 days the account is locked.
- **Monitoring:** structured JSON logs, metric filters for business events, a dashboard (`reloop-dev-overview`), alarms to SNS email, and WAF logs to CloudWatch Logs with authorization and cookie fields redacted.

### 4. Technical Implementation
#### Implementation Phases
1. **Research & Architecture (10/10–16/10/2026):** turned the 1,189-paragraph specification v1.0 into 45 written business decisions (QĐ-01 → QĐ-45), listed the DynamoDB access patterns, chose one Lambda behind an HTTP API, and wrote the first Terraform (Cognito, API Gateway, Lambda, S3/CloudFront).
2. **Cost Estimation & Feasibility (12/10–18/10/2026):**
   - dropped bank top-up/withdrawal (no bank API available) in favour of direct payment at hand-over;
   - chose on-demand DynamoDB and arm64 Lambda;
   - kept every AWS call behind interfaces so the team can develop locally without an AWS bill.
3. **Develop & First Deploy (12/10–22/10/2026):** completed the full market flow on AWS (18/10), the two-tier partner model, quotes, chat offers, transactions, reviews, billing, moderation, and the `smoke-aws.py` end-to-end test.
4. **Architecture Refinement (23/10–06/11/2026):**
   - rebuilt the whole UI from the product owner's designs and added a new Admin portal;
   - moved AI to Kimi K3 on Bedrock (28/10);
   - ran 5 QA rounds (146 findings, 03/11);
   - raised Lambda concurrency from 10 to 1,000;
   - put AWS WAF on CloudFront and Cognito (06/11).
5. **Test, Harden & Hand Over (07/11/2026–01/01/2027):**
   - pentest and fixes (08/11);
   - CSP enforcement;
   - a single CI/CD deploy path with per-member IAM users;
   - SES for email, AWS Budgets, load test, production environment;
   - final documentation and demo.

#### Technical Requirements
- **Software:** Node.js 22, TypeScript 5, React 18 + Vite 5, Leaflet, amazon-cognito-identity-js, AWS SDK v3, esbuild, Vitest; Python 3 for the AWS smoke test.
- **Infrastructure as Code:** Terraform ≥ 1.10 (AWS provider 6.x) with remote state in S3; `infra/deploy.sh` (build → `terraform apply` → upload web → CloudFront invalidation); AWS CLI ≥ 2.32.
- **CI:** GitHub Actions runs typecheck, 182 tests and the web build on every pull request.
- **Hardware:** none beyond the developers' laptops. There are no devices on site.
- **Skills:** DynamoDB single-table modelling, IAM least privilege, Bedrock prompt and Guardrail design, WAF rule tuning, React, and testing with fakes for AWS services.

### 5. Timeline & Milestones

| Period | Dates | Deliverables |
|---|---|---|
| Pre-internship | before 10/10/2026 | Specification v1.0 (business workflow + system design) [TO BE ADDED: date started] |
| Weeks 1–2 | 10/10–23/10 | 45 business decisions; repo + CI; Terraform dev environment; full market flow live on AWS (18/10); deployed with smoke test passing (22/10) |
| Weeks 3–4 | 24/10–06/11 | New UI from PO designs (public site, partner portal, Admin portal); AI on Kimi K3; background matching; 5 QA rounds; WAF on CloudFront + Cognito |
| Week 5 | 07/11–13/11 | AWS Security Agent pentest (7 findings, none high); fixes deployed; CSP enforced; budget check |
| Weeks 6–8 | 14/11–04/12 | Single CI/CD deploy path; IAM user per member; merge to `main`; SES for email; AWS Budgets alerts |
| Weeks 9–11 | 05/12–25/12 | Load test after throttling fix; production environment; final bug fixing |
| Week 12 | 26/12/2026–01/01/2027 | Final report, demo, hand-over documentation |
| Post-launch | 01/2027–02/2027 | Run on the dev/prod environment within the credit window (until 28/02/2027); collect real usage data for the AI and matching |

### 6. Budget Estimation
Estimate on AWS Pricing Calculator: [TO BE ADDED: AWS Pricing Calculator link]. The line-by-line estimate is in [reloop-cost-estimate.csv](/files/2-proposal/reloop-cost-estimate.csv).

#### Infrastructure Costs
Region ap-southeast-1 (Singapore). The figures are based on real Cost Explorer and CloudWatch data from 10/10 to 08/11/2026: about 31,000 API requests and 14 users.

| Service | USD / month | Assumption |
|---|---|---|
| AWS WAF – CloudFront web ACL | 10.00 | 1 web ACL (5.00) + 5 rules (5 × 1.00) + 0.60 per 1M requests |
| AWS WAF – Cognito web ACL | 7.00 | 1 web ACL (5.00) + 2 rules (2 × 1.00) |
| Amazon Bedrock (Kimi K3 + Guardrails) | 1.00 | October usage (0.87 USD), capped at 20 analyses/user/day |
| Amazon Rekognition | 0.30 | Moderation + text detection for ~70–100 photos/month |
| Amazon DynamoDB (on-demand) | 0.10 | ~5,600 items, 2.4 MB, PITR on |
| Amazon API Gateway (HTTP API) | 0.10 | ~31,000 requests/month |
| Amazon S3 | 0.05 | Web bundle + photos (lifecycle 1/90 days) + Terraform state |
| Miscellaneous (data transfer, other) | 0.15 | Buffer for small line items seen in October |
| AWS Lambda | 0.00 | ~2,250 GB-s/month — Free Tier (1M requests + 400,000 GB-s) |
| Amazon CloudFront | 0.00 | Free Tier (1 TB + 10M requests/month) |
| Amazon Cognito | 0.00 | 14 users — Free Tier up to 10,000 MAU |
| Amazon CloudWatch + SNS + EventBridge | 0.00 | 10 alarms, 1 dashboard, 7-day logs, email alerts, 1 schedule — Free Tier |
| AWS Security Agent | 0.00 | Free trial (400 task-hours/month); 3.63 task-hours used |
| **Total per month** | **18.70** | |
| **Total for 12 months** | **224.40** | |

- **One-time hardware:** 0 USD.
- **Credits:** the account is on the AWS Free plan with 197.14 USD of credits valid until 28/02/2027. That covers the roughly 3.7 months to that date (≈ 69 USD) at no cash cost.
- **Optional saving:** turning both WAF web ACLs off (`waf_enabled`, `cognito_waf_enabled`) lowers the bill to about 1.70 USD/month, but removes rate limiting and managed rules.
- *Prices are AWS list prices for ap-southeast-1 in November 2026 and can change. Usage-based lines grow with traffic.*

### 7. Risk Assessment
#### Risk Matrix

| Risk | Impact | Probability |
|---|---|---|
| R1. Two machines deploy different code to the same Lambda (happened on 28/10/2026) | High | Medium |
| R2. Credits run out or an unexpected charge appears (a Free-plan account is closed when credits are used up) | High | Low |
| R3. Lambda/API throttling under bursts (load test: 80 parallel requests → 26% 5xx at concurrency 10) | Medium | Medium |
| R4. AI misreads a device or is fed malicious text inside a photo | Medium | Medium |
| R5. A security flaw in the public site or API | High | Low |
| R6. Sellers and buyers close the deal off-platform to avoid the fee | Medium | High |
| R7. Cognito's default email limit (~50 emails/day) blocks sign-ups during a demo | Medium | Medium |

#### Mitigation Strategies
- **R1:** one deploy path (`deploy.sh` from a committed revision, moving to CI), an IAM user per member, and no root access keys. Check the live Lambda's `LastModified` and CloudTrail before every deploy.
- **R2:** every paid feature is sized against the remaining credits before it is turned on, with hard caps (AI 20/day/user, pentest stopped at 3.5 task-hours). Add AWS Budgets alerts at 50% / 80%.
- **R3:** Lambda concurrency raised to 1,000; API Gateway throttle (20/s, burst 50) and WAF rate limits return 429 with Retry-After instead of failing.
- **R4:** AI only suggests and the seller confirms every field; the system stores the AI suggestion and the seller's final value side by side. Guardrails and Rekognition flag suspicious photo text, and flagged listings wait for Admin review.
- **R5:** WAF managed rules, strict CSP, JWT on every private route, ownership checks on photo keys, and a pentest each release (latest: 7 findings, none high, fixes live on 08/11/2026).
- **R6:** a fee is charged when a listing is removed within 72 hours after a cancelled transaction, fee appeals go to Finance Admin, and repeat offenders are flagged.
- **R7:** move Cognito email to Amazon SES before public testing.

#### Contingency Plans
- **Bad deploy:** redeploy the last good commit with `deploy.sh`. Terraform keeps everything else unchanged, and `terraform plan` shows the exact diff first.
- **Cost spike:** set `waf_enabled=false` / `cognito_waf_enabled=false` and lower the AI daily limit. Stop any Security Agent job with `stop-pentest-job`.
- **Bedrock unavailable:** AI is optional, so sellers fill in the form by hand and listings still go live.
- **WAF or CSP blocks real users:** change the rule/limit or the CSP in `infra/waf.tf` / `infra/web.tf` and apply. That takes one CloudFront update with no code release.
- **Data issue:** restore DynamoDB with PITR (up to 35 days). Photos can be re-uploaded by sellers.

### 8. Expected Outcomes
#### Technical Improvements
- A complete, working marketplace on AWS: 111 API routes, 3 portals, 182 automated tests and an end-to-end smoke test passing on AWS.
- Infrastructure fully reproducible from Terraform in one command, at about 18.70 USD/month. The variable part (Lambda, DynamoDB, API Gateway, S3) costs under 1 USD/month at current traffic.
- Measurable security baseline: WAF on both entry points, strict CSP, and a pentest with 7 findings, none high, all fixable ones fixed.
- Response time: average Lambda duration of 144 ms, with an alarm if p95 goes above 2 s.

#### Long-term Value
- Every listing stores the AI suggestion next to the seller's final value. Over time this becomes labelled data for evaluating or fine-tuning device recognition.
- The adapter design (Table, ImageStore, Analyzer, AuthProvider) lets the team swap or add services, such as SES email, WebSocket chat or a bank payment API, without touching the business logic.
- The same Terraform and deploy script can create a production stack or a stack for another city. The geohash matching works anywhere.
- Shops and recyclers gain a steady, local channel for used devices. That moves more devices into reuse and formal recycling instead of household storage.

---

**Items to complete ([TO BE ADDED]) and questions:**
1. Team / organisation name and city, and the 5 members' names.
2. Exact internship start and end dates, and when work on the specification started (pre-internship).
3. AWS Pricing Calculator link — should we build it from the table in section 6?
4. Exchange rate for the ROI calculation (26,000 VND/USD is assumed).
5. Any Vietnam-specific e-waste figure you want to cite.
6. Measured time to create a listing with and without AI. If there is no data yet, should we run a small test with 5–10 users?
