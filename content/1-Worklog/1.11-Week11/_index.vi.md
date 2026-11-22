---
title: "Nhật ký công việc Tuần 11"
date: 2026-11-22
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

## **Nhật ký công việc Tuần 11 — Rà soát tài nguyên, dọn dẹp tài sản thừa và đối chiếu chi phí [Dự kiến]**

> **Trạng thái:** Dự kiến (tuần kế tiếp: 23/11/2026 – 27/11/2026; cập nhật ngày 22/11/2026).

## **1. Mục tiêu tuần**

* Rà soát toàn bộ tài nguyên AWS đang hoạt động tại `ap-southeast-1` và `us-east-1` (CloudFront WAF) đối chiếu với tệp Terraform state có versioning.
* Rà soát và xóa bỏ các tài nguyên thừa tạo thủ công từ Tuần 1–5 mà không làm ảnh hưởng đến hệ thống ReLoop đang chạy.
* Đối chiếu chi phí thực tế trên AWS Cost Explorer với mức **$11.70/tháng** và xác nhận số dư credit AWS (**189.80 USD** tính đến 21/11/2026) đủ duy trì vận hành tới 28/02/2027.

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc dự kiến | Ngày dự kiến | Trạng thái | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Thứ 2** | • Kiểm kê toàn bộ tài nguyên AWS tại `ap-southeast-1` và `us-east-1` bằng Resource Explorer và đối chiếu với tệp Terraform state | 23/11/2026 | Dự kiến | [Tài liệu AWS CLI](https://docs.aws.amazon.com/cli/), [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`infra/*.tf`) |
| **Thứ 3** | • Rà soát các tài nguyên còn sót lại từ giai đoạn tạo thủ công ở Tuần 1–5 (user pool cũ, API thử nghiệm, bucket thực hành, IAM role không dùng) ngoài phạm vi quản lý của Terraform | 24/11/2026 | Dự kiến | [Tài liệu AWS IAM](https://docs.aws.amazon.com/iam/), [Tài liệu Amazon S3](https://docs.aws.amazon.com/s3/) |
| **Thứ 4** | • Xác nhận `terraform plan` không còn thay đổi phát sinh, sao lưu danh mục dọn dẹp và xin thống nhất của nhóm trước khi xóa bất kỳ tài nguyên nào | 25/11/2026 | Dự kiến | [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`infra/backend.tf`) |
| **Thứ 5** | • Xóa các tài sản thừa đã được duyệt và chạy lại `smoke-aws.py` trên hệ thống ReLoop thật để xác nhận không ảnh hưởng vận hành | 26/11/2026 | Dự kiến | [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html), [Repository ReLoop](https://github.com/madlyham/ReLoop) (`smoke-aws.py`) |
| **Thứ 6** | • Hoàn tất rà soát chi phí trên Cost Explorer so với mức dự toán **$11.70/tháng** ($10.00/tháng cho CloudFront WAF + ~$1.70/tháng theo mức sử dụng, trong đó tính toán/DB/API/S3 cốt lõi dưới $0.30/tháng) và xác nhận hạn mức credit (189.80 USD còn lại ngày 21/11/2026 đến 28/02/2027) | 27/11/2026 | Dự kiến | [AWS Billing & Cost Explorer](https://docs.aws.amazon.com/cost-management/latest/userguide/) |

## **3. Kết quả dự kiến**

### **Cơ sở lý thuyết**

* Củng cố phương pháp phát hiện sai lệch hạ tầng (drift) và kiểm kê qua Resource Explorer để tránh phát sinh chi phí ngầm trên tài khoản AWS dùng chung.
* Xác nhận định lượng rằng chi phí cố định của CloudFront WAF ($10.00/tháng) chiếm phần lớn hóa đơn, trong khi các dịch vụ cốt lõi (compute, DB, API, S3) duy trì dưới $0.30/tháng.

### **Cài đặt & Thiết lập môi trường**

* Tài khoản AWS được dọn sạch các tài sản thừa từ Tuần 1–5, chỉ giữ lại đúng stack Terraform 12 dịch vụ (+ IAM) của ReLoop.
* `terraform plan` không còn thay đổi phát sinh sau khi rà soát.

### **Kỹ năng thực hành & Vận hành**

* Hoàn tất quy trình dọn dẹp an toàn có phê duyệt và xác nhận `smoke-aws.py` vượt qua trọn vẹn trên hệ thống thật.
* Hoàn chỉnh bảng tóm tắt chi phí Cost Explorer và thời hạn credit ($11.70/tháng; còn 189.80 USD tính đến 21/11/2026, hiệu lực đến 28/02/2027) cho báo cáo cuối kỳ.
