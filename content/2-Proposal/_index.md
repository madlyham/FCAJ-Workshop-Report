---
title: "Proposal"
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# RELOOP
## An AI-assisted marketplace for used and broken electronics, built serverless on AWS

### 1. Executive Summary
ReLoop is a web marketplace where people in Vietnam sell used or broken electronics (phones, laptops, monitors, components) to nearby repair shops, buyers, and recyclers. It is built by **AWSS3nt1n4L**, a 5-person team in the AWS First Cloud Journey (FCAJ) program in Ho Chi Minh City, during a 12-week internship (14/09–04/12/2026). A seller uploads device photos, and Amazon Bedrock pre-fills the listing details. The listing is then matched to every approved buyer whose branch service area (1–15 km) covers the seller, and the deal closes through a buyer quote or a price agreed in chat.

On 08/11/2026, the live environment had 14 registered accounts, 12 active listings from 7 sellers, and roughly 31,000 API requests in its first month. The serverless design scales automatically without re-architecture, with Lambda concurrency approved up to 1,000. The platform uses 12 managed AWS services: **CloudFront, AWS WAF, S3, Cognito, API Gateway, Lambda, DynamoDB, Rekognition, Bedrock, EventBridge, CloudWatch, and SNS**. Guests browse the public market without an account, signed-in users (`Owners`) chat and buy, Admin-approved `Partners` post listings and quotes, and `Admins` / `FinanceAdmins` moderate flagged content and handle monthly fee invoices.

#### Team

| Member | Role |
|---|---|
| Kung Cẩm Thành | Team Lead |
| Hoàng Quốc Việt | Tech Lead |
| Trần Hoàng Quốc Trung | Backend Engineer |
| Nguyễn Duy Quang | Frontend Engineer |
| Nguyễn Anh Kỳ | Cyber-security / Documentation |

### 2. Problem Statement
#### What's the Problem?
The Global E-waste Monitor 2024 (UNITAR/ITU) reports that the world generated 62 million tonnes of e-waste in 2022, and only 22.3% was formally collected and recycled. The same report estimates that Vietnam generated about 516,000 tonnes (≈5.3 kg per person) in 2022. Owners of an old or broken device rarely know who will buy it or what it is worth. Today they post on general classifieds sites or social groups, describe the device by hand, call shops one by one, and often get no answer. General marketplaces such as Chợ Tốt or Facebook Marketplace are built for all kinds of goods and do not:
- match a listing to repair shops whose service area covers the seller,
- show a price estimate generated from each buyer's own pricing rules, or
- maintain a reputation record that rewards buyers who honour their quotes.

Small repair shops face the same gap from the other side: they have no low-cost channel to receive nearby devices that match what they buy.

#### The Solution
ReLoop runs end to end on managed serverless AWS services with zero servers to operate:
- **Photo Ingest:** the browser uploads up to 6 photos per listing (JPEG/PNG/WebP, max 5 MB each) straight to a private Amazon S3 bucket via short-lived presigned POST URLs. Amazon Rekognition checks every photo for unsafe content and reads text printed on device labels. Amazon Bedrock Guardrails screens that text so prompt-injection attempts and unsafe content are flagged for Admin review.
- **API & AI Processing:** one AWS Lambda function (Node.js 22, arm64) behind Amazon API Gateway serves 111 API routes and also invokes itself asynchronously for slower tasks:
  - AI photo analysis with Kimi K3 on Amazon Bedrock (about 35 seconds per run, reading up to 3 photos to pre-fill listing fields);
  - geohash + Haversine matching of listings to nearby buyer branches.

  Amazon EventBridge triggers the same function every 15 minutes to expire open listings past their 7-day window.
