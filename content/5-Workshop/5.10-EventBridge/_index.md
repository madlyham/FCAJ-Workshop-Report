---
title : "Automated Background Sweeps with EventBridge"
date : 2026-11-14
weight : 10
chapter : false
pre : " <b> 5.10. </b> "
---

ReLoop runs scheduled maintenance inside the same `reloop2-api` Lambda every **15 minutes** without extra servers or SQS queues: closing expired 7-day listings, dispatching 24-hour pickup reminders, and auto-completing unconfirmed 48-hour handoffs using `TIMER#<timestamp>` items stored in `reloop2-core-table`.

![Module 5.10 Focus: Amazon EventBridge Scheduled Sweep](/images/5-Workshop/5.10/architecture.png)

---

### Step 1 — Create Scheduled Rule `reloop2-sweep`

1. In **`ap-southeast-1`**, open **Amazon EventBridge -> Rules** (`default` bus) and click **Create rule**.

![EventBridge Rules list](/images/5-Workshop/5.10/01-eventbridge-rules-list.png)

2. Configure **Define rule detail**:
   - **Name:** `reloop2-sweep`
   - **Description:** `ReLoop 2: expire listings, send 24h reminders, auto-complete 48h`
   - **Event bus:** `default`
   - **Rule type:** **Schedule** -> continue in EventBridge Rule (`rate(15 minutes)` standard scheduled rule).

![Configure rule name and description](/images/5-Workshop/5.10/02-rule-detail.png)

3. Set **Schedule pattern**:
   - **Schedule pattern:** Rate-based schedule -> **`15` Minutes** (`rate(15 minutes)`)

![Set 15-minute schedule rate](/images/5-Workshop/5.10/03-schedule-rate.png)

4. Under **Select target(s)**:
   - **Target type:** AWS service
   - **Select a target:** **Lambda function**
   - **Function:** `reloop2-api`

![Target reloop2-api Lambda function](/images/5-Workshop/5.10/04-select-target-lambda.png)

5. Review and click **Create rule**, then confirm `reloop2-sweep` shows **Enabled**.

![Review EventBridge rule configuration](/images/5-Workshop/5.10/05-rule-review.png)

![reloop2-sweep rule created and Enabled](/images/5-Workshop/5.10/06-rule-created.png)

6. Open **AWS Lambda -> `reloop2-api` -> Configuration -> Triggers** to verify EventBridge automatically appears as an active trigger backed by a resource policy from `events.amazonaws.com`.

![EventBridge trigger visible on reloop2-api Lambda](/images/5-Workshop/5.10/07-lambda-trigger-eventbridge.png)
