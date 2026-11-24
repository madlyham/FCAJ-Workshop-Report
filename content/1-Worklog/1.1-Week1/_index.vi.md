---
title: "Nhật ký công việc Tuần 1"
date: 2026-11-07
weight: 1
chapter: false
pre: " <b> 1.1. </b> "
---

## **Nhật ký công việc Tuần 1 — Nền tảng AWS, Console, CLI, EC2, IAM và VPC**

## **1. Mục tiêu tuần**

* Làm quen với AWS Management Console, AWS CLI và Free Tier.
* Khởi tạo và quản lý tài nguyên tính toán (EC2, EBS, Elastic IP) an toàn.
* Ngừng dùng tài khoản root hằng ngày và dựng mạng cơ bản an toàn (IAM + VPC).

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Thứ 2** | • Nhập môn chương trình First Cloud AI Journey; làm quen AWS Console, region, Availability Zone và giới hạn Free Tier | 14/09/2026 | 14/09/2026 | [Vùng và Vùng sẵn sàng AWS](https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html), [AWS Free Tier](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier.html), [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) |
| **Thứ 3** | • Cài đặt và cấu hình AWS CLI v2 (profile, region mặc định `ap-southeast-1`); chạy các lệnh chỉ đọc đầu tiên | 15/09/2026 | 15/09/2026 | [Cài đặt AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), [Tệp cấu hình và thông tin xác thực AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) |
| **Thứ 4** | • Thực hành: tạo EC2, gắn thêm ổ EBS ngoài ổ gốc và gán Elastic IP; sau khi xóa (terminate) EC2, chủ động giải phóng (release) Elastic IP đã cấp phát và xóa ổ EBS phụ (`DeleteOnTermination = false` theo mặc định), vì chỉ dừng hoặc xóa EC2 không tự giải phóng Elastic IP và các ổ EBS phụ vẫn tiếp tục tính phí | 16/09/2026 | 16/09/2026 | [Địa chỉ Elastic IP](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html), [Giữ dữ liệu khi xóa instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/preserving-volumes-on-termination.html), [Gắn ổ EBS](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-attaching-volume.html) |
| **Thứ 5** | • IAM cơ bản: user, group, role, policy JSON; tạo IAM admin có MFA và cất giữ tài khoản root | 17/09/2026 | 17/09/2026 | [Người dùng IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html), [MFA trong IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html), [Thực hành tốt cho tài khoản root](https://docs.aws.amazon.com/IAM/latest/UserGuide/root-user-best-practices.html) |
| **Thứ 6** | • VPC cơ bản: dựng VPC tùy chỉnh (`10.0.0.0/16`) với subnet public/private, Internet Gateway, route table, so sánh Security Group và NACL | 18/09/2026 | 18/09/2026 | [Subnet trong VPC](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html), [Internet gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html), [Bảng định tuyến (route table)](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html), [Security group và network ACL trong VPC](https://docs.aws.amazon.com/vpc/latest/userguide/infrastructure-security.html) |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu mô hình trách nhiệm chia sẻ và cách region, Availability Zone mang lại tính sẵn sàng cao.
* Nắm nguyên tắc quyền tối thiểu: chỉ cấp đúng quyền công việc cần.
* Hiểu vì sao subnet private giúp cơ sở dữ liệu và máy chủ nội bộ tránh bị quét trực tiếp từ Internet.

### **Cài đặt & Thiết lập môi trường**

* Cấu hình AWS CLI v2 với profile riêng và region `ap-southeast-1`.
* Tạo IAM admin có MFA; thông tin root được cất an toàn, không dùng hằng ngày.
* VPC tùy chỉnh trải trên 2 Availability Zone với 2 subnet public và 2 subnet private.

### **Kỹ năng thực hành & Vận hành**

* Tạo, kết nối và dọn dẹp tài nguyên EC2 (bao gồm giải phóng Elastic IP và xóa ổ EBS phụ) mà không để sót tài nguyên phát sinh phí.
* Viết và kiểm thử policy IAM JSON chỉ cho phép đúng các thao tác đọc/ghi cần thiết.
* Kiểm tra cô lập mạng: subnet public ra Internet qua IGW, subnet private không nhận kết nối từ ngoài vào.