- **Storage:** a single on-demand Amazon DynamoDB table (partition/sort key + one Global Secondary Index) stores every entity: users, partners, branches, pricing rules, listings, quotes, transactions, chats, reviews, expiration timers, invoices, and audit logs. Conditional writes and an `Idempotency-Key` on fee-related APIs prevent duplicate or conflicting updates. S3 lifecycle rules delete unattached photos after 1 day and expire listing photos after 90 days.
- **Web Interface:** a React single-page app served from a private S3 bucket through Amazon CloudFront, providing a public market, a two-tier partner portal, and an Admin portal.
- **Security:** Amazon Cognito handles sign-up and sign-in across four groups (`Admins`, `FinanceAdmins`, `Partners`, and `Owners`), firing a Post-confirmation Lambda to create each user profile. API Gateway validates Cognito JWT tokens on every protected route. A CloudFront-attached AWS WAF web ACL applies AWS managed rules and per-IP rate limits, while a shared `x-origin-verify` secret header blocks direct calls to API Gateway. Separate least-privilege IAM roles restrict each Lambda function to only the resources it needs.

Compared with general classifieds, ReLoop adds AI-filled listings, service-area matching, rule-based price estimates, two-step completion (seller confirms the final price, buyer accepts), and two-way reviews. ReLoop does not hold funds: buyer and seller settle payment directly in person at hand-over.

#### Benefits and Return on Investment
- **Less manual effort:** AI suggests title, category, brand, model, and condition from up to 3 uploaded photos, leaving the seller to review or adjust. Creating a listing drops from roughly 5 minutes by hand to under 1 minute (team estimate).
- **Fewer unanswered listings:** every new listing automatically routes to all buyer branches in range, ranking buyers within 5 km first.
- **Reliability:** explicit state machines, conditional DynamoDB writes, and idempotent background sweeps keep listings, quotes, and transactions consistent. The codebase is backed by 182 automated tests and full end-to-end live verification on AWS.
- **Learning value:** the team gained hands-on experience with single-table DynamoDB design, event-driven Lambda, Amazon Bedrock structured tool output and Guardrails, CloudFront WAF tuning, and Terraform Infrastructure as Code.
- **Cost:** about **11.70 USD/month (140.40 USD/year)** at the current scale (Section 6). **10.00 USD** of that is the CloudFront AWS WAF web ACL, so without WAF the platform costs about **1.70 USD/month**. Until 28/02/2027, the account's remaining credits (**189.80 USD** observed on 21/11/2026) cover the entire run at zero cash cost.
- **Payback:** revenue is 10,000 VND per completed transaction, paid by the seller. At an approximate rate of 1 USD ≈ 26,000 VND (November 2026), 11.70 USD ≈ 304,200 VND. The platform breaks even at **31 completed transactions per month**, or **5 per month** without WAF.

### 3. Solution Architecture
ReLoop runs fully serverless in **Asia Pacific (Singapore) `ap-southeast-1`**, protected globally at the edge by Amazon CloudFront and AWS WAF.

![ReLoop Serverless Architecture on AWS](/images/5-Workshop/5.1/overview.png)

#### End-to-End Request Flow (Arrows 1 → 10)
1. **Users → CloudFront (`HTTPS (TLS)`):** browsers connect over HTTPS to CloudFront. **AWS WAF** sits attached as an associated web ACL to block malicious IPs, common exploits, and abusive request rates.
2. **CloudFront → S3 Website (`static files (OAC)`):** CloudFront fetches the private React single-page app from S3 through Origin Access Control (OAC) and rewrites SPA routes at the edge.
3. **Users → Cognito (`sign up / sign in`):** users register and sign in directly with Amazon Cognito. On email confirmation, Cognito triggers **AWS Lambda (Post-confirm)** to create the initial user profile in DynamoDB.
4. **CloudFront → API Gateway (`/api/* + x-origin-verify`):** requests under `/api/*` strip the `/api` prefix at CloudFront and forward to API Gateway with a shared `x-origin-verify` secret header so direct bypass calls are rejected.
5. **API Gateway → Lambda (API) (`invoke`):** API Gateway verifies Cognito JWTs against the user pool JWKS on every private route and invokes the main Node.js 22 API Lambda.
6. **Lambda (API) ↔ DynamoDB (`read/write users, listings & invoices`):** Lambda reads and writes users, partner branches, listings, quotes, chats, expiration timers, and monthly fee invoices in a single on-demand table.
7. **Lambda (API) ↔ S3 Photos (`presign & tag`):** Lambda issues short-lived presigned upload/view URLs and tags photos by moderation and attachment state.
8. **Users ↔ S3 Photos (`upload / view photos`):** browsers upload and load device photos directly against private S3 using presigned URLs — never proxying binary files through Lambda.
9. **Lambda (API) ↔ Rekognition (`image moderation`):** Lambda checks uploaded photos for unsafe content and extracts visible text from device labels and stickers.
10. **Lambda (API) ↔ Bedrock (`AI analysis + Guardrail`):** Lambda screens extracted text through **Amazon Bedrock Guardrail** and invokes **Kimi K3** on Bedrock in `ap-southeast-1` to return structured JSON listing suggestions.

