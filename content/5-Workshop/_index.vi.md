---
title : "Workshop"
date : 2026-11-21
weight : 5
chapter : false
pre : " <b> 5. </b> "
---

## Triển khai Sàn Đồ Điện Tử Cũ Serverless ReLoop trên AWS

Chào mừng bạn đến với **ReLoop AWS Serverless Workshop**. Qua các học phần **5.1 đến 5.12**, bạn sẽ xây dựng và kiểm chứng trọn vẹn ứng dụng web serverless trên AWS theo đúng luồng yêu cầu của sơ đồ kiến trúc — từ **Mũi tên 1** ở lớp biên toàn cầu cho tới **Mũi tên 10** ở lớp xử lý AI, cùng lịch dọn tin định kỳ, giám sát cảnh báo, kiểm thử thực tế và dọn dẹp tài nguyên.

{{% notice tip %}}
**Bản Demo trực tuyến (Live Demo):** [https://d1cjl1tvcp0r6q.cloudfront.net/](https://d1cjl1tvcp0r6q.cloudfront.net/) (bản triển khai HTTPS trực tiếp của ReLoop trên CloudFront)  
**Mã nguồn đồng hành & Terraform Repo:** [https://github.com/madlyham/ReLoop](https://github.com/madlyham/ReLoop)
{{% /notice %}}

{{% notice note %}}
Hướng dẫn dùng tiền tố tài nguyên `reloop2` cùng các giá trị mẫu đã che thông tin (`123456789012`, `alerts@example.com`, `<suffix>`) để bạn thực hành an toàn, không lộ thông tin cá nhân và không trùng tên với hệ thống có sẵn.
{{% /notice %}}

### Danh sách học phần (Theo thứ tự sơ đồ: 1 → 10)

1. [5.1. Tổng quan Workshop & Kiến trúc](5.1-workshop-overview/) — Sơ đồ tổng thể & giải thích luồng **1 → 10**
2. [5.2. Chuẩn bị & Quyền truy cập Bedrock](5.2-prerequisites/) — Tài khoản, vùng Singapore (`ap-southeast-1`) & kiểm tra Kimi K3
3. [5.3. Lớp biên toàn cầu & Website tĩnh](5.3-global-edge/) — **Mũi tên 1, 2** + WAF (`Người dùng → CloudFront [WAF] → S3 website`)
4. [5.4. Đăng ký & Đăng nhập](5.4-sign-up-and-sign-in/) — **Mũi tên 3** + Post-confirm (`Người dùng → Cognito → Lambda → tạo hồ sơ`)
5. [5.5. Hệ thống API Backend](5.5-api-backend/) — **Mũi tên 4, 5** + xác thực JWT (`CloudFront /api/* → API Gateway → Lambda API`)
6. [5.6. Lưu trữ dữ liệu: Amazon DynamoDB](5.6-dynamodb/) — **Mũi tên 6** (`đọc/ghi người dùng, tin đăng & hóa đơn`)
7. [5.7. Lưu trữ ảnh: Amazon S3](5.7-s3-photos/) — **Mũi tên 7, 8** (`tạo URL ký sẵn & gắn thẻ` + `tải lên / xem ảnh`)
8. [5.8. Xử lý AI: Rekognition & Bedrock](5.8-ai-processing/) — **Mũi tên 9, 10** (`kiểm duyệt ảnh` + `phân tích AI + Guardrail`)
9. [5.9. Dọn tin định kỳ: Amazon EventBridge](5.9-eventbridge/) — `tự động đóng tin đăng quá hạn mỗi 15 phút`
10. [5.10. Giám sát & Cảnh báo: CloudWatch & SNS](5.10-monitoring/) — `nhật ký & chỉ số → cảnh báo → email Admin`
11. [5.11. Kiểm thử toàn luồng thực tế](5.11-end-to-end-verification/) — Chạy kiểm chứng **Mũi tên 1 → 10** + EventBridge + CloudWatch & SNS
12. [5.12. Dọn dẹp tài nguyên & Tham khảo Terraform](5.12-cleanup-and-iac/) — Xóa ngược thứ tự phụ thuộc & xác minh sạch tài nguyên
