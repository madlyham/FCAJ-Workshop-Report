---
title : "Cognito Authentication & Profile Sync"
date : 2026-11-14
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

In this module you configure **Amazon Cognito** (`reloop2-user-pool`), define RBAC user groups (`Admins`, `FinanceAdmins`, `Partners`, `Owners`), enable Managed Login v2 on domain `reloop2-auth`, and create the Python 3.12 **Post-Confirmation Lambda (`reloop2-post-confirmation`)** that writes every newly verified user straight into `reloop2-core-table`.

![Module 5.4 Focus: Cognito, Post-Confirmation Lambda & DynamoDB](/images/5-Workshop/5.4/architecture.png)

---

### Part A — Create User Pool & Configure Authentication

1. Open **Amazon Cognito -> User pools** in **`ap-southeast-1`** and click **Create user pool**.

![Amazon Cognito User pools page](/images/5-Workshop/5.4/01-cognito-pools.png)

2. In the **Set up your application** wizard:
   - Choose **Single-page application (SPA)**
   - Name your application client `reloop2-web-client`
   - Select **Email** as the sign-in identifier and **email**, **name** as required sign-up attributes, then click **Create user directory**.

![Setup SPA application client and email sign-in](/images/5-Workshop/5.4/02-setup-app.png)

3. Once Cognito creates the pool, review the generated User Pool ID and click **Go to overview**.

![Initial user pool created](/images/5-Workshop/5.4/03-pool-created.png)

4. On **Overview**, click **Rename**, enter `reloop2-user-pool`, and save.

![Rename user pool to reloop2-user-pool](/images/5-Workshop/5.4/04-rename-pool.png)

![Renamed reloop2-user-pool overview](/images/5-Workshop/5.4/05-pool-overview.png)

5. Under **Authentication -> Authentication methods**: verify **Password** (`PASSWORD`) is enabled and MFA is **No MFA** (Essentials tier default for smoother workshop onboarding; enable TOTP/SMS for production).

![Password authentication method enabled](/images/5-Workshop/5.4/06-auth-methods-password.png)

6. Under **Authentication -> Sign-in**: confirm **Email** sign-in (`alias_attributes = ["email"]`) and case-insensitive usernames.

![Sign-in identifiers configuration](/images/5-Workshop/5.4/07-sign-in.png)

7. Under **Sign-up -> Attribute verification and user account confirmation**: ensure self-service sign-up is on, email verification is active, and **Account recovery** uses **Email only (`verified_email`, priority 1)**.

![Account recovery email settings](/images/5-Workshop/5.4/08-account-recovery.png)

![Email verification message settings](/images/5-Workshop/5.4/09-verification-message.png)

8. Add workshop tags (`Owner = team`, `Project = reloop2`, `Purpose = workshop`) and confirm **Deletion protection** is **Active** (we will deactivate it explicitly in Module 5.13).

![User pool resource tags](/images/5-Workshop/5.4/10-pool-tags.png)

![Deletion protection active](/images/5-Workshop/5.4/11-deletion-protection.png)

---

### Part B — Create User Groups (RBAC)

9. Go to **User management -> Groups** and create all **4 groups**:

| Group Name | Precedence | Description |
| --- | --- | --- |
| `Admins` | `1` | System operators and verifiers |
| `FinanceAdmins` | `1` | Finance reconcilers (bank / payout approvals) |
| `Partners` | `2` | Verified recycling and repair shops |
| `Owners` | `3` | Device sellers |

![Create Admins group](/images/5-Workshop/5.4/12-create-group-admins.png)

![All four RBAC groups listed](/images/5-Workshop/5.4/13-groups-list.png)

---

### Part C — Configure App Client (`reloop2-web-client`) & Managed Login Domain

10. Open **Applications -> App clients -> `reloop2-web-client`**: check **Authentication flows** allow **`ALLOW_USER_SRP_AUTH`** and **`ALLOW_REFRESH_TOKEN_AUTH`**, access/ID token validity is **60 minutes**, refresh token validity is **5 days**, and **Prevent user existence errors** is enabled.

![App client reloop2-web-client summary](/images/5-Workshop/5.4/14-app-client.png)

![Auth flows and token expiration settings](/images/5-Workshop/5.4/15-app-client-auth-flows.png)

11. Click the **Login pages** tab -> **Edit Managed Login pages configuration**:
    - Temporarily set **Allowed callback URLs** to `http://localhost:5173/auth/callback`
    - Temporarily set **Allowed sign-out URLs** to `http://localhost:5173/` (we will append the CloudFront HTTPS URL in Module **5.8** once CloudFront is created!)
    - OAuth 2.0 grant types: **Authorization code grant** (`code`)
    - OpenID Connect scopes: `openid`, `email`, `phone`

![Managed login pages before edit](/images/5-Workshop/5.4/16-login-pages-before.png)

![Configure callback and sign-out URLs](/images/5-Workshop/5.4/17-login-pages-signout.png)

![Saved login pages settings](/images/5-Workshop/5.4/18-login-pages-after.png)

12. Go to **Branding -> Domain**. Cognito creates an auto-generated domain initially; create/replace with custom Cognito prefix **`reloop2-auth`** using **Managed login version `2`** (`https://reloop2-auth.auth.ap-southeast-1.amazoncognito.com`).

![Initial Cognito auto-generated domain](/images/5-Workshop/5.4/19-domain-auto.png)

![Create Cognito prefix domain reloop2-auth](/images/5-Workshop/5.4/20-domain-create.png)

