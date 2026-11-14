---
title : "Giám sát với CloudWatch Logs, Alarms, SNS & Dashboard"
date : 2026-11-14
weight : 11
chapter : false
pre : " <b> 5.11. </b> "
---

Trong phần này bạn đặt thời gian lưu log gọn nhẹ (**7 ngày**), trích xuất metric từ log JSON lỗi, tạo kênh cảnh báo **SNS Email**, thiết lập **2 CloudWatch Alarms** và dựng Dashboard **`ReLoop2-Backend-Health`**.

![Phạm vi Phần 5.11: CloudWatch Logs, Alarms, SNS & Dashboard](/images/5-Workshop/5.11/architecture.png)

---

### Phần A — Giới hạn lưu Log 7 ngày & Tạo Metric Filter

1. Mở **CloudWatch -> Logs -> Log groups** (`ap-southeast-1`), chọn `/aws/lambda/reloop2-api`.

![Danh sách Log groups](/images/5-Workshop/5.11/01-log-groups.png)

2. Vào **Actions -> Edit retention setting(s)**, chọn **`1 week (7 days)`**.

![Đặt thời gian lưu log 7 ngày](/images/5-Workshop/5.11/02-log-retention-edit.png)

![Đã lưu thiết lập 7 ngày](/images/5-Workshop/5.11/03-log-retention-saved.png)

3. Mở `/aws/lambda/reloop2-api` -> **Metric filters -> Create metric filter**:
   - **Pattern:** `{ $.msg = "unhandled_error" }`
   - **Filter name:** `reloop2-UnhandledErrors`
   - **Namespace:** `ReLoop/reloop2`, **Metric:** `UnhandledErrors`, **Value:** `1`, **Default:** `0`

![Nhập mẫu lọc JSON unhandled_error](/images/5-Workshop/5.11/04-metric-filter-pattern.png)

![Đặt Namespace ReLoop/reloop2 và Metric UnhandledErrors](/images/5-Workshop/5.11/05-metric-filter-assign.png)

![Metric filter đã được tạo](/images/5-Workshop/5.11/06-metric-filter-created.png)

---

### Phần B — Tạo SNS Topic & Đăng ký Email Cảnh báo

4. Vào **Amazon SNS -> Topics -> Create topic**: kiểu **Standard**, tên **`reloop2-alarms`**, Display name `ReLoop 2 Alarms`.

![Tạo SNS topic reloop2-alarms](/images/5-Workshop/5.11/07-sns-create-topic.png)

![Đã tạo reloop2-alarms topic](/images/5-Workshop/5.11/08-sns-topic-created.png)

5. Bấm **Create subscription**: chọn **Protocol `Email`**, nhập địa chỉ nhận cảnh báo của bạn (`alerts@example.com`). Kiểm tra hộp thư và bấm link **Confirm subscription** để kích hoạt!

![Tạo đăng ký nhận email từ SNS](/images/5-Workshop/5.11/09-sns-create-subscription.png)

![Trạng thái Pending confirmation chờ xác nhận mail](/images/5-Workshop/5.11/10-sns-subscription-pending.png)

---

### Phần C — Tạo 2 Alarms & Dashboard `ReLoop2-Backend-Health`

6. Mở **CloudWatch -> Alarms -> Create alarm**:
   - **Alarm 1 (`reloop2-lambda-errors`):** `AWS/Lambda -> Errors` của `reloop2-api`, Sum 5 phút **`>= 3`**, Missing data `Not breaching`, gửi về `reloop2-alarms`.

![Chọn metric Errors của Lambda reloop2-api](/images/5-Workshop/5.11/11-alarm-lambda-metric.png)

![Đặt ngưỡng >= 3 trong 5 phút](/images/5-Workshop/5.11/12-alarm-lambda-conditions.png)

![Chọn kênh thông báo reloop2-alarms](/images/5-Workshop/5.11/13-alarm-lambda-notify.png)

![Đặt tên reloop2-lambda-errors](/images/5-Workshop/5.11/14-alarm-lambda-name.png)

   - **Alarm 2 (`reloop2-api-5xx`):** `AWS/ApiGateway -> 5xx` cho HTTP API của bạn, Sum 5 phút **`>= 5`**, gửi về `reloop2-alarms`.

![Cấu hình alarm HTTP API 5xx >= 5](/images/5-Workshop/5.11/15-alarm-api-5xx.png)

![Cả hai Alarm ở trạng thái OK](/images/5-Workshop/5.11/16-alarms-list.png)

7. Mở **CloudWatch -> Dashboards -> Create dashboard**, đặt tên **`ReLoop2-Backend-Health`** và thêm 3 biểu đồ theo dõi Lambda (`Invocations`, `Errors`, `Throttles`), HTTP API (`Count`, `4xx`, `5xx`), và DynamoDB (`ConsumedReadCapacityUnits`, `ConsumedWriteCapacityUnits`).

![Tạo Dashboard ReLoop2-Backend-Health](/images/5-Workshop/5.11/17-dashboard-create.png)

![Dashboard ReLoop2-Backend-Health hoàn chỉnh](/images/5-Workshop/5.11/18-dashboard-saved.png)