**Background & Operations Paths:**
- **EventBridge → Lambda (API) (`expire listings every 15 min`):** a 15-minute schedule sweeps due timer partitions and expires stale open listings automatically.
- **Lambda (API) → CloudWatch (`logs & metrics`) → SNS (`alarm → email Admin`):** structured Lambda logs retain 7 days of history, and a metric alarm emails Admins via SNS whenever Lambda errors cross the threshold.

#### AWS Services Used
- **Amazon CloudFront:** global HTTPS distribution serving the private React web app from S3 via OAC and routing `/api/*` to API Gateway with the `x-origin-verify` secret header.
- **AWS WAF:** 1 CloudFront-scoped web ACL (`associated web ACL`) combining 3 AWS managed rule groups (IP Reputation, Known Bad Inputs, Common Rule Set) with 2 per-IP rate limits returning `429` (100 req/min on the public API; 1,000 req/min overall).
- **Amazon S3:** 2 private buckets (Block Public Access enabled) — one for the static web bundle (OAC-only) and one for device photos (presigned POST/GET with 1-day unattached and 90-day lifecycle expiry).
- **Amazon Cognito:** Essentials user pool with email verification, Auth Code PKCE, and 4 groups (`Admins`, `FinanceAdmins`, `Partners`, `Owners`). The browser communicates with Cognito directly; a post-confirmation trigger invokes the Post-confirm Lambda to write the user profile to DynamoDB. Currently holds 14 users.
- **Amazon API Gateway (HTTP API):** enforces Cognito JWT authorization (JWKS) on private routes and throttles traffic at 20 requests/s (burst 50).
- **AWS Lambda:** 2 functions in `ap-southeast-1`:
  - **API Lambda** (Node.js 22, arm64/Graviton, 512 MB): serves 111 API routes, async AI/matching work, and scheduled sweeps. Average duration is 144 ms; concurrency quota is 1,000.
  - **Post-confirm Lambda** (Python 3.12): writes the initial user profile to DynamoDB upon Cognito confirmation.
- **Amazon DynamoDB:** 1 on-demand table (`PK`/`SK` + `GSI1`) with Point-in-Time Recovery (PITR) and Time-to-Live (TTL) enabled, holding about 5,600 items (2.4 MB).
- **Amazon Rekognition:** runs content moderation labels (rejecting explicit photos and escalating borderline cases to Admin) and text detection on every uploaded photo.
- **Amazon Bedrock:** runs in `ap-southeast-1`. A Standard-tier **Guardrail** (`apac.guardrail.v1:0`) screens text read from photos against prompt attacks and unsafe content, and **Kimi K3** (`global.moonshotai.kimi-k3`) via the Converse API returns structured JSON listing fields. Output is validated against a strict backend schema, and each user is capped at 20 AI analyses/day.
- **Amazon EventBridge:** 1 scheduled rule every 15 minutes (`rate(15 minutes)`) triggering the listing-expiry sweep.
- **Amazon CloudWatch:** 7-day log retention on the API Lambda log group and a metric alarm monitoring API Lambda errors (threshold ≥ 3 errors in 5 minutes).
- **Amazon SNS:** sends email alerts to Admins whenever the CloudWatch alarm enters the `ALARM` state.
- **AWS IAM:** 2 separate least-privilege execution roles — one scoped to DynamoDB profile writes for the Post-confirm Lambda, and one scoped strictly to the core table, photo bucket prefix, Rekognition, Bedrock model & Guardrail, and CloudWatch Logs for the API Lambda.

