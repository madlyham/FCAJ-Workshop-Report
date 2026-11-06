---
title: "Self-evaluation"
date: 2026-11-07
weight: 6
chapter: false
pre: " <b> 6. </b> "
---

# Self-Evaluation Report

During my internship at **Amazon Web Services Viet Nam Company Limited (Workforce Bootcamp - First Cloud AI Journey)** from **14/08/2026 to 12/11/2026**, I had the opportunity to learn, practice, and apply my cybersecurity and cloud computing knowledge acquired at FPT University to a production-grade working environment.

I actively participated as the backend AI and infrastructure engineer for the **ReLoop** circular marketplace platform, responsible for architecting an automated device classification and content moderation pipeline using Amazon Bedrock (Amazon Nova Pro), Amazon Rekognition, DynamoDB single-table design, and Bedrock Guardrails to defend against visual prompt injection attacks. Through this project, I significantly strengthened my technical skills in serverless cloud architecture, multimodal AI tool integration, DevSecOps, and Infrastructure as Code (Terraform), while sharpening my abilities in technical documentation, code reviews, and cross-functional Agile collaboration.

In terms of work ethic, I consistently took ownership of complex deliverables, adhered strictly to enterprise security rules and workplace policies, proactively engaged with colleagues across frontend and core backend tracks to resolve technical bottlenecks, and maintained steady milestone delivery throughout the 12-week timeline.

To objectively reflect on my internship period, I evaluate my performance based on the following criteria:

| No. | Criteria | Description | Good | Fair | Average |
| :--- | :--- | :--- | :---: | :---: | :---: |
| 1 | **Professional knowledge & skills** | Understanding of the field, applying knowledge in practice, proficiency with tools, work quality | ☐ | ✅ | ☐ |
| 2 | **Ability to learn** | Ability to absorb new knowledge and learn quickly | ✅ | ☐ | ☐ |
| 3 | **Proactiveness** | Taking initiative, seeking out tasks without waiting for instructions | ✅ | ☐ | ☐ |
| 4 | **Sense of responsibility** | Completing tasks on time and ensuring quality | ✅ | ☐ | ☐ |
| 5 | **Discipline** | Adhering to schedules, rules, and work processes | ☐ | ✅ | ☐ |
| 6 | **Progressive mindset** | Willingness to receive feedback and improve oneself | ✅ | ☐ | ☐ |
| 7 | **Communication** | Presenting ideas and reporting work clearly | ✅ | ☐ | ☐ |
| 8 | **Teamwork** | Working effectively with colleagues and participating in teams | ✅ | ☐ | ☐ |
| 9 | **Professional conduct** | Respecting colleagues, partners, and the work environment | ✅ | ☐ | ☐ |
| 10 | **Problem-solving skills** | Identifying problems, proposing solutions, and showing creativity | ☐ | ✅ | ☐ |
| 11 | **Contribution to project/team** | Work effectiveness, innovative ideas, recognition from the team | ✅ | ☐ | ☐ |
| 12 | **Overall** | General evaluation of the entire internship period | ✅ | ☐ | ☐ |

---

### **Areas for Improvement (Needs Improvement)**

* **Enterprise Discipline & Operational Rigor:** While basic company policies and attendance were consistently met, transitioning from an academic mindset to enterprise cloud engineering requires stricter adherence to production operational standards. Moving forward, I need to enforce tighter discipline around routine environment maintenance—such as proactive AWS budget threshold audits, automated credential hygiene, consistent branch naming conventions, and adhering strictly to documented sprint timelines without leaving integration testing to the final deployment stages.  
* **System-Level Problem Solving & Root-Cause Analysis:** When resolving technical blockers, I initially gravitated toward rapid, localized fixes (such as patching regex patterns or trial-and-error configuration changes) rather than stepping back to analyze fundamental system constraints. I need to improve my architectural foresight—deliberately evaluating edge cases, schema immutability, data lifecycle impacts, and cost trade-offs (e.g., on-demand vs. provisioned resource pricing) before implementing code.  
* **Proactive Technical Communication & Situation Handling:** While internal peer discussions were productive, I need to express technical blockers and architectural trade-offs more concisely to mentors and cross-functional stakeholders. In situations involving unexpected project hurdles—such as quota exhaustion, schema locking, or third-party API integration limits—I must improve at formulating structured escalation proposals (presenting the problem, impact, and 2–3 viable mitigation options) rather than spending excessive time troubleshooting independently before raising flags.

---

### **Action Plan & Remediation Strategies**

1. **Adopt a Structured Incident & Debugging Protocol:** Instead of applying immediate patches when errors occur, document the failure mode, consult official service specifications, and verify root causes in CloudWatch metrics before committing changes.  
2. **Standardize Work-in-Progress Communication:** Share daily standalone updates highlighting completed tasks, current blockers, and specific help needed to keep team members and mentors aligned without requiring manual check-ins.  
3. **Checklist-Driven Engineering:** Maintain a pre-deployment checklist for every feature covering IAM least-privilege policies, optimistic concurrency tests, and cost impact evaluations prior to opening pull requests.
