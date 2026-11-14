---
title : "Observability: Logs, Alarms, SNS & Dashboard"
date : 2026-11-14
weight : 11
chapter : false
pre : " <b> 5.11. </b> "
---

In this module you establish cost-controlled logging (**7-day retention**), extract a structured metric from Lambda JSON error logs, wire **SNS** email alerts, configure two actionable **CloudWatch Metric Alarms**, and assemble the **`ReLoop2-Backend-Health`** dashboard.

![Module 5.11 Focus: CloudWatch Logs, Metric Filters, Alarms, SNS & Dashboard](/images/5-Workshop/5.11/architecture.png)

---

### Part A — Set 7-Day Log Retention & Create Error Metric Filter

1. Open **CloudWatch -> Logs -> Log groups** (`ap-southeast-1`) and select `/aws/lambda/reloop2-api`.

![CloudWatch Log groups list](/images/5-Workshop/5.11/01-log-groups.png)

2. Click **Actions -> Edit retention setting(s)** -> set **`1 week (7 days)`** so workshop logs never accumulate storage indefinitely.

![Set log retention to 7 days](/images/5-Workshop/5.11/02-log-retention-edit.png)

![7-day log retention saved](/images/5-Workshop/5.11/03-log-retention-saved.png)

3. Open `/aws/lambda/reloop2-api` -> **Metric filters -> Create metric filter**:
   - **Filter pattern:** `{ $.msg = "unhandled_error" }`
   - **Filter name:** `reloop2-UnhandledErrors`
   - **Metric namespace:** `ReLoop/reloop2`
   - **Metric name:** `UnhandledErrors`
   - **Metric value:** `1`, **Default value:** `0`

![Configure JSON filter pattern](/images/5-Workshop/5.11/04-metric-filter-pattern.png)

![Assign metric namespace and name](/images/5-Workshop/5.11/05-metric-filter-assign.png)

![UnhandledErrors metric filter active](/images/5-Workshop/5.11/06-metric-filter-created.png)

---

### Part B — Create SNS Alert Topic & Email Subscription

4. Open **Amazon SNS -> Topics -> Create topic**:
   - **Type:** **Standard**
   - **Name:** `reloop2-alarms`
   - **Display name:** `ReLoop 2 Alarms`

![Create Standard SNS topic reloop2-alarms](/images/5-Workshop/5.11/07-sns-create-topic.png)

![reloop2-alarms topic created](/images/5-Workshop/5.11/08-sns-topic-created.png)

5. Click **Create subscription**:
   - **Protocol:** `Email`
   - **Endpoint:** `alerts@example.com` (your real inbox; check your email and click **Confirm subscription** so SNS changes state from `Pending confirmation` to `Confirmed`!)

![Create Email SNS subscription](/images/5-Workshop/5.11/09-sns-create-subscription.png)

![Subscription showing Pending confirmation](/images/5-Workshop/5.11/10-sns-subscription-pending.png)

---

### Part C — Create 2 CloudWatch Alarms & Operational Dashboard

6. Open **CloudWatch -> Alarms -> Create alarm**:
   - **Alarm 1 (`reloop2-lambda-errors`):** Metric `AWS/Lambda -> Errors` (`FunctionName = reloop2-api`), Statistic `Sum`, Period `5 minutes`, Condition **`>= 3`** (`1 of 1` datapoints), Treat missing data as **Not breaching** (`notBreaching`), Notify **`reloop2-alarms`**.

![Select Lambda Errors metric](/images/5-Workshop/5.11/11-alarm-lambda-metric.png)

![Set threshold >= 3 in 5 minutes and notBreaching](/images/5-Workshop/5.11/12-alarm-lambda-conditions.png)

![Attach reloop2-alarms SNS notification](/images/5-Workshop/5.11/13-alarm-lambda-notify.png)

![Name alarm reloop2-lambda-errors](/images/5-Workshop/5.11/14-alarm-lambda-name.png)

   - **Alarm 2 (`reloop2-api-5xx`):** Metric `AWS/ApiGateway -> 5xx` (`ApiId = <your HTTP API ID>`), Statistic `Sum`, Period `5 minutes`, Condition **`>= 5`**, Notify **`reloop2-alarms`**.

![Configure API Gateway 5xx >= 5 alarm](/images/5-Workshop/5.11/15-alarm-api-5xx.png)

![Both alarms listed in OK state](/images/5-Workshop/5.11/16-alarms-list.png)

7. Open **CloudWatch -> Dashboards -> Create dashboard**, name it **`ReLoop2-Backend-Health`**, and add 3 widgets:
   - **Lambda API (`reloop2-api`)**: `Invocations`, `Errors`, `Throttles` (Sum, 5 min line chart)
   - **HTTP API (`<api-id>`)**: `Count`, `4xx`, `5xx` (Sum, 5 min line chart)
   - **DynamoDB Capacity (`reloop2-core-table`)**: `ConsumedReadCapacityUnits`, `ConsumedWriteCapacityUnits` (Number sparkline)

![Create ReLoop2-Backend-Health dashboard](/images/5-Workshop/5.11/17-dashboard-create.png)

![Saved ReLoop2-Backend-Health dashboard layout](/images/5-Workshop/5.11/18-dashboard-saved.png)
