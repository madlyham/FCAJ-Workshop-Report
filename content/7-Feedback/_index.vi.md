---
title: "Chia sẻ, đóng góp ý kiến"
date: 2026-11-22
weight: 7
chapter: false
pre: " <b> 7. </b> "
---

Dưới đây là những chia sẻ cá nhân và góp ý xây dựng của mình sau thời gian tham gia chương trình **First Cloud AI Journey (FCAJ)**, với mong muốn đóng góp cho trải nghiệm của các khóa thực tập sinh tiếp theo.

### Đánh giá chung

**1. Môi trường làm việc**

Cởi mở và thực tế. Phần lớn việc học diễn ra qua kênh trao đổi của nhóm và tại văn phòng AWS Việt Nam (tầng 26, Bitexco), nơi các sự kiện giúp mình gặp trực tiếp mentor, kỹ sư AWS và các bạn thực tập khác. Mọi thắc mắc ở bất kỳ mức độ nào đều được lắng nghe và giải đáp nhiệt tình, nên mình dễ dàng thừa nhận những gì chưa biết để học hỏi thêm.

**2. Sự hỗ trợ của mentor / team admin**

Mentor định hướng thay vì đưa sẵn đáp án: góp ý kiến trúc, proposal và đặt nhiều câu hỏi khó về chi phí và bảo mật. Team admin sắp xếp sự kiện, hạn nộp và mẫu báo cáo rõ ràng. Nếu có thêm các buổi check-in ngắn trong giai đoạn phát triển, nhóm sẽ phát hiện vấn đề sớm hơn.

**3. Sự phù hợp giữa công việc và chuyên ngành học**

Rất phù hợp. Mình học an toàn thông tin, và ReLoop giúp mình vận dụng kiến thức vào một hệ thống thực tế: AWS WAF, đăng nhập Cognito, IAM quyền tối thiểu, chống tấn công visual prompt injection cho pipeline AI, cùng đợt rà soát bảo mật và gia cố hệ thống (hardening) với WAF và cơ chế xác thực nguồn (origin-verify) kèm khắc phục triệt để. Mình cũng được làm thêm nhiều mảng ngoài chuyên ngành: backend serverless, thiết kế DynamoDB và Terraform.

**4. Cơ hội học hỏi & phát triển kỹ năng**

Mình tiến bộ nhiều nhất nhờ trực tiếp bắt tay xây dựng sản phẩm: Lambda, API Gateway, DynamoDB, Rekognition, Bedrock, Terraform và GitHub Actions trên một dự án chạy thật. Kỹ năng mềm cũng tốt lên: viết proposal, ghi worklog hằng tuần, review code của đồng đội và giải thích các lựa chọn thiết kế với mentor. Sáu sự kiện đã tham gia cho mình thêm góc nhìn thực tế từ ngành.

**5. Văn hóa & tinh thần đồng đội**

Nhóm AWSS3nt1n4L chia việc theo thế mạnh (frontend, backend, AI, hạ tầng) và luôn hỗ trợ nhau khi có người bị kẹt. Tại các sự kiện, cộng đồng FCAJ rất thân thiện và ham học hỏi; phần hỏi đáp thường kéo dài vì mọi người hỏi mãi không dứt.

**6. Chính sách / phúc lợi cho thực tập sinh**

Phúc lợi chính là credit AWS để xây dựng trên dịch vụ thật, được tham gia miễn phí các sự kiện và workshop của AWS, và làm việc từ xa linh hoạt giữa các buổi lên văn phòng. Nếu giới hạn của tài khoản lab (quota, ngân sách) được nói rõ từ đầu thì việc lập kế hoạch sẽ dễ hơn.

---

### Một số câu hỏi khác

**Điều bạn hài lòng nhất trong thời gian thực tập?**

Đưa ReLoop từ một ý tưởng thành hệ thống chạy thật trên các dịch vụ AWS trong 12 tuần. Khoảnh khắc đáng nhớ nhất là thấy một ảnh tải lên thật đi trọn vẹn qua pipeline AI (Rekognition + Bedrock), rồi kết quả rà soát bảo mật và gia cố hệ thống (WAF/origin-verify) sau khi khắc phục không còn lỗ hổng mức cao nào. Các sự kiện tại văn phòng AWS, nhất là phiên hỏi đáp kéo dài đầy sôi nổi tại sự kiện Cloud Mastery, cũng rất đáng nhớ.

**Điều bạn nghĩ công ty cần cải thiện cho các thực tập sinh sau?**

- Thông báo giới hạn của tài khoản lab (service quota, ngân sách) ngay tuần 1, để các nhóm không bị bất ngờ khi đang triển khai giữa sprint.
- Có các buổi check-in ngắn, đều đặn với mentor trong giai đoạn phát triển (tuần 4–10), không chỉ quanh hạn nộp proposal.
- Một checklist rõ ràng kèm hạn nộp cho worklog, proposal và báo cáo cuối, công bố ngay từ đầu.

**Nếu giới thiệu cho bạn bè, bạn có khuyên họ thực tập ở đây không? Vì sao?**

Có, với những bạn sẵn sàng tự học. Bạn được làm thực tế với dịch vụ AWS, tham gia sự kiện thật và xây sản phẩm thật cùng nhóm. Đây không phải khóa học nghe giảng: nếu chờ người khác giao việc, bạn sẽ bị tụt lại.

---

### Đề xuất & mong muốn

**Bạn có đề xuất gì để cải thiện trải nghiệm trong kỳ thực tập?**

- Một buổi demo giữa kỳ để các nhóm trình bày tiến độ và nhận góp ý của mentor trước buổi thuyết trình cuối.
- Một trang "bài học kinh nghiệm" chung, tổng hợp các lỗi hay gặp từ các khóa trước (quyền IAM, CORS, quota, cảnh báo chi phí).
- Review kiến trúc chéo giữa các nhóm để học hỏi thiết kế của nhau.

**Bạn có muốn tiếp tục chương trình này trong tương lai?**

Có. Mình muốn tiếp tục hoàn thiện ReLoop, tham gia tích cực vào cộng đồng FCAJ và hướng tới một chứng chỉ AWS.

**Góp ý khác (tự do chia sẻ):**

Cảm ơn các mentor, team admin FCAJ và các thành viên nhóm AWSS3nt1n4L. Mười hai tuần trôi qua rất nhanh, và mình có thêm rất nhiều kinh nghiệm thực tế về cloud và bảo mật so với lúc bắt đầu.
