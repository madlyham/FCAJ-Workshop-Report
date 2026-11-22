---
title : "Scheduled Sweeps: Amazon EventBridge"
date : 2026-11-21
weight : 9
chapter : false
pre : " <b> 5.9. </b> "
---

Add the scheduled background arrow on the diagram: **Amazon EventBridge** wakes up `reloop2-api` every 15 minutes to query `TIMER#` partitions in DynamoDB and automatically expire open listings past their 7-day window.

**Graph arrow covered in this step:**
- **Supporting link:** `Amazon EventBridge → AWS Lambda (API)` (`expire listings every 15 min`)

![Module 5.9 Focus: Scheduled Sweeps — Amazon EventBridge](/images/5-Workshop/5.9/architecture.png)

---

### Step 1 — Create Scheduled Rule `reloop2-sweep`

1. Open **Amazon EventBridge -> Buses -> Rules -> Create rule** in **`ap-southeast-1`**.
2. Configure:
   - **Name:** `reloop2-sweep`
   - **Description:** `ReLoop: expire listings every 15 min`
   - **Event bus:** `default`
   - **Rule type:** **`Schedule`** -> **Continue in EventBridge Rule**
   - **Schedule pattern:** **Fixed rate of `15` `Minutes`** (`rate(15 minutes)`)
3. Under **Select target(s)**:
   - **Target type:** `AWS service` -> **`Lambda function`**
   - **Function:** `reloop2-api`
   - *(The Console automatically attaches the resource-based invoke permission for `events.amazonaws.com` on `reloop2-api`.)*
4. Click **Create rule** and verify status is **Enabled**.

![EventBridge scheduled rule reloop2-sweep enabled at a 15-minute rate](/images/5-Workshop/5.9/01-eventbridge-rule.png)

5. Open **AWS Lambda -> `reloop2-api` -> Configuration -> Triggers** and verify both diagram callers — **API Gateway** and **EventBridge** — appear in the function diagram.

![Lambda reloop2-api Triggers view showing API Gateway and EventBridge](/images/5-Workshop/5.9/02-lambda-eventbridge-trigger.png)

{{% notice tip %}}
**The EventBridge sweep arrow is active.** Next, build the final pink box in [Module 5.10 — Monitoring & Alerts: CloudWatch & SNS](../5.10-monitoring/).
{{% /notice %}}
