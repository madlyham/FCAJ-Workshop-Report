"""Workshop overview diagram (draw.io XML), rebuilt from 'frame for workshop.jpg' (2560x1387).

Layout = frame pixel coordinates x 0.85 (frame icons ~92 px -> 78 px), snapped to 10.
Stable ids (users, lam, ddb...) so aws-grapher focus_view.py can make section views 5.2-5.12.
Run:  python -B diagram/make_frame.py  -> docs/diagrams/overview.drawio
"""
from pathlib import Path
from xml.sax.saxutils import escape

OUT = Path(__file__).parent.parent / 'docs' / 'diagrams' / 'overview.drawio'
COLORS = {'net': '#8C4FFF', 'compute': '#ED7100', 'db': '#C925D1', 'storage': '#7AA116',
          'security': '#DD344C', 'ml': '#01A88D', 'mgmt': '#E7157B'}
NUM = dict(enumerate('❶❷❸❹❺❻❼❽❾❿⓫⓬⓭', 1))  # black circled step numbers, as in the frame
LABEL_GAP = 54  # edges leaving / entering an icon bottom start below its 3-line label
groups: list[str] = []
edges: list[str] = []
icons: list[str] = []
_n = [0]


def text(s: str) -> str:
    return escape(s.replace('\n', '<br>'))


def vertex(bucket, cid, x, y, w, h, style, label):
    bucket.append(f'<mxCell id="{cid}" value="{text(label)}" style="{style}" vertex="1" parent="1">'
                  f'<mxGeometry x="{x}" y="{y}" width="{w}" height="{h}" as="geometry"/></mxCell>')
    return cid


BASE = ('sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;dashed=0;verticalLabelPosition=bottom;'
        'verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;labelBackgroundColor=#ffffff;')


def icon(cid, x, y, res, cat, label):
    return vertex(icons, cid, x, y, 78, 78, BASE + f'strokeColor=#ffffff;shape=mxgraph.aws4.resourceIcon;'
                  f'resIcon=mxgraph.aws4.{res};fillColor={COLORS[cat]};', label)


def group(cid, x, y, w, h, label, stroke, gr=None, dashed=False):
    # every frame keeps 'mxgraph.aws4.group' in its style so focus_view.py never fades it
    style = (f'html=1;whiteSpace=wrap;fontSize=13;fontStyle=1;container=0;pointerEvents=0;collapsible=0;recursiveResize=0;'
             f'fillColor=none;strokeColor={stroke};fontColor={stroke};verticalAlign=top;align=left;dashed={int(dashed)};')
    style += (f'outlineConnect=0;gradientColor=none;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.{gr};spacingLeft=30;'
              if gr else 'outlineConnect=0;shape=mxgraph.aws4.group;grIcon=;spacingLeft=8;')
    return vertex(groups, cid, x, y, w, h, style, label)


def edge(src, dst, label='', step=None, dashed=False, points=(), exit_=None, entry=None, color='#545B64',
         exit_dy=0, entry_dy=0, label_pos=0, both=False):
    if step:
        label = f'{NUM[step]} {label}'
    _n[0] += 1
    style = (f'edgeStyle=orthogonalEdgeStyle;html=1;rounded=1;endArrow=block;endFill=1;strokeWidth=2;strokeColor={color};'
             'fontSize=11;fontColor=#232F3E;labelBackgroundColor=#ffffff;')
    if both:
        style += 'startArrow=block;startFill=1;'
    if dashed:
        style += 'dashed=1;dashPattern=8 4;'
    if exit_:
        style += f'exitX={exit_[0]};exitY={exit_[1]};exitDx=0;exitDy={exit_dy};exitPerimeter=0;'
    if entry:
        style += f'entryX={entry[0]};entryY={entry[1]};entryDx=0;entryDy={entry_dy};entryPerimeter=0;'
    pts = ''.join(f'<mxPoint x="{px}" y="{py}"/>' for px, py in points)
    arr = f'<Array as="points">{pts}</Array>' if pts else ''
    edges.append(f'<mxCell id="e{_n[0]}" value="{text(label)}" style="{style}" edge="1" parent="1" source="{src}" '
                 f'target="{dst}"><mxGeometry x="{label_pos}" relative="1" as="geometry">{arr}</mxGeometry></mxCell>')


# ---- Frames (3, as in the frame picture). No account number: the report is public.
group('g_cloud', 220, 10, 1940, 1150, 'AWS Cloud', '#232F3E', gr='group_aws_cloud_alt')
group('g_edge', 280, 250, 420, 430, 'Global edge (WAF scope CLOUDFRONT · us-east-1)', COLORS['net'], dashed=True)
group('g_region', 730, 60, 1390, 1060, 'Region ap-southeast-1 (Singapore)', '#00A4A6', gr='group_region', dashed=True)

# ---- Icons (15). Top-left corner; centre = +39.
vertex(icons, 'users', 40, 480, 78, 78, BASE + 'fillColor=#232F3D;strokeColor=none;shape=mxgraph.aws4.users;',
       'Users (web browser)\nGuests · Tier-1 / Tier-2\npartners · Admin')