#### Service Selection Rationale

| Chosen AWS Services | Alternative Considered | Why Chosen (Cost · Scalability · Availability & Operations) |
|---|---|---|
| **API Gateway (HTTP API) + Lambda (`arm64` Graviton)** | Amazon EC2 or Amazon ECS | **$0 when idle** (Always Free 1M requests + 400,000 GB-s/month) and Graviton `arm64` saves ~20% on compute vs `x86_64`; auto-scales to **1,000 concurrency** with built-in Multi-AZ high availability and zero OS patching. |
| **Amazon DynamoDB On-Demand (Single-Table)** | Amazon RDS (MySQL/PostgreSQL) | No 24/7 database instance bill (**~$0.10/month** at current traffic); instant pay-per-request scaling; built-in Multi-AZ replication plus native **PITR (35 days)** and **TTL** expiry. |
| **Amazon S3 + CloudFront (OAC) + Presigned URLs** | Proxying uploads through backend or public buckets | **11 nines (`99.999999999%`) durability**; keeps photo bytes off Lambda (avoiding payload limits and memory cost); **1 TB + 10M requests/month** CloudFront Free Tier; strict private buckets via OAC and short-lived presigned URLs. |
| **Amazon Cognito + Rekognition + Bedrock (Kimi K3 & Guardrail)** | Self-built auth + self-hosted GPU models | Fully managed pay-per-use (Cognito free up to **10,000 MAU**, zero idle GPU cost); built-in JWT/JWKS authentication, automated image moderation, and **Bedrock Guardrail** protection against prompt injection. |
| **AWS WAF (CloudFront) + EventBridge + CloudWatch / SNS** | Self-managed reverse proxy, cron server & monitoring stack | Managed edge rate limits & OWASP rules with zero proxy upkeep; serverless 15-minute scheduler and Free Tier logs, metric alarm, and admin email notifications. |

#### Component Design
- **Edge / Client:** a React 18 + TypeScript single-page app (Vite) using Leaflet + OpenStreetMap for location picking. Guests browse the public market; signed-in users access the partner portal (Tier 1 individual sellers: max 3 open listings; Tier 2 business buyers with branches, pricing rules, and quotes: max 10) or the Admin portal.
- **Photo Ingestion:**
  1. `POST /uploads/presign` returns a 5-minute presigned POST URL so the browser uploads directly to private S3.
  2. `POST /uploads/moderate` runs Rekognition moderation and text extraction, tagging safe images as passed.
  3. Creating a listing tags its photos as attached so the 1-day cleanup lifecycle rule keeps them until the 90-day expiry.
- **Processing:** an HTTP router checks JWT claims, idempotency keys, and request payloads. Explicit state machines for Listing, Quote, and Transaction permit only valid state transitions. AI analysis and branch matching run asynchronously, while time-bucketed keys let the 15-minute EventBridge sweep find expiring listings without full table scans.
- **Storage:** all access patterns follow a centralized single-table key design with zero table scans. The market feed is partitioned by month with validated cursor pagination, and all currency values are stored as integer VND.
- **Web Interface:** public marketplace feed, per-listing chat (5-second polling) with price offers, a transaction drawer (schedule hand-over, adjust price, confirm, dispute), and two-way reviews.
- **User Management:** Cognito handles email-verified registration and group claims. Admins approve partner applications, and Finance Admins issue and settle monthly fee invoices. Sellers with invoices overdue by more than 3 days cannot post new listings; after 7 days overdue, the account is locked until settled.
- **Monitoring:** structured JSON Lambda logs with 7-day retention in CloudWatch Logs, paired with a Lambda error alarm connected to an SNS email topic for Admin alerts.

