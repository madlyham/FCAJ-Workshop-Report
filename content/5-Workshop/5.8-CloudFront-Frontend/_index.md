---
title : "Frontend SPA, CloudFront & Origin Access"
date : 2026-11-14
weight : 8
chapter : false
pre : " <b> 5.8. </b> "
---

In this module you host the React/Vite Single-Page Application (SPA) inside a completely private S3 bucket (`reloop2-web-7k3q`), expose both the frontend and `/api/*` under a single **Amazon CloudFront** HTTPS origin using **Origin Access Control (OAC)**, attach two lightweight **CloudFront Functions**, enforce strict **Security Headers**, lock direct API Gateway bypasses with `x-origin-verify`, and complete the **CORS + Cognito URL backfill**.

![Module 5.8 Focus: CloudFront, S3 Web Bucket, OAC, Functions & API Origin](/images/5-Workshop/5.8/architecture.png)

---

### Part A — Create Private Web Bucket (`reloop2-web-<suffix>`) & Upload Bundle

1. Open **S3 -> Create bucket** in **`ap-southeast-1`**, name it **`reloop2-web-7k3q`** (same unique suffix as `reloop2-images`), keep **Block all public access ON**, add tags, and keep **SSE-S3 + Bucket Key**.

![Name reloop2-web-7k3q bucket](/images/5-Workshop/5.8/01-s3-create-bucket-name.png)

![Keep Block all public access ON](/images/5-Workshop/5.8/02-s3-block-public-access.png)

![Tags and encryption on web bucket](/images/5-Workshop/5.8/03-s3-tags-create.png)

![reloop2-web-7k3q created](/images/5-Workshop/5.8/04-s3-bucket-created.png)

2. Build your React frontend (`npm run build`) with `VITE_COGNITO_USER_POOL_ID`, `VITE_COGNITO_CLIENT_ID`, `VITE_COGNITO_DOMAIN`, and `VITE_API_BASE=/api`, then upload `index.html` and the `assets/` folder into `reloop2-web-7k3q`.

![Select root bundle files to upload](/images/5-Workshop/5.8/05-s3-upload-files.png)

![Root upload succeeded](/images/5-Workshop/5.8/06-s3-upload-succeeded.png)

![Uploaded root files in S3](/images/5-Workshop/5.8/07-s3-objects-root.png)

![Upload assets folder contents](/images/5-Workshop/5.8/08-s3-upload-assets.png)

![Assets upload succeeded](/images/5-Workshop/5.8/09-s3-assets-succeeded.png)

---

### Part B — Create Two CloudFront Functions (`cloudfront-js-2.0`)

3. Go to **CloudFront -> Functions -> Create function** (runtime **`cloudfront-js-2.0`**):

![Create CloudFront Function dialog](/images/5-Workshop/5.8/10-cf-create-function.png)

- **Function 1: `reloop2-spa-rewrite`** — rewrites client-side React routes to `/index.html` ONLY when the URI does NOT end with a real static file extension (crucial for ReLoop chat routes formatted like `/chat/<partnerId>.<listingId>`, which contain a `.` but are not static files!):

```javascript
function handler(event) {
  var req = event.request;
  // Only real asset extensions pass; chat route "<partnerId>.<listingId>" also contains a dot
  if (!/\.(js|mjs|css|map|html|png|jpe?g|gif|svg|ico|webp|avif|txt|json|xml|webmanifest|woff2?|ttf)$/i.test(req.uri)) req.uri = '/index.html';
  return req;
}
```

![Code editor for reloop2-spa-rewrite](/images/5-Workshop/5.8/11-cf-spa-rewrite-code.png)

![Publish reloop2-spa-rewrite to LIVE](/images/5-Workshop/5.8/12-cf-spa-rewrite-published.png)

- **Function 2: `reloop2-api-prefix`** — strips the leading `/api` prefix before CloudFront forwards requests to HTTP API Gateway (`<api-id>.execute-api.ap-southeast-1.amazonaws.com`):

