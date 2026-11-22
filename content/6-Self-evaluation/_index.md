---
title: "Self-evaluation"
date: 2026-11-22
weight: 6
chapter: false
pre: " <b> 6. </b> "
---

## Self-Evaluation Report

This self-evaluation reflects my progress through **Week 10 (as of 22/11/2026)** of my 12-week internship at **Amazon Web Services Viet Nam Company Limited (Workforce Bootcamp - First Cloud AI Journey, 14/09/2026–04/12/2026)**, where I have been applying my cybersecurity and cloud computing foundations from FPT University in a real-world cloud engineering environment—with final resource audit, live demo, and handover planned in Weeks 11–12 through **04/12/2026**.

As **Team Lead** for the **ReLoop** platform, I also contributed directly to the backend AI, security, and cloud infrastructure tracks—helping architect an automated device classification and content moderation pipeline using Amazon Bedrock (prototyped with Amazon Nova Pro, then migrated to Kimi K3 on Amazon Bedrock), Amazon Rekognition, DynamoDB single-table design, and Amazon Bedrock Guardrails to defend against visual prompt injection attacks. Through this project, I have strengthened my technical skills in serverless cloud architecture, multimodal AI tool integration, DevSecOps, and Infrastructure as Code (Terraform), while sharpening my abilities in technical documentation, code reviews, and cross-functional Agile collaboration.

Across the first 10 weeks, I took ownership of core cloud and AI deliverables, followed team security practices, worked closely with teammates across frontend and backend tracks to resolve technical bottlenecks, and kept milestone delivery on track ahead of our Weeks 11–12 wrap-up.

Below is my self-evaluation through Week 10 (as of 22/11/2026) across the 12 assessment criteria:

| No. | Criteria | Description | Good | Fair | Average | Specific Comment |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- |
| 1 | **Professional knowledge & skills** | Understanding of the field, applying knowledge in practice, proficiency with tools, work quality | ☐ | ✅ | ☐ | Built ReLoop's serverless AI, security, and Terraform stack (Bedrock, Rekognition, DynamoDB), while continuing to deepen system-level foresight on key design and cost trade-offs. |
| 2 | **Ability to learn** | Ability to absorb new knowledge and learn quickly | ✅ | ☐ | ☐ | Quickly learned and applied 12 managed AWS services, Terraform IaC, and Bedrock Guardrails across the first 10 weeks of the FCAJ bootcamp. |
| 3 | **Proactiveness** | Taking initiative, seeking out tasks without waiting for instructions | ✅ | ☐ | ☐ | Led spec-gap triage (45 business decisions), initiated red-team prompt-injection testing, and proactively switched AI models from Nova Pro to Kimi K3 based on internal test results. |
| 4 | **Sense of responsibility** | Completing tasks on time and ensuring quality | ✅ | ☐ | ☐ | Delivered Proposal Parts 1–2, live Workshop verification (5.1–5.12), and 3 AWS Study Group blogs on schedule, backed by live console checks. |
| 5 | **Discipline** | Adhering to schedules, rules, and work processes | ☐ | ✅ | ☐ | Met attendance and security rules consistently, while strengthening daily operational discipline around branch hygiene, sprint pacing, and single-workflow deploys. |
| 6 | **Progressive mindset** | Willingness to receive feedback and improve oneself | ✅ | ☐ | ☐ | Actively incorporated mentor feedback and 5 QA rounds (146 findings) to fix Vietnamese AI accuracy, concurrency throttling, and origin-locking gaps. |
| 7 | **Communication** | Presenting ideas and reporting work clearly | ☐ | ✅ | ☐ | Communicated effectively within the team and in written technical docs, while working to escalate blockers to mentors earlier with concise impact-and-options briefs. |
| 8 | **Teamwork** | Working effectively with colleagues and participating in teams | ✅ | ☐ | ☐ | Coordinated cleanly across the 5-member ReLoop team (frontend, core backend, AI, and IaC), aligning API contracts, code reviews, and shared deploy rules. |
| 9 | **Professional conduct** | Respecting colleagues, partners, and the work environment | ✅ | ☐ | ☐ | Maintained respectful, constructive collaboration with AWS mentors, teammates, and community partners across all 6 FCAJ events and office sessions. |
| 10 | **Problem-solving skills** | Identifying problems, proposing solutions, and showing creativity | ☐ | ✅ | ☐ | Resolved real issues such as Lambda 5xx spikes and visual prompt injection, while shifting from fast local patches toward structured root-cause analysis before coding. |
| 11 | **Contribution to project/team** | Work effectiveness, innovative ideas, recognition from the team | ✅ | ☐ | ☐ | Served as Team Lead and delivered ReLoop's Terraform stack, Bedrock Kimi K3 + Guardrails pipeline (substantially improved device-classification accuracy on our internal test photos), and technical reference. |
| 12 | **Overall** | General evaluation of the entire internship period | ✅ | ☐ | ☐ | Strong growth through Week 10 across cloud architecture, DevSecOps, and team leadership, with final audit, demo, and handover planned in Weeks 11–12 and a clear action plan to close operational and communication gaps. |

---

### Areas for Improvement

* **Enterprise Discipline & Operational Rigor:** While basic company policies and attendance were consistently met, transitioning from an academic mindset to enterprise cloud engineering requires stricter adherence to production operational standards. Moving forward, I need to enforce tighter discipline around routine environment maintenance—such as proactive AWS budget threshold audits, automated credential hygiene, consistent branch naming conventions, and adhering strictly to documented sprint timelines without leaving integration testing to the final deployment stages.
* **System-Level Problem Solving & Technical Depth:** When resolving technical blockers, I initially gravitated toward rapid, localized fixes (such as tweaking regex patterns or trial-and-error configuration changes) rather than stepping back to analyze fundamental system constraints. To strengthen both my professional cloud skills and problem-solving rigor, I need stronger architectural foresight—deliberately evaluating edge cases, DynamoDB key-design constraints, Cognito attribute immutability, data lifecycle impacts, and cost trade-offs (e.g., on-demand vs. provisioned resource pricing) before writing code.
* **Technical Communication & Escalation Handling:** While internal peer discussions were productive, I need to express technical blockers and architectural trade-offs more concisely to mentors and cross-functional stakeholders. In situations involving unexpected project hurdles—such as quota exhaustion, Cognito attribute immutability, or third-party API integration limits—I must improve at formulating structured escalation proposals (presenting the problem, impact, and 2–3 viable mitigation options) rather than spending excessive time troubleshooting independently before raising flags.

---

### Action Plan & Remediation Strategies

1. **Adopt a Structured Incident & Debugging Protocol:** Instead of applying immediate patches when errors occur, document the failure mode, consult official service specifications, and verify root causes in CloudWatch logs and metrics before committing changes.
2. **Standardize Work-in-Progress Communication:** Share daily stand-up updates highlighting completed tasks, current blockers, and specific help needed to keep team members and mentors aligned without requiring manual check-ins.
3. **Checklist-Driven Engineering:** Maintain a pre-deployment checklist for every feature covering IAM least-privilege policies, conditional write (optimistic concurrency) tests, and cost impact evaluations prior to opening pull requests.