### 4. Technical Implementation
#### Implementation Phases
1. **Research & Architecture (28/09–08/10/2026 — Completed):** converted Specification v1.0 (1,189 paragraphs) into 45 documented business decisions (QĐ-01 → QĐ-45), mapped all DynamoDB single-table access patterns, and selected a unified serverless Lambda backend behind HTTP API Gateway.
2. **Cost Estimation & Feasibility (05/10–08/10/2026 — Completed, Proposal Part 1 submitted 08/10/2026):**
   - replaced online bank top-up/withdrawal with direct in-person payment at hand-over;
   - selected on-demand DynamoDB and arm64 Lambda to stay inside AWS Free Tier at low volume;
   - isolated every AWS call behind small adapter interfaces so developers run and test locally with zero AWS spend.
3. **Development & First AWS Deploy (09/10–23/10/2026 — Completed):** built the DynamoDB core table, S3 photo pipeline, Cognito sign-in + Post-confirm trigger, React web app, and Terraform IaC. Full market flow went live on AWS on 19/10, and the automated end-to-end AWS smoke test passed on 22/10.
4. **Architecture Refinement (26/10–06/11/2026 — Completed):**
   - rebuilt the UI from product designs and added the Admin portal;
   - moved AI analysis to Kimi K3 with Bedrock Guardrail in `ap-southeast-1` (28/10);
   - completed 5 QA rounds (146 findings resolved, 03/11);
   - raised Lambda concurrency from 10 to 1,000 and attached AWS WAF to CloudFront (06/11).
5. **Verification, Hardening & Hand-over (09/11–04/12/2026 — In Progress):**
   - *Completed (09/11–21/11):* Proposal Part 2 submitted (13/11), load-test re-run verifying API throttling (20 req/s, burst 50) with zero 5xx errors, standardized deployment workflow with per-member IAM users, and full streamlined Workshop rebuild + live end-to-end verification across Arrows 1 → 10.
   - *Remaining (23/11–04/12):* final unused-resource cleanup, final cost check against remaining credits, live demo rehearsal, and hand-over package.

#### Technical Requirements
- **Application Stack:** Node.js 22, TypeScript 5, React 18 + Vite 5, Leaflet, Cognito client SDK, AWS SDK v3, esbuild, Vitest; Python 3.12 for the Post-confirm Lambda and end-to-end verification scripts.
- **Infrastructure & CI:** Terraform ≥ 1.10 (AWS provider 6.x) and AWS CLI ≥ 2.32 for reproducible deployments; GitHub Actions runs typecheck, 182 automated tests, and the web build on every pull request.
- **Hardware:** developer laptops only; no on-premises hardware required.
- **Skills:** single-table DynamoDB modelling, least-privilege IAM, Bedrock prompt and Guardrail design, CloudFront WAF rule tuning, React SPA development, and automated testing with service fakes.

### 5. Timeline & Milestones

