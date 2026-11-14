---
title : "S3 Private Images, CORS & Lifecycle"
date : 2026-11-14
weight : 5
chapter : false
pre : " <b> 5.5. </b> "
---

Uploaded device photos go directly from the user's browser to a private **Amazon S3** bucket (`reloop2-images-<suffix>`, e.g. `reloop2-images-7k3q`) via short-lived presigned URLs issued by Lambda. **Block All Public Access** stays enabled so photos cannot be listed or hotlinked outside controlled presigned URLs, while CORS allows browser uploads and S3 Lifecycle rules automatically purge abandoned `pending` uploads and incomplete multipart uploads.

![Module 5.5 Focus: Private S3 Media Bucket](/images/5-Workshop/5.5/architecture.png)

---

### Step 1 — Create Private Bucket `reloop2-images-<suffix>`

1. Open **Amazon S3 -> Buckets** in **`ap-southeast-1`** and click **Create bucket**.

![Amazon S3 buckets list](/images/5-Workshop/5.5/01-s3-buckets.png)

2. Configure **General configuration**:
   - **AWS Region:** `ap-southeast-1`
   - **Bucket type:** General purpose
   - **Bucket name:** `reloop2-images-7k3q` (replace `7k3q` with your own globally unique 4-character suffix)

![Create reloop2-images bucket](/images/5-Workshop/5.5/02-create-bucket-form.png)

3. Leave **Block all public access** checked (`ON`) — never expose raw user photos via public bucket policies.

![Keep Block all public access enabled](/images/5-Workshop/5.5/03-block-public-access.png)

4. Add workshop tags (`Owner=team`, `Project=reloop2`, `Purpose=workshop`), keep **SSE-S3 (`AES256`)** with **Bucket Key Enabled**, and click **Create bucket**.

![Encryption and tags configuration](/images/5-Workshop/5.5/04-tags-encryption.png)

![reloop2-images-7k3q created](/images/5-Workshop/5.5/05-bucket-created.png)

---

### Step 2 — Configure CORS for Direct Browser Uploads

5. Open `reloop2-images-7k3q` -> **Permissions** -> scroll to **Cross-origin resource sharing (CORS)** -> click **Edit** and paste (we start with `http://localhost:5173`, then append our CloudFront origin in Module **5.8**):

```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["PUT", "POST", "GET"],
    "AllowedOrigins": ["http://localhost:5173"],
    "ExposeHeaders": ["ETag"]
  }
]
```

![Edit S3 CORS JSON](/images/5-Workshop/5.5/06-cors-edit.png)

![S3 CORS configuration saved](/images/5-Workshop/5.5/07-cors-saved.png)

---

### Step 3 — Add 3 Cost-Control Lifecycle Rules

6. Open **Management -> Lifecycle rules** -> click **Create lifecycle rule** for each rule below:

| Rule Name | Scope / Filter | Action |
| --- | --- | --- |
| `reloop2-listing-images-unattached` | Prefix `listings/` AND object tag `state = pending` | Expire current versions after **1 day** |
| `reloop2-listing-images-retention` | Prefix `listings/` (all attached photos) | Expire current versions after **90 days** |
| `reloop2-abort-incomplete-uploads` | Prefix `listings/` | Abort incomplete multipart uploads after **1 day** |

![Rule 1: Expire unattached pending images after 1 day](/images/5-Workshop/5.5/08-lifecycle-unattached.png)

![Rule 2: 90-day retention under listings/](/images/5-Workshop/5.5/09-lifecycle-retention.png)

![Rule 3: Abort incomplete multipart uploads](/images/5-Workshop/5.5/10-lifecycle-abort-uploads.png)

7. Confirm all **3 lifecycle rules** show status **Enabled** under **Management -> Lifecycle rules**.

![All 3 S3 lifecycle rules active](/images/5-Workshop/5.5/11-lifecycle-rules-list.png)
