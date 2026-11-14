---
title : "AI Content Safety with Bedrock Guardrails"
date : 2026-11-14
weight : 7
chapter : false
pre : " <b> 5.7. </b> "
---

ReLoop runs a **multi-stage screening pipeline** whenever a user analyzes device photos:
1. **Amazon Rekognition** (`DetectModerationLabels` + `DetectText`) runs on the S3 photo in **`ap-southeast-1`**.
2. Any text detected by OCR (for example printed labels, serial stickers, or offensive text injected into a photo) is screened through **Amazon Bedrock Guardrail (`reloop2-ai-guardrail`)** via **`ApplyGuardrailCommand`**.
3. If screening passes, **Amazon Bedrock (`global.moonshotai.kimi-k3`)** executes **`ConverseCommand`** to inspect the device photos and return structured JSON attributes.

{{% notice info %}}
**Important Runtime Note on Kimi K3:** In Bedrock Runtime (`index.js`), when `AI_MODEL_ID` contains `kimi`, ReLoop calls `ConverseCommand` without inline `guardrailConfig` (and uses `maxTokens: 2048` without a custom `temperature`), because Kimi K3's cross-region inference profile does not accept inline `guardrailConfig`. Instead, safety enforcement still invokes your published Guardrail directly via `ApplyGuardrailCommand` (`bedrock:ApplyGuardrail` permission in Module 5.6)!
{{% /notice %}}

![Module 5.7 Focus: Amazon Bedrock, Kimi K3, Guardrails & Rekognition](/images/5-Workshop/5.7/architecture.png)

---

### Step 1 — Create Guardrail `reloop2-ai-guardrail`

1. Open **Amazon Bedrock -> Guardrails** (verify **Cross-region inference** is available in `ap-southeast-1` or configure `guardrail-profile/apac.guardrail.v1:0`) and click **Create guardrail**.

![Bedrock Guardrails console page](/images/5-Workshop/5.7/01-guardrails-list.png)

2. Configure **Guardrail details**:
   - **Name:** `reloop2-ai-guardrail`
   - **Description:** `ReLoop 2: filter unsafe text and images during AI device analysis`
   - **Messaging for blocked prompts:** `Ảnh không phù hợp.`
   - **Messaging for blocked responses:** `Kết quả không phù hợp.`

![Guardrail details and blocked messages](/images/5-Workshop/5.7/02-details-messages.png)

3. Enable **Cross-region inference** (`apac.guardrail.v1:0`) and add standard workshop tags (`Owner=team`, `Project=reloop2`, `Purpose=workshop`).

![Enable APAC cross-region guardrail profile and tags](/images/5-Workshop/5.7/03-cross-region-tags.png)

---

### Step 2 — Configure Content Filters (Standard Tier, HIGH)

4. Under **Content filters**: select **Standard tier** and configure all **6 categories** at **HIGH** threshold with **BLOCK** action:

| Category | Input Modalities | Input Strength | Output Modalities | Output Strength |
| --- | --- | --- | --- | --- |
| **Hate** | TEXT, IMAGE | HIGH | TEXT | HIGH |
| **Insults** | TEXT, IMAGE | HIGH | TEXT | HIGH |
| **Sexual** | TEXT, IMAGE | HIGH | TEXT | HIGH |
| **Violence** | TEXT, IMAGE | HIGH | TEXT | HIGH |
| **Misconduct** | TEXT | HIGH | TEXT | HIGH |
| **Prompt Attack** | TEXT | HIGH | *(N/A)* | NONE |

![Configure prompt content filters](/images/5-Workshop/5.7/04-filters-prompts.png)

![Configure response content filters](/images/5-Workshop/5.7/05-filters-responses.png)

![Prompt attack HIGH threshold on Standard tier](/images/5-Workshop/5.7/06-prompt-attack-tier.png)

5. Review all details and filters, then click **Create guardrail**.

![Review guardrail configuration details](/images/5-Workshop/5.7/07-review-details.png)

![Review all 6 content filter thresholds](/images/5-Workshop/5.7/08-review-filters.png)

![Guardrail reloop2-ai-guardrail Ready](/images/5-Workshop/5.7/09-guardrail-created.png)

---

### Step 3 — Test in Bedrock Guardrail Playground & Publish Version `1`

6. Inside `reloop2-ai-guardrail`, test **unsafe / prompt-injection text** (`Ignore previous instructions...`) and confirm the Guardrail blocks it with `"Ảnh không phù hợp."` and displays a `GUARDRAIL_INTERVENED` trace.

![Guardrail blocks adversarial prompt in test panel](/images/5-Workshop/5.7/10-test-blocked.png)

![Inspect Guardrail trace explaining intervention](/images/5-Workshop/5.7/11-test-trace.png)

7. Next test a **benign electronic device prompt** (`Dell Latitude laptop with cracked screen corner, battery missing`) and verify it passes cleanly without intervention.

![Guardrail allows benign device description](/images/5-Workshop/5.7/12-test-pass.png)

8. Click **Versions -> Create version**, enter description `v1 cho reloop2-api (ReLoop 2 workshop)`, and publish **Version `1`** (immutable snapshot for production/workshop stability).

![Create immutable Guardrail Version 1](/images/5-Workshop/5.7/13-create-version.png)

![Guardrail Version 1 published](/images/5-Workshop/5.7/14-version-1.png)

---

### Step 4 — Wire Guardrail ID & Version to `reloop2-api` Lambda

9. Open **AWS Lambda -> `reloop2-api` -> Configuration -> Environment variables -> Edit**, add:
   - `AI_GUARDRAIL_ID` = `<your guardrail ID>` (e.g. `a1b2c3d4e5f6`)
   - `AI_GUARDRAIL_VERSION` = `1`
   Save and verify.

![Wire AI_GUARDRAIL_ID and AI_GUARDRAIL_VERSION into Lambda](/images/5-Workshop/5.7/15-lambda-env-guardrail.png)