| Week | Dates | Status | Deliverables |
|---|---|---|---|
| Week 1 | 14/09–18/09 | Done | AWS foundations: account security, IAM, VPC, EC2; team onboarding |
| Week 2 | 21/09–26/09 | Done | Serverless basics (S3, DynamoDB, Lambda, API Gateway); Buildrathon kickoff, ReLoop selected (26/09) |
| Week 3 | 28/09–02/10 | Done | Specification v1.0 distilled into 45 business decisions (QĐ-01 → QĐ-45); repo + CI; team task split |
| Week 4 | 05/10–09/10 | Done | Architecture and DynamoDB access patterns; cost feasibility; Proposal Part 1 submitted (08/10); core table, Cognito sign-in, and React app started (09/10) |
| Week 5 | 12/10–16/10 | Done | Direct S3 photo upload, Rekognition moderation, first AI listing analysis prototype |
| Week 6 | 19/10–24/10 | Done | Terraform environment live; full market flow running on AWS (19/10); end-to-end smoke test passing (22/10); EventBridge 15-min sweep |
| Week 7 | 26/10–30/10 | Done | Redesigned UI (public market, partner portal, Admin portal); Rekognition text + Bedrock Guardrail; AI migrated to Kimi K3 (28/10) |
| Week 8 | 02/11–06/11 | Done | Async branch matching; 5 QA rounds (146 findings, 03/11); load test → Lambda concurrency raised to 1,000; AI cap 20/day; CloudFront WAF attached (06/11) |
| Week 9 | 09/11–13/11 | Done | Security review and hardening fixes deployed; Proposal Part 2 submitted with observed AWS costs (13/11) |
| Week 10 | 16/11–21/11 | Done | Load-test re-run after throttling tuning (20/s, burst 50); single deployment workflow with per-member IAM users; full live Workshop verification (Arrows 1 → 10) |
| Week 11 | 23/11–27/11 | Planned | Final resource audit, unused-asset cleanup, and cost verification against remaining credits |
| Week 12 | 30/11–04/12 | Planned | Final internship report, live demo, and hand-over documentation |
| Post-launch | 12/2026–02/2027 | Planned | Operate within remaining AWS credit window (until 28/02/2027); gather real AI accuracy and matching data |

