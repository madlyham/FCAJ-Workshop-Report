---
title : "An toàn Nội dung AI với Bedrock Guardrails"
date : 2026-11-14
weight : 7
chapter : false
pre : " <b> 5.7. </b> "
---

ReLoop chạy **quy trình kiểm duyệt đa tầng** mỗi khi người dùng bấm AI phân tích ảnh thiết bị:
1. **Amazon Rekognition** (`DetectModerationLabels` + `DetectText` OCR) quét ảnh trực tiếp trên S3 tại **`ap-southeast-1`**.
2. Toàn bộ văn bản OCR đọc được từ ảnh (nhãn thông số, chữ in trên vỏ máy hoặc chữ độc hại chèn vào ảnh) được kiểm tra qua **Amazon Bedrock Guardrail (`reloop2-ai-guardrail`)** bằng **`ApplyGuardrailCommand`**.
3. Sau khi vượt qua sàng lọc, **Amazon Bedrock (`global.moonshotai.kimi-k3`)** chạy **`ConverseCommand`** phân tích ảnh và trả về JSON gợi ý cấu trúc tin đăng.

{{% notice info %}}
**Lưu ý kỹ thuật thực tế với Kimi K3:** Trong mã Lambda `index.js`, khi `AI_MODEL_ID` là `kimi`, hệ thống gọi `ConverseCommand` mà không gắn `guardrailConfig` nội tuyến (và chỉ truyền `maxTokens: 2048`) vì inference profile của Kimi K3 không hỗ trợ `guardrailConfig` trực tiếp trong `ConverseCommand`. Tuy nhiên Guardrail vẫn bảo vệ toàn diện nhờ lời gọi `ApplyGuardrailCommand` tách riêng (sử dụng quyền `bedrock:ApplyGuardrail` ở Phần 5.6)!
{{% /notice %}}

![Phạm vi Phần 5.7: Bedrock, Kimi K3, Guardrails & Rekognition](/images/5-Workshop/5.7/architecture.png)

---

### Bước 1 — Tạo Guardrail `reloop2-ai-guardrail`

1. Mở **Amazon Bedrock -> Guardrails** và bấm **Create guardrail**.

![Danh sách Bedrock Guardrails](/images/5-Workshop/5.7/01-guardrails-list.png)

2. Điền **Guardrail details**:
   - **Name:** `reloop2-ai-guardrail`
   - **Description:** `ReLoop 2: lọc ảnh / chữ không phù hợp khi AI phân tích ảnh thiết bị`
   - **Blocked prompts message:** `Ảnh không phù hợp.`
   - **Blocked responses message:** `Kết quả không phù hợp.`

![Cấu hình tên và thông báo chặn của Guardrail](/images/5-Workshop/5.7/02-details-messages.png)

3. Bật **Cross-region inference** (`apac.guardrail.v1:0`) và thêm tags (`Owner=team`, `Project=reloop2`, `Purpose=workshop`).

![Bật profile APAC cross-region và gắn tags](/images/5-Workshop/5.7/03-cross-region-tags.png)

---

### Bước 2 — Cấu hình 6 bộ lọc Content Filters (Standard Tier, HIGH)

4. Tại **Content filters**: chọn **Standard tier** và bật mức **HIGH / BLOCK** cho cả **6 nhóm rủi ro**:

| Nhóm bộ lọc | Đầu vào | Ngưỡng Input | Đầu ra | Ngưỡng Output |
| --- | --- | --- | --- | --- |
| **Hate / Insults / Sexual / Violence** | TEXT, IMAGE | HIGH | TEXT | HIGH |
| **Misconduct** | TEXT | HIGH | TEXT | HIGH |
| **Prompt Attack** | TEXT | HIGH | *(không áp dụng)* | NONE |

![Cấu hình lọc nội dung đầu vào](/images/5-Workshop/5.7/04-filters-prompts.png)

![Cấu hình lọc nội dung phản hồi](/images/5-Workshop/5.7/05-filters-responses.png)

![Đặt ngưỡng HIGH cho Prompt Attack (Standard tier)](/images/5-Workshop/5.7/06-prompt-attack-tier.png)

5. Kiểm tra lại thông tin và bấm **Create guardrail**.

![Xem lại chi tiết Guardrail](/images/5-Workshop/5.7/07-review-details.png)

![Xem lại 6 bộ lọc trước khi tạo](/images/5-Workshop/5.7/08-review-filters.png)

![Guardrail reloop2-ai-guardrail đã sẵn sàng](/images/5-Workshop/5.7/09-guardrail-created.png)

---

### Bước 3 — Kiểm thử Playground & Phát hành Version `1`

6. Thử nhập văn bản prompt-injection / nội dung xấu trong cửa sổ **Test**: xác nhận Guardrail chặn ngay với thông báo `Ảnh không phù hợp.` và hiển thị chi tiết **Trace** (`GUARDRAIL_INTERVENED`).

![Guardrail chặn thành công prompt độc hại](/images/5-Workshop/5.7/10-test-blocked.png)

![Chi tiết Trace xác định bộ lọc kích hoạt](/images/5-Workshop/5.7/11-test-trace.png)

7. Thử mô tả thiết bị hợp lệ (*Laptop Dell Latitude vỡ góc màn hình...*) để chắc chắn Guardrail cho qua bình thường.

![Guardrail cho phép mô tả thiết bị hợp lệ đi qua](/images/5-Workshop/5.7/12-test-pass.png)

8. Vào **Versions -> Create version**, nhập mô tả `v1 cho reloop2-api (ReLoop 2 workshop)` để xuất bản **Version `1`** ổn định.

![Xuất bản Version 1 bất biến cho Guardrail](/images/5-Workshop/5.7/13-create-version.png)

![Guardrail Version 1 đã phát hành](/images/5-Workshop/5.7/14-version-1.png)

---

### Bước 4 — Gắn Guardrail vào Lambda `reloop2-api`

9. Quay lại **AWS Lambda -> `reloop2-api` -> Configuration -> Environment variables -> Edit**, thêm:
   - `AI_GUARDRAIL_ID` = `<ID Guardrail vừa tạo>`
   - `AI_GUARDRAIL_VERSION` = `1`

![Cập nhật AI_GUARDRAIL_ID và AI_GUARDRAIL_VERSION trong Lambda](/images/5-Workshop/5.7/15-lambda-env-guardrail.png)