```javascript
function handler(event) {
  var req = event.request;
  req.uri = req.uri.replace(/^\/api(?=\/)/, '');
  return req;
}
```

![Code editor for reloop2-api-prefix](/images/5-Workshop/5.8/13-cf-api-prefix-code.png)

![Publish reloop2-api-prefix to LIVE](/images/5-Workshop/5.8/14-cf-api-prefix-published.png)

---

### Part C — Create Security Response Headers Policy & OAC

4. Go to **CloudFront -> Policies -> Response headers -> Create response headers policy**:
   - **Name:** `reloop2-security-headers`
   - **Security headers (all `Override` checked):**
     - `Strict-Transport-Security`: `max-age=31536000; includeSubDomains`
     - `X-Content-Type-Options`: `nosniff`
     - `X-Frame-Options`: `DENY`
     - `Referrer-Policy`: `strict-origin-when-cross-origin`
     - `Content-Security-Policy`: `frame-ancestors 'none'; object-src 'none'; base-uri 'self'; form-action 'self'`
   - **Custom header:** `Content-Security-Policy-Report-Only` (Override ON) allowing `'self'`, Google Fonts, S3 images bucket `reloop2-images-7k3q.s3.ap-southeast-1.amazonaws.com`, Cognito IDP & Hosted UI domain, and OpenStreetMap/Nominatim tiles.

![Configure standard browser security headers](/images/5-Workshop/5.8/15-cf-response-headers-security.png)

![Add custom CSP-Report-Only header](/images/5-Workshop/5.8/16-cf-response-headers-custom.png)

![Response headers policy created](/images/5-Workshop/5.8/17-cf-response-headers-created.png)

5. Go to **CloudFront -> Security -> Origin access -> Create control setting**:
   - **Name:** `reloop2-web`
   - **Signing behavior:** **Sign requests (recommended)** (`always`), **SigV4**, Origin type **S3**.

![Create Origin Access Control reloop2-web](/images/5-Workshop/5.8/18-cf-oac-create.png)

![Origin Access Control created](/images/5-Workshop/5.8/19-cf-oac-created.png)

---

### Part D — Create Distribution, Dual Origins & Dual Behaviors

6. Open **CloudFront -> Distributions -> Create distribution**:
   - Use **Pay as you go (`PriceClass_200`)**
   - Point first origin to `reloop2-web-7k3q.s3.ap-southeast-1.amazonaws.com` using OAC `reloop2-web`, default root object `index.html`, HTTP/2 + HTTP/3 (`http2and3`), IPv6 disabled (`is_ipv6_enabled = false`)
   - Choose **Do not enable security protections** during the initial wizard (we attach a customized rate-limited WAF in Module **5.9**!)

![Step 1 distribution pricing and name](/images/5-Workshop/5.8/20-cf-step1-get-started.png)

![Step 2 primary S3 origin with OAC](/images/5-Workshop/5.8/21-cf-step2-origin.png)

![Step 2 default cache settings](/images/5-Workshop/5.8/22-cf-step2-cache.png)

![Step 3 skip auto-generated WAF](/images/5-Workshop/5.8/23-cf-step3-no-auto-waf.png)

![Step 4 review and create distribution](/images/5-Workshop/5.8/24-cf-step4-review.png)

![CloudFront distribution created](/images/5-Workshop/5.8/25-cf-distribution-created.png)

7. Under **General -> Settings -> Edit**, verify **Default root object** is `index.html` and **Supported HTTP versions** is `HTTP/2 and HTTP/3`.

![Edit general distribution settings](/images/5-Workshop/5.8/26-cf-edit-settings.png)

8. Open the **Origins** tab and add the **second origin (`api`)**:
   - **Origin domain:** `<api-id>.execute-api.ap-southeast-1.amazonaws.com` (strip `https://`)
   - **Protocol:** `HTTPS only`, TLSv1.2 minimum, Read timeout `30s`, Keep-alive `5s`
   - **Add custom header:** `x-origin-verify` = `<exact ORIGIN_VERIFY_SECRET value from Lambda>`