### 6. Budget Estimation
The estimate uses AWS public list prices for **`ap-southeast-1` (Singapore)** (reproducible in the [AWS Pricing Calculator](https://calculator.aws/)). The line-by-line spreadsheet is in [reloop-cost-estimate.csv](/files/2-proposal/reloop-cost-estimate.csv).

#### Infrastructure Costs
Region: `ap-southeast-1` (Singapore) + global CloudFront edge. Usage assumptions reflect observed Cost Explorer and CloudWatch data (~31,000 API requests/month and 14 registered users).

| Service | USD / month | Assumption |
|---|---:|---|
| AWS WAF – CloudFront web ACL | 10.00 | 1 web ACL ($5.00) + 5 rules (5 × $1.00) + $0.60 per 1M requests |
| Amazon Bedrock (Kimi K3 + Guardrail) | 1.00 | Observed monthly usage (~$0.87), capped at 20 analyses/user/day |
| Amazon Rekognition | 0.30 | Content moderation + text detection for ~70–100 photos/month |
| Amazon DynamoDB (on-demand) | 0.10 | ~5,600 items, 2.4 MB, PITR enabled |
| Amazon API Gateway (HTTP API) | 0.10 | ~31,000 requests/month |
| Amazon S3 (website + photos) | 0.05 | Private web bundle + photos (1-day unattached / 90-day lifecycle) |
| Miscellaneous (data transfer, small items) | 0.15 | Buffer for minor transfer and usage line items |
| AWS Lambda (API + Post-confirm) | 0.00 | ~2,250 GB-s/month — Always Free (1M requests + 400,000 GB-s) |
| Amazon CloudFront | 0.00 | Always Free (1 TB transfer + 10M requests/month) |
| Amazon Cognito | 0.00 | 14 users — Free Tier up to 10,000 MAU |
| Amazon CloudWatch + SNS + EventBridge | 0.00 | 7-day logs, 1 alarm, SNS email alerts, 15-min rule — Free Tier |
| **Total per month** | **11.70** | |
| **Total for 12 months** | **140.40** | |

- **One-time hardware:** 0 USD.
- **Credits:** the account is on the AWS Free plan with **189.80 USD** in remaining credits (observed on 21/11/2026), valid until 28/02/2027. That easily covers the roughly 3.2 months remaining to expiry (≈ 38 USD at 11.70 USD/month) at zero cash cost.
- **Optional saving:** detaching the CloudFront WAF web ACL during idle periods lowers the bill to about **1.70 USD/month**, at the trade-off of removing edge rate limits and AWS managed exploit rules.
- *Prices reflect AWS public list prices for `ap-southeast-1` in November 2026 and may change. Usage-based lines scale proportionally with traffic.*

### 7. Risk Assessment
#### Risk Matrix

| Risk | Impact | Probability |
|---|---|---|
| R1. Two developers deploy conflicting code to the same Lambda function (observed 28/10/2026) | High | Medium |
| R2. Credits run out or an unexpected charge appears (Free-plan accounts suspend when credits exhaust) | High | Low |
| R3. Lambda or API throttling under traffic bursts (initial load test at concurrency 10 hit 26% 5xx under 80 parallel requests) | Medium | Medium |
| R4. AI misreads a device or encounters malicious prompt-injection text inside a photo | Medium | Medium |
| R5. Unauthorized access or abuse against the public web app, API, or private photo storage | High | Low |
| R6. Sellers and buyers close deals off-platform to avoid the transaction fee | Medium | High |
| R7. Cognito's default email limit (~50 emails/day) blocks sign-ups during a live demo | Medium | Medium |

#### Mitigation Strategies
- **R1:** use one deployment workflow from committed code revisions, issue separate IAM users per team member, and avoid root access keys.
- **R2:** size every paid service against remaining credits before enabling it, enforce the 20/user/day AI analysis cap, and review AWS Billing regularly.
- **R3:** Lambda concurrency is raised to 1,000; API Gateway throttling (20 req/s, burst 50) and CloudFront WAF rate limits return clean `429` responses instead of 5xx errors.
- **R4:** AI only suggests fields and the seller confirms every value before publishing. Rekognition text detection plus Bedrock Guardrail flag suspicious photo text for Admin review.
- **R5:** CloudFront WAF applies AWS managed rules and rate limits; private S3 buckets enforce OAC and presigned URLs; API Gateway requires both the CloudFront `x-origin-verify` secret header and valid Cognito JWTs; Lambda roles follow least privilege.
- **R6:** a cancellation-removal fee applies when a listing is pulled within 72 hours of a cancelled transaction, fee appeals route to Finance Admin, and repeat offenders are flagged.
- **R7:** plan migration to a custom email sender before opening public registration beyond small demos.

#### Contingency Plans
- **Bad deploy:** redeploy the last known-good revision via Terraform and static web sync; preview exact changes with `terraform plan` first.
- **Cost spike:** detach the CloudFront WAF web ACL and lower the daily AI analysis cap immediately.
- **Bedrock unavailable:** AI pre-fill is optional; sellers can still complete the form manually and publish listings without interruption.
- **WAF blocks legitimate users:** adjust the rule or rate threshold directly on the CloudFront WAF web ACL — takes effect at the edge without an application release.
- **Data corruption or accidental deletion:** restore DynamoDB using Point-in-Time Recovery (up to 35 days back); device photos can be re-uploaded by sellers.

### 8. Expected Outcomes
#### Technical Improvements
- A complete, live serverless marketplace on AWS: 111 API routes, 3 user portals, 182 automated tests, and verified end-to-end execution across all 10 architecture flows.
- Fully reproducible infrastructure running at roughly **11.70 USD/month** (**under 1 USD/month** for variable compute, database, API, and storage usage at current volume).
- Clear defense-in-depth baseline: CloudFront WAF protection, private S3 storage (OAC + presigned URLs), `x-origin-verify` origin isolation, Cognito JWT verification, and Rekognition + Bedrock Guardrail photo screening.
- Responsive backend performance: average Lambda duration of 144 ms, backed by 7-day CloudWatch Logs and automated SNS error alerts.

#### Long-term Value
- Storing every AI suggestion alongside the seller's confirmed values builds a labelled dataset for evaluating and improving device recognition over time.
- The adapter-based backend design allows swapping or adding services (such as custom email delivery, WebSocket chat, or bank payment APIs) without rewriting core business rules.
- The same Terraform modules can spin up separate production environments or expand to other cities, as geohash branch matching is location-agnostic.
- Local repair shops and recyclers gain a reliable neighborhood channel for used electronics, keeping more devices in reuse and formal recycling instead of household storage.
