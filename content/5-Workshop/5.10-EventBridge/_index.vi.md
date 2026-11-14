---
title : "Lịch quét Tự động với EventBridge"
date : 2026-11-14
weight : 10
chapter : false
pre : " <b> 5.10. </b> "
---

ReLoop thực thi bảo trì định kỳ **15 phút một lần** ngay trong hàm Lambda `reloop2-api`: đóng các tin đăng quá 7 ngày, gửi nhắc nhở lịch hẹn 24h và tự động hoàn tất giao dịch quá 48h dựa trên các bản ghi `TIMER#<timestamp>` lưu trong `reloop2-core-table`.

![Phạm vi Phần 5.10: Amazon EventBridge Scheduled Sweep](/images/5-Workshop/5.10/architecture.png)

---

### Bước 1 — Tạo Scheduled Rule `reloop2-sweep`

1. Tại **`ap-southeast-1`**, mở **Amazon EventBridge -> Rules** (Event bus `default`), bấm **Create rule**.

![Danh sách EventBridge Rules](/images/5-Workshop/5.10/01-eventbridge-rules-list.png)

2. Điền thông tin chi tiết:
   - **Name:** `reloop2-sweep`
   - **Description:** `ReLoop 2: expire listings, send 24h reminders, auto-complete 48h`
   - **Rule type:** **Schedule** -> chọn tiếp tục bằng standard scheduled rule.

![Nhập tên và mô tả cho rule reloop2-sweep](/images/5-Workshop/5.10/02-rule-detail.png)

3. Đặt lịch **Schedule pattern** chạy cố định mỗi **`15` phút** (`rate(15 minutes)`).

![Đặt tần suất 15 phút một lần](/images/5-Workshop/5.10/03-schedule-rate.png)

4. Ở bước **Select target(s)**, chọn **AWS service -> Lambda function -> `reloop2-api`**.

![Chọn Lambda reloop2-api làm đích gọi](/images/5-Workshop/5.10/04-select-target-lambda.png)

5. Kiểm tra lại thông số và bấm **Create rule**, xác nhận trạng thái **Enabled**.

![Xem lại cấu hình trước khi tạo rule](/images/5-Workshop/5.10/05-rule-review.png)

![Rule reloop2-sweep đã kích hoạt](/images/5-Workshop/5.10/06-rule-created.png)

6. Mở **Lambda -> `reloop2-api` -> Configuration -> Triggers** để kiểm tra trigger EventBridge đã tự gắn thành công (kèm quyền gọi từ `events.amazonaws.com`).

![Trigger EventBridge hiển thị trên Lambda](/images/5-Workshop/5.10/07-lambda-trigger-eventbridge.png)