![Origins tab before adding API origin](/images/5-Workshop/5.8/27-cf-origins-tab.png)

![Inspect S3 OAC origin settings](/images/5-Workshop/5.8/28-cf-origin-s3-oac.png)

![Configure API Gateway custom origin](/images/5-Workshop/5.8/29-cf-origin-api-top.png)

![Inject x-origin-verify custom header](/images/5-Workshop/5.8/30-cf-origin-api-header.png)

![Both S3 and API origins listed](/images/5-Workshop/5.8/31-cf-origins-both.png)

9. Open the **Behaviors** tab:
   - Edit **Default (`*`)** behavior: Redirect HTTP to HTTPS, `CachingOptimized`, Response headers policy `reloop2-security-headers`, and **Viewer request Function association -> `reloop2-spa-rewrite`**.
   - **Create behavior** for `/api/*` -> Target origin **`api`**: HTTPS only, Allowed methods `GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE`, Cache policy **`CachingDisabled`**, Origin request policy **`AllViewerExceptHostHeader`**, Response headers policy `reloop2-security-headers`, and **Viewer request Function association -> `reloop2-api-prefix`**.

![Attach reloop2-spa-rewrite and security headers to Default (*)](/images/5-Workshop/5.8/32-cf-behavior-default-fn.png)

![Create /api/* behavior targeting API origin](/images/5-Workshop/5.8/33-cf-behavior-api-top.png)

![Attach CachingDisabled, AllViewerExceptHostHeader, and api-prefix function](/images/5-Workshop/5.8/34-cf-behavior-api-policies.png)

![Both /api/* and Default (*) behaviors configured](/images/5-Workshop/5.8/35-cf-behaviors-both.png)

10. Copy CloudFront's generated **S3 bucket policy** and paste it into **`reloop2-web-7k3q -> Permissions -> Bucket policy`** (`CloudFrontRead` `s3:GetObject` + `CloudFrontList` `s3:ListBucket` scoped strictly with `StringEquals` on `AWS:SourceArn` of your CloudFront Distribution ARN).

![Paste CloudFront OAC bucket policy into reloop2-web-7k3q](/images/5-Workshop/5.8/36-s3-web-bucket-policy.png)

---

### Part E — Critical Backfill: Update CORS & Cognito URLs with CloudFront Domain

Now that your CloudFront domain (`https://<dist-domain>.cloudfront.net`) exists, immediately update all three downstream services so authentication and uploads work smoothly:

11. **Cognito (`reloop2-user-pool` -> App client `reloop2-web-client` -> Login pages):** append `https://<dist-domain>.cloudfront.net/auth/callback` and `https://<dist-domain>.cloudfront.net/`.

![Backfill Cognito callback and logout URLs](/images/5-Workshop/5.8/37-cognito-backfill-urls.png)

12. **S3 (`reloop2-images-7k3q` -> Permissions -> CORS):** append `"https://<dist-domain>.cloudfront.net"` to `AllowedOrigins`.

![Backfill CloudFront origin in S3 images CORS](/images/5-Workshop/5.8/38-s3-images-backfill-cors.png)

13. **API Gateway (`reloop2-api` -> Develop -> CORS):** append `https://<dist-domain>.cloudfront.net` to `Access-Control-Allow-Origin`.

![Backfill CloudFront origin in API Gateway CORS](/images/5-Workshop/5.8/39-apigw-backfill-cors.png)

14. Run an **Invalidation (`/*`)** on your CloudFront distribution so edge caches pick up the fresh bundle and headers right away.

![Create /* CloudFront invalidation](/images/5-Workshop/5.8/40-cf-invalidation-create.png)

![CloudFront invalidation completed](/images/5-Workshop/5.8/41-cf-invalidation-created.png)
