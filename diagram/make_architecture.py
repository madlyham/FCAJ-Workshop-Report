"""Sinh sơ đồ kiến trúc ReLoop dạng draw.io (icon AWS chính thức, thư viện mxgraph.aws4).

Chạy:     python diagram/make_architecture.py → static/images/2-Proposal/reloop-architecture.drawio (mở được bằng draw.io)
Xuất PNG: node diagram/export_png.mjs        → static/images/2-Proposal/reloop-architecture.png (viewer draw.io trong Chrome headless)
Số liệu trên sơ đồ lấy từ infra/*.tf ngày 2026-11-08 (bố cục sửa 2026-11-16: CloudFront/WAF web ra ngoài Region, thêm post-confirmation, x-origin-verify;
2026-11-19: đường nối không cắt chữ dưới icon (exitDy/entryDy), Lambda gọi Bedrock trực tiếp (bỏ mũi tên Rekognition → Bedrock),
bỏ số tài khoản, log WAF, khung Developer → GitHub → CI + đường deploy ③).
"""
import sys
from pathlib import Path
from xml.sax.saxutils import escape

HERE = Path(__file__).parent.parent / 'static' / 'images' / '2-Proposal'  # nơi Hugo lấy ảnh
# --simple: CÙNG bố cục, icon, đường nối; chỉ bớt chữ (dưới icon chỉ tên dịch vụ, đường nối không nhãn trừ số ① ② ③)
# → reloop-architecture-simple.drawio, xuất PNG: node diagram/export_png.mjs reloop-architecture-simple
SIMPLE = '--simple' in sys.argv
NAME = 'reloop-architecture-simple' if SIMPLE else 'reloop-architecture'


def pick(label: str, short: str | None) -> str:
    """Bản gọn: dùng `short` nếu có, không thì dòng đầu (tên dịch vụ)."""
    if not SIMPLE:
        return label
    return short or label.split('\n')[0]

COLORS = {
    'net': '#8C4FFF',  # Networking & Content Delivery
    'compute': '#ED7100',
    'db': '#C925D1',
    'storage': '#7AA116',
    'security': '#DD344C',
    'ml': '#01A88D',
    'mgmt': '#E7157B',  # Management & Governance / Application Integration
}

cells: list[str] = []
_id = [10]


def nid() -> str:
    _id[0] += 1
    return f'n{_id[0]}'


def text(label: str) -> str:
    """Nhãn nhiều dòng: draw.io (html=1) cần <br> thay cho xuống dòng."""
    return escape(label.replace('\n', '<br>'))


def node(x, y, style, label, size=64):
    i = nid()
    cells.append(
        f'<mxCell id="{i}" value="{text(label)}" style="{style}" vertex="1" parent="1">'
        f'<mxGeometry x="{x}" y="{y}" width="{size}" height="{size}" as="geometry"/></mxCell>'
    )
    return i


BASE = ('sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;dashed=0;verticalLabelPosition=bottom;'
        'verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;labelBackgroundColor=#ffffff;')


def icon(x, y, res, cat, label, short=None):
    return node(x, y, BASE + f'strokeColor=#ffffff;shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.{res};fillColor={COLORS[cat]};', pick(label, short))


def plain_icon(x, y, shape, label, short=None):
    return node(x, y, BASE + f'fillColor=#232F3D;strokeColor=none;shape=mxgraph.aws4.{shape};', pick(label, short))


def group(x, y, w, h, gr, label, stroke, dashed=False):
    i = nid()
    style = (
        'outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=13;fontStyle=1;container=0;pointerEvents=0;'
        f'collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.{gr};strokeColor={stroke};fillColor=none;'
        f'verticalAlign=top;align=left;spacingLeft=30;fontColor={stroke};dashed={1 if dashed else 0};'
    )
    cells.append(
        f'<mxCell id="{i}" value="{text(label)}" style="{style}" vertex="1" parent="1">'
        f'<mxGeometry x="{x}" y="{y}" width="{w}" height="{h}" as="geometry"/></mxCell>'
    )


