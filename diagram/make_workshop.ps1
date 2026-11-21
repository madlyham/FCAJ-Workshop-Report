# Redraw every Workshop diagram from ONE source: docs/diagrams/overview.drawio (user-supplied base XML).
# To change the base picture: open overview.drawio in diagrams.net, edit, save, then rerun this script.
# 1) focus_view.py (aws-grapher skill) → docs/diagrams/focus-5.N.drawio: section icons solid, the rest faded
# 2) export_png.mjs (headless Edge + draw.io viewer, needs network) → static/images/5-Workshop/5.N/architecture.png
#    (exports a labels-in-front copy, see step 3 below)
# Run from repo root:  powershell -File diagram/make_workshop.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$focus = "$env:USERPROFILE\.agents\skills\aws-grapher\scripts\focus_view.py"
$dia = Join-Path $root 'docs\diagrams'
$img = Join-Path $root 'static\images\5-Workshop'

# Icon ids in overview.drawio:
# n19 Users, n20 WAF, n21 CloudFront, n22 Cognito, n23 Lambda post-confirm, n24 S3 website,
# n25 API Gateway, n26 Lambda API, n27 EventBridge, n28 DynamoDB, n29 S3 photos,
# n30 Rekognition, n31 Bedrock, n32 CloudWatch, n33 SNS
$all = 'n19 n20 n21 n22 n23 n24 n25 n26 n27 n28 n29 n30 n31 n32 n33'
$scope = [ordered]@{
  '5.2'  = 'n31'
  '5.3'  = 'n19 n20 n21 n24'
  '5.4'  = 'n19 n22 n23 n28'
  '5.5'  = 'n21 n22 n25 n26'
  '5.6'  = 'n23 n26 n28'
  '5.7'  = 'n19 n26 n29'
  '5.8'  = 'n26 n29 n30 n31'
  '5.9'  = 'n26 n27 n28'
  '5.10' = 'n26 n32 n33'
  '5.11' = $all
}

# 3) labels_front.py: copy with every arrow label on a white box in front of the lines.
#    Written to a temp folder only; overview.drawio and focus-*.drawio stay clean for editing.
$front = Join-Path $root 'diagram\labels_front.py'
# 1b) fade_groups.py: also fade a coloured section box when every icon inside it is faded.
$fadeGroups = Join-Path $root 'diagram\fade_groups.py'
$tmp = Join-Path $env:TEMP 'reloop-diagrams'
New-Item -ItemType Directory -Force $tmp | Out-Null
function Export-Front($drawio, $png) {
  $t = Join-Path $tmp (Split-Path $drawio -Leaf)
  python -B $front $drawio $t
  if ($LASTEXITCODE) { throw "labels_front $drawio failed" }
  node (Join-Path $root 'diagram\export_png.mjs') $t $png
  if ($LASTEXITCODE) { throw "export $png failed" }
}

Export-Front (Join-Path $dia 'overview.drawio') (Join-Path $img '5.1\overview.png')
foreach ($k in $scope.Keys) {
  $f = Join-Path $dia "focus-$k.drawio"
  python -B $focus (Join-Path $dia 'overview.drawio') $f @($scope[$k] -split ' ')
  if ($LASTEXITCODE) { throw "focus $k failed" }
  python -B $fadeGroups $f $f
  if ($LASTEXITCODE) { throw "fade_groups $k failed" }
  Export-Front $f (Join-Path $img "$k\architecture.png")
}