icon('waf_web', 380, 290, 'waf', 'security', 'AWS WAF (web)\n3 managed rule groups\n2 rate limits (429)\nblocked → logs (3 days)')
icon('cf', 540, 480, 'cloudfront', 'net', 'Amazon CloudFront\nCSP · HSTS · OAC\n/api/* → API')
icon('s3web', 780, 750, 's3', 'storage', 'Amazon S3\nweb bundle\n(private bucket)')
icon('cognito', 1010, 200, 'cognito', 'security', 'Amazon Cognito\nuser pool · groups\nAdmins / FinanceAdmins')
icon('apigw', 1010, 480, 'api_gateway', 'net', 'Amazon API Gateway\nHTTP API · JWT authorizer\n20 req/s · burst 50')
icon('evb', 1010, 780, 'eventbridge', 'mgmt', 'Amazon EventBridge\nrate(15 minutes)\nexpiry · invoices · reminders')
icon('postconf', 1630, 180, 'lambda', 'compute', 'AWS Lambda\nreloop-auth-post-confirmation\n(creates user profile)')
icon('ddb', 1630, 330, 'dynamodb', 'db', 'Amazon DynamoDB\nsingle table + GSI1\non-demand · PITR · TTL')
icon('lam', 1290, 480, 'lambda', 'compute', 'AWS Lambda\nreloop-dev-api · Node.js 22\narm64 · 512 MB')
icon('s3img', 1630, 480, 's3', 'storage', 'Amazon S3 (photos)\npresigned POST / GET\nlifecycle 1 / 90 days')
icon('rek', 1590, 720, 'rekognition', 'ml', 'Amazon Rekognition\nimage moderation\n+ text detection')
icon('bed', 1900, 720, 'bedrock', 'ml', 'Amazon Bedrock\nKimi K3 (photo analysis)\nGuardrail (photo text)')
icon('cw', 1290, 940, 'cloudwatch_2', 'mgmt', 'Amazon CloudWatch\nlogs 7 days · 10 alarms\ndashboard')
icon('sns', 1590, 940, 'sns', 'mgmt', 'Amazon SNS\nemail alerts\nto Admin')

# ---- Numbered flow ❶-⓭ (waypoints use icon centres = top-left + 39)
edge('users', 'cf', 'HTTPS (TLS at CloudFront)', 1, label_pos=-0.2)
edge('cf', 's3web', 'static files (OAC)', 2, exit_=(0.5, 1), exit_dy=LABEL_GAP, entry=(0, 0.5), points=[(579, 789)])
edge('users', 'cognito', 'sign up / sign in (direct to Cognito)', 3, exit_=(0.75, 0), entry=(0, 0.5),
     points=[(98.5, 239)], label_pos=0.3)
edge('cf', 'apigw', '/api/* + secret\nx-origin-verify', 4)
edge('apigw', 'lam', 'invoke', 5)
edge('lam', 'ddb', 'read / write', 6, exit_=(0.75, 0), entry=(0, 0.5), points=[(1348.5, 369)], label_pos=0.4)
edge('lam', 's3img', 'presign · tag', 7)
edge('users', 's3img', 'upload / view photos (presigned URL, direct to S3)', 8, dashed=True, both=True,
     exit_=(0.25, 0), entry=(1, 0.5), points=[(59.5, 120), (1850, 120), (1850, 519)], color='#7AA116')
edge('lam', 'rek', 'moderate · read text', 9, exit_=(0.75, 1), exit_dy=LABEL_GAP, entry=(0, 0.5),
     points=[(1348.5, 759)], label_pos=0.45)
edge('lam', 'bed', 'AI photo analysis: Converse (async self-invoke)\n+ ApplyGuardrail on photo text', 10,
     exit_=(1, 0.85), entry=(0.5, 0), points=[(1470, 546.3), (1470, 650), (1939, 650)], label_pos=0.1)
edge('evb', 'lam', 'scheduled sweep', 11, exit_=(0.5, 0), entry=(0.25, 1), entry_dy=LABEL_GAP,
     points=[(1049, 700), (1309.5, 700)])
edge('lam', 'cw', 'logs · metrics', 12, exit_=(0.5, 1), exit_dy=LABEL_GAP, entry=(0.5, 0), label_pos=0.45)
edge('cw', 'sns', 'alarm', 13)

# ---- Unnumbered (dashed = trigger / config link)
edge('cf', 'waf_web', 'associated web ACL', dashed=True, exit_=(0.5, 0), entry=(1, 0.5), points=[(579, 329)])
edge('apigw', 'cognito', 'verify JWT (JWKS)', dashed=True, exit_=(0.5, 0), entry=(0.5, 1), entry_dy=LABEL_GAP)
edge('cognito', 'postconf', 'post-confirmation trigger', dashed=True, exit_=(1, 0.2436), entry=(0, 0.5))
edge('cognito', 'lam', 'pre sign-up trigger', dashed=True, exit_=(1, 0.6875), entry=(0.25, 0),
     points=[(1309.5, 253.6)], label_pos=-0.5)
edge('postconf', 'ddb', 'create profile', exit_=(1, 0.5), entry=(1, 0.5), points=[(1790, 219), (1790, 369)])

xml = ('<mxfile host="reloop-workshop"><diagram id="overview" name="ReLoop workshop overview">'
       '<mxGraphModel dx="2200" dy="1200" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" '
       'page="1" pageScale="1" pageWidth="2200" pageHeight="1200" background="#ffffff" math="0" shadow="0"><root>'
       '<mxCell id="0"/><mxCell id="1" parent="0"/>' + ''.join(groups + edges + icons) + '</root></mxGraphModel></diagram></mxfile>')
OUT.write_text(xml, encoding='utf-8')
print('ok', len(groups), 'groups', len(edges), 'edges', len(icons), 'icons ->', OUT)