![Domain reloop2-auth Available](/images/5-Workshop/5.4/21-domain-reloop2-auth.png)

---

### Part D — Create Post-Confirmation IAM Role & Python Lambda

When a user confirms their sign-up email code, Cognito synchronously calls `reloop2-post-confirmation` to insert their default `Owner` profile row into `reloop2-core-table`.

13. Open **IAM -> Roles -> Create role**:
    - **Trusted entity type:** AWS service -> **Lambda**

![Select Lambda as trusted entity](/images/5-Workshop/5.4/22-role-trusted-lambda.png)

14. Attach AWS managed policy **`AWSLambdaBasicExecutionRole`** (if your lab account requires a Permissions Boundary policy such as `TeamAppRoleBoundary`, select it under Permissions boundary; personal accounts leave none).

![Permissions and optional permissions boundary](/images/5-Workshop/5.4/23-role-permissions-boundary.png)

15. Set **Role name:** `reloop2-post-confirmation-role`, add tags, and click **Create role**.

![Review and create reloop2-post-confirmation-role](/images/5-Workshop/5.4/24-role-review.png)

![Role created confirmation](/images/5-Workshop/5.4/25-role-created.png)

16. Open `reloop2-post-confirmation-role` -> **Add permissions -> Create inline policy** (JSON):

![Role details before inline policy](/images/5-Workshop/5.4/26-role-details.png)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PutUserProfile",
      "Effect": "Allow",
      "Action": "dynamodb:PutItem",
      "Resource": "arn:aws:dynamodb:ap-southeast-1:123456789012:table/reloop2-core-table"
    }
  ]
}
```

![Inline policy JSON for PutUserProfile](/images/5-Workshop/5.4/27-inline-policy-json.png)

17. Name the inline policy `DynamoDBWriteAccess` and save.

![Review DynamoDBWriteAccess inline policy](/images/5-Workshop/5.4/28-inline-policy-review.png)

18. Now open **AWS Lambda -> Create function**:
    - **Author from scratch**
    - **Function name:** `reloop2-post-confirmation`
    - **Runtime:** `Python 3.12`
    - **Architecture:** `x86_64`
    - **Execution role:** **Use an existing role** -> `reloop2-post-confirmation-role`

![Pick existing execution role](/images/5-Workshop/5.4/29-lambda-pick-role.png)

![Create reloop2-post-confirmation function form](/images/5-Workshop/5.4/30-lambda-create-form.png)

![Lambda function created](/images/5-Workshop/5.4/31-lambda-created.png)

19. Upload or deploy the Python handler `lambda_function.py` (`reloop2-post-confirmation.zip`), then click **Save**:

```python
import datetime
import os
import boto3

dynamodb = boto3.client("dynamodb")
TABLE_NAME = os.environ["TABLE_NAME"]

def lambda_handler(event, context):
    if event.get("triggerSource") != "PostConfirmation_ConfirmSignUp":
        return event

    attrs = event["request"]["userAttributes"]
    user_id = attrs["sub"]
    email = attrs.get("email", "")
    name = attrs.get("name", "Unknown")
    role = "Owner"
    timestamp = datetime.datetime.utcnow().isoformat() + "Z"

    try:
        dynamodb.put_item(
            TableName=TABLE_NAME,
            Item={
                "PK": {"S": f"USER#{user_id}"},
                "SK": {"S": "PROFILE"},
                "GSI1PK": {"S": f"ROLE#{role}"},
                "GSI1SK": {"S": f"USER#{user_id}"},
                "email": {"S": email},
                "fullName": {"S": name},
                "role": {"S": role},
                "status": {"S": "ACTIVE"},
                "createdAt": {"S": timestamp},
            },
            ConditionExpression="attribute_not_exists(PK)",
        )
    except Exception as exc:
        print(f"Failed to write user to DynamoDB: {exc}")

    return event
```

![Upload Lambda zip bundle](/images/5-Workshop/5.4/32-lambda-upload-zip.png)

![Lambda code updated successfully](/images/5-Workshop/5.4/33-lambda-code-updated.png)

20. Verify **Configuration -> General configuration** (`128 MB`, `3 sec` timeout) and add **Environment variable**:
    - Key: `TABLE_NAME`
    - Value: `reloop2-core-table`

![Verify Lambda general configuration](/images/5-Workshop/5.4/34-lambda-general-config.png)

![Add TABLE_NAME environment variable](/images/5-Workshop/5.4/35-lambda-env-table-name.png)

![Environment variable saved](/images/5-Workshop/5.4/36-lambda-env-saved.png)

---

### Part E — Attach Post-Confirmation Trigger in Cognito

21. Return to Cognito **User Pool `reloop2-user-pool` -> Extensions -> Lambda triggers**, and click **Add Lambda trigger**.

![Cognito Lambda triggers list initially empty](/images/5-Workshop/5.4/37-pool-extensions-empty.png)

22. Configure:
    - **Trigger type:** **Sign-up**
    - **Sign-up trigger:** **Post confirmation trigger**
    - **Lambda function:** `reloop2-post-confirmation`
    Then click **Add Lambda trigger** (Cognito automatically adds the Lambda resource-based invoke permission).

![Select Post confirmation trigger and Lambda](/images/5-Workshop/5.4/38-trigger-post-confirmation.png)

![Post confirmation trigger attached in Cognito](/images/5-Workshop/5.4/39-trigger-added.png)