def box(x, y, w, h, label, stroke, align='left', short=None, valign='top'):
    """Khung nét đứt không icon (vùng biên toàn cầu, khung mã nguồn + deploy, cụm chức năng của bản gọn)."""
    label = pick(label, short)
    i = nid()
    style = (f'rounded=0;whiteSpace=wrap;html=1;fillColor=none;dashed=1;strokeColor={stroke};fontColor={stroke};'
             f'fontSize=12;fontStyle=1;verticalAlign={valign};align={align};spacingLeft=8;spacingRight=8;spacingBottom=2;'
             'mxgraph.aws4.group;')
    cells.append(
        f'<mxCell id="{i}" value="{text(label)}" style="{style}" vertex="1" parent="1">'
        f'<mxGeometry x="{x}" y="{y}" width="{w}" height="{h}" as="geometry"/></mxCell>'
    )


# chiều cao nhãn dưới icon (bản đủ 3 dòng, bản gọn ≤ 2 dòng): đường ra / vào đáy icon bắt đầu dưới chữ, không cắt chữ
LABEL_GAP = 38 if SIMPLE else 54


def edge(src, dst, label='', dashed=False, points=(), exit_=None, entry=None, color='#545B64',
         exit_dy=0, entry_dy=0, label_pos=0):
    """label_pos: vị trí nhãn dọc đường nối, -1 (đầu) … 0 (giữa) … 1 (cuối)."""
    if SIMPLE:
        label = label[0] if label[:1] in ('①', '②', '③') else ''  # bản gọn: chỉ giữ số bước
    i = nid()
    style = (f'edgeStyle=orthogonalEdgeStyle;html=1;rounded=1;endArrow=block;endFill=1;strokeWidth=1.6;strokeColor={color};'
             'fontSize=11;fontColor=#232F3E;labelBackgroundColor=#ffffff;')
    if SIMPLE and label:
        style = style.replace('fontSize=11;', 'fontSize=20;')  # số ① ② ③ đứng riêng: cỡ 11 bé không đọc được
    if dashed:
        style += 'dashed=1;'
    if exit_:
        style += f'exitX={exit_[0]};exitY={exit_[1]};exitDx=0;exitDy={exit_dy};exitPerimeter=0;'
    if entry:
        style += f'entryX={entry[0]};entryY={entry[1]};entryDx=0;entryDy={entry_dy};entryPerimeter=0;'
    pts = ''.join(f'<mxPoint x="{px}" y="{py}"/>' for px, py in points)
    arr = f'<Array as="points">{pts}</Array>' if pts else ''
    cells.append(
        f'<mxCell id="{i}" value="{text(label)}" style="{style}" edge="1" parent="1" source="{src}" target="{dst}">'
        f'<mxGeometry x="{label_pos}" relative="1" as="geometry">{arr}</mxGeometry></mxCell>'
    )


# ---- Khung. CloudFront + WAF web là dịch vụ toàn cầu (web ACL scope CLOUDFRONT tạo ở us-east-1) → nằm ngoài khung Region.
group(190, 20, 1570, 930, 'group_aws_cloud_alt', 'AWS Cloud', '#232F3E')  # không ghi số tài khoản: báo cáo đăng công khai
group(600, 60, 1140, 870, 'group_region', 'Region ap-southeast-1 (Singapore)', '#00A4A6', dashed=True)
box(225, 330, 355, 235, 'Global edge (WAF scope CLOUDFRONT · us-east-1)', COLORS['net'], short='Global edge')
# Mã nguồn + deploy nằm ngoài AWS: GitHub Actions chỉ kiểm code (không có quyền AWS); deploy chạy infra/deploy.sh từ máy dev.
box(20, 975, 700, 180, 'Source code & deploy (outside AWS)', '#232F3E', align='right')  # chữ bên phải: đường ③ đi lên ở bên trái
if SIMPLE:
    # Bản gọn: khung nhóm theo chức năng (PO 19/11, theo ảnh mẫu) — KHÔNG dời icon / đường nối, chỉ vẽ khung quanh vị trí sẵn có.
    # Tên khung đặt ở chỗ không có đường nối đi qua (vài khung để tên ở đáy / bên phải vì vậy).
    box(625, 140, 795, 116, 'Sign-up & sign-in', COLORS['security'])
    box(810, 380, 340, 140, 'API backend', COLORS['compute'], valign='bottom')
    box(1270, 264, 150, 246, 'Data storage', COLORS['db'], valign='bottom')
    box(1270, 560, 370, 140, 'AI processing', COLORS['ml'])
    box(1000, 730, 420, 140, 'Monitoring & alerts', COLORS['mgmt'], align='right')

