---
title: "Nhật ký công việc Tuần 3"
date: 2026-11-07
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

## **Nhật ký công việc Tuần 3 — Đặc tả ReLoop, 45 quyết định nghiệp vụ, Watch Party AI Day và Tọa đàm TS. Werner Vogels**

## **1. Mục tiêu tuần**

* Chuyển bản đặc tả ReLoop v1.0 thành các quyết định nghiệp vụ rõ ràng, có văn bản.
* Thống nhất cách làm việc của nhóm (vai trò, quy ước triển khai ban đầu, quyền truy cập AWS) và chuẩn bị repository trống + CI cho giai đoạn phát triển ở Tuần 4.
* Tham dự Sự kiện 2 (Watch Party AWS Cloud and AI Day Hanoi) và Sự kiện 3 (Tọa đàm cùng Tiến sĩ Werner Vogels).

## **2. Lịch trình thực hiện**

| Ngày | Mô tả công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| :--- | :--- | :--- | :--- | :--- |
| **Thứ 2** | • Phân chia các phần của bản đặc tả sản phẩm v1.0 có sẵn (1.189 đoạn) do Product Owner cung cấp từ buổi khởi động dự án giữa các thành viên để rà soát trọn vẹn và ghi nhận 58 điểm còn thiếu cùng câu hỏi mở | 28/09/2026 | 28/09/2026 | [Repository ReLoop](https://github.com/madlyham/ReLoop), [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) |
| **Thứ 3** | • Tham dự [Sự kiện 2: AWS Cloud and AI Day Hanoi – Sự kiện Watch Party TP.HCM](../../4-eventparticipated/4.2-event2/) (08:00 – 17:00 tại Văn phòng AWS Việt Nam, Bitexco Tầng 26). Tìm hiểu sâu về AI Agent doanh nghiệp, kỹ nghệ nền tảng và tối ưu chi phí FinOps. | 29/09/2026 | 29/09/2026 | [Sự kiện 2](../../4-eventparticipated/4.2-event2/), [Trụ cột Tối ưu chi phí Well-Architected](https://docs.aws.amazon.com/wellarchitected/latest/framework/cost-optimization.html), [AWS Cost Explorer](https://docs.aws.amazon.com/cost-management/latest/userguide/ce-what-is.html) |
| **Thứ 4** | • Xác định vai trò người dùng (Khách, Đối tác cấp 1, Đối tác cấp 2, Admin, Admin tài chính) và cùng nhóm xử lý các điểm còn thiếu trong đặc tả | 30/09/2026 | 30/09/2026 | [Nhóm trong Cognito user pool](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-user-groups.html), [Repository ReLoop](https://github.com/madlyham/ReLoop) |
| **Thứ 5** | • Viết 45 quyết định nghiệp vụ (QĐ-01 → QĐ-45); tạo Git repository trống và mẫu CI GitHub Actions (typecheck + test cho mỗi pull request), sẵn sàng cho giai đoạn phát triển | 01/10/2026 | 01/10/2026 | [CI Node.js với GitHub Actions](https://docs.github.com/en/actions/tutorials/build-and-test-code/nodejs), [Cú pháp workflow GitHub Actions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax), [Repository ReLoop](https://github.com/madlyham/ReLoop) |
| **Thứ 6** | • Tham dự [Sự kiện 3: Trò chuyện thân mật cùng TS. Werner Vogels](../../4-eventparticipated/4.3-event3/) (10:30 – 12:00 tại Bitexco Financial Tower; tọa đàm cùng TS. Werner Vogels, CTO Amazon). Thống nhất phân công 5 người (vai trò của tôi: Team Lead — đồng thời phụ trách backend AI, hạ tầng Terraform và tài liệu kỹ thuật) và soạn quy ước triển khai ban đầu (một luồng triển khai chung và mỗi thành viên một IAM user) để áp dụng chặt chẽ hơn khi CI hoàn thiện. | 02/10/2026 | 02/10/2026 | [Sự kiện 3](../../4-eventparticipated/4.3-event3/), [Thực hành bảo mật IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html) |

## **3. Kết quả đạt được**

### **Cơ sở lý thuyết**

* Hiểu rằng ghi quyết định thành văn bản (có mã như QĐ-07) giúp tránh tranh luận lặp lại và review code nhanh hơn.
* Tiếp thu triết lý của Tiến sĩ Werner Vogels: "Mọi thứ đều có thể hỏng, mọi lúc", định hướng lựa chọn tác vụ bất đồng bộ, tính lũy đẳng (idempotency) và ghi có điều kiện.
* Áp dụng thông điệp FinOps từ AI Day: chọn đúng kiến trúc và khung chi phí trước khi chọn công cụ mới nhất.

### **Cài đặt & Thiết lập môi trường**

* Git repository trống có bảo vệ nhánh và workflow GitHub Actions chạy typecheck, test (chưa có code ứng dụng).
* Nhật ký quyết định chung (QĐ-01 → QĐ-45) và danh sách 58 điểm còn thiếu trong đặc tả đã xử lý hoặc tạm hoãn.

### **Kỹ năng thực hành & Vận hành**

* Cùng nhóm rà soát đặc tả và biến câu hỏi mở thành quyết định trong một tuần.
* Tham dự trọn ngày Watch Party AI Day và buổi tọa đàm cùng Tiến sĩ Werner Vogels tại Bitexco Financial Tower.