# ---- Người dùng / người phát triển (ngoài AWS)
users = plain_icon(50, 400, 'users', 'Users (web browser)\nGuests · Tier-1 / Tier-2\npartners · Admin')
dev = plain_icon(60, 1020, 'client', 'Developer\nlaptop · AWS CLI\nTerraform · deploy.sh')
repo = plain_icon(320, 1020, 'git_repository', 'GitHub repository\nbranch main\npull requests')
ci = plain_icon(580, 1020, 'gear', 'GitHub Actions (CI)\ntypecheck · tests · build\n(no AWS credentials)')

# ---- Biên (edge, toàn cầu)
waf_web = icon(270, 400, 'waf', 'security', 'AWS WAF (web)\n3 managed rule groups\n2 rate limits (429)\nblocked → logs (3 days)')
cf = icon(450, 400, 'cloudfront', 'net', 'Amazon CloudFront\nCSP · HSTS · OAC\n/api/* → API')

# ---- Region: đăng nhập
waf_auth = icon(650, 170, 'waf', 'security', 'AWS WAF (auth)\non user pool\n300 tries / 5 min / IP\nblocked → logs (3 days)')
cognito = icon(850, 170, 'cognito', 'security', 'Amazon Cognito\nuser pool · groups\nAdmins / FinanceAdmins')
postconf = icon(1310, 154, 'lambda', 'compute', 'AWS Lambda\nreloop-auth-post-confirmation\n(creates user profile)')

# ---- Region: web tĩnh, API + xử lý
s3web = icon(650, 620, 's3', 'storage', 'Amazon S3\nweb bundle\n(private bucket)', short='Amazon S3\n(website)')
apigw = icon(850, 400, 'api_gateway', 'net', 'Amazon API Gateway\nHTTP API · JWT authorizer\n20 req/s · burst 50')
lam = icon(1060, 400, 'lambda', 'compute', 'AWS Lambda\nreloop-dev-api · Node.js 22\narm64 · 512 MB')
evb = icon(850, 640, 'eventbridge', 'mgmt', 'Amazon EventBridge\nrate(15 minutes)\nexpiry · invoices · reminders')

# ---- Dữ liệu + AI
ddb = icon(1310, 270, 'dynamodb', 'db', 'Amazon DynamoDB\nsingle table + GSI1\non-demand · PITR · TTL')
s3img = icon(1310, 400, 's3', 'storage', 'Amazon S3 (photos)\npresigned POST / GET\nlifecycle 1 / 90 days')
rek = icon(1310, 600, 'rekognition', 'ml', 'Amazon Rekognition\nimage moderation\n+ text detection')
bed = icon(1550, 600, 'bedrock', 'ml', 'Amazon Bedrock\nKimi K3 (photo analysis)\nGuardrail (photo text)')

# ---- Giám sát + IaC
cw = icon(1060, 770, 'cloudwatch_2', 'mgmt', 'Amazon CloudWatch\nlogs 7 days · 10 alarms\ndashboard')
sns = icon(1310, 770, 'sns', 'mgmt', 'Amazon SNS\nemail alerts\nto Admin')
tfstate = icon(650, 760, 's3', 'storage', 'Amazon S3\nTerraform state\n(versioned)', short='Amazon S3\n(Terraform state)')

# ---- Luồng chính
edge(users, waf_web, 'HTTPS')
edge(waf_web, cf)
edge(cf, s3web, 'static files (OAC)', exit_=(0.5, 1), exit_dy=LABEL_GAP, entry=(0, 0.5), points=[(482, 652)])
edge(cf, apigw, '/api/* + secret\nx-origin-verify')
edge(apigw, lam, 'invoke')
edge(lam, ddb, 'read / write', exit_=(0.75, 0), entry=(0, 0.5), points=[(1108, 302)])
edge(lam, s3img, 'presign · tag')
edge(lam, rek, 'moderate · read text', exit_=(0.75, 1), exit_dy=LABEL_GAP, entry=(0, 0.5), points=[(1108, 632)],
     label_pos=0.45)
# Lambda gọi Bedrock trực tiếp (Rekognition không gọi Bedrock): Converse ở lượt chạy nền (Lambda tự gọi lại chính nó,
# InvocationType Event) + ApplyGuardrail cho chữ Rekognition đọc từ ảnh (backend/src/storage/textScreener.ts).
edge(lam, bed, 'AI photo analysis: Converse (async self-invoke)\n+ ApplyGuardrail on photo text', exit_=(1, 0.85),
     entry=(0.5, 0), points=[(1240, 454), (1240, 550), (1582, 550)], label_pos=0.3)
edge(evb, lam, 'scheduled sweep', exit_=(0.5, 0), entry=(0.25, 1), entry_dy=LABEL_GAP, points=[(882, 570), (1076, 570)])
edge(lam, cw, 'logs · metrics', exit_=(0.5, 1), exit_dy=LABEL_GAP, entry=(0.5, 0), label_pos=0.45)
edge(cw, sns, 'alarm')

# ---- Đăng nhập + ảnh đi thẳng từ trình duyệt (không qua CloudFront / API Gateway)
edge(users, waf_auth, 'sign up / sign in (direct to Cognito)', exit_=(0.5, 0), entry=(0, 0.5), points=[(82, 202)])
edge(waf_auth, cognito)
edge(apigw, cognito, 'verify JWT (JWKS)', dashed=True, exit_=(0.5, 0), entry=(0.5, 1), entry_dy=LABEL_GAP)
edge(cognito, lam, 'pre sign-up trigger', dashed=True, exit_=(1, 0.5), entry=(0.25, 0), points=[(1076, 202)])
edge(cognito, postconf, 'post-confirmation trigger', dashed=True, exit_=(1, 0.25), entry=(0, 0.5))
edge(postconf, ddb, '', exit_=(1, 0.5), entry=(1, 0.5), points=[(1440, 186), (1440, 302)])
edge(users, s3img, 'upload / view photos (presigned URL, direct to S3)', dashed=True, exit_=(0.25, 0), entry=(1, 0.5),
     points=[(66, 110), (1470, 110), (1470, 432)], color='#7AA116')

# ---- Mã nguồn + deploy (đánh số theo thứ tự)
edge(dev, repo, '① git push / PR')
edge(repo, ci, '② on push / PR')
edge(dev, tfstate, '③ deploy.sh: terraform apply\n(Lambda · API · CloudFront · S3 web)', dashed=True,
     exit_=(0.5, 0), entry=(0, 0.5), points=[(92, 792)], label_pos=0.25)

groups = [c for c in cells if 'mxgraph.aws4.group;' in c]
edges = [c for c in cells if 'edge="1"' in c]
vertices = [c for c in cells if c not in groups and c not in edges]

xml = (
    '<mxfile host="reloop-proposal"><diagram id="reloop" name="ReLoop architecture">'
    '<mxGraphModel dx="1600" dy="960" grid="0" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" '
    'page="1" pageScale="1" pageWidth="1800" pageHeight="1170" background="#ffffff" math="0" shadow="0"><root>'
    '<mxCell id="0"/><mxCell id="1" parent="0"/>' + ''.join(groups + edges + vertices) + '</root></mxGraphModel></diagram></mxfile>'
)
(HERE / f'{NAME}.drawio').write_text(xml, encoding='utf-8')
print('ok', len(cells), 'cells')
