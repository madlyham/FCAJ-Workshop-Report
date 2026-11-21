# Redraw every Workshop diagram from ONE source: the frame picture ('frame for workshop.jpg') rebuilt as draw.io XML.
# 1) make_frame.py → docs/diagrams/overview.drawio (stable ids)
# 2) focus_view.py (aws-grapher skill) → docs/diagrams/focus-5.N.drawio: section icons solid, the rest faded
# 3) export_png.mjs (headless Edge + draw.io viewer, needs network) → static/images/5-Workshop/5.N/architecture.png
# Run from repo root:  powershell -File diagram/make_workshop.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$focus = "$env:USERPROFILE\.agents\skills\aws-grapher\scripts\focus_view.py"
$dia = Join-Path $root 'docs\diagrams'
$img = Join-Path $root 'static\images\5-Workshop'

python -B (Join-Path $root 'diagram\make_frame.py')
if ($LASTEXITCODE) { throw 'make_frame failed' }

$all = 'users waf_web cf cognito postconf s3web apigw lam evb ddb s3img rek bed cw sns'
$scope = [ordered]@{
  '5.2'  = 'bed cw sns'
  '5.3'  = 'ddb'
  '5.4'  = 'cognito postconf ddb'
  '5.5'  = 'users s3img'
  '5.6'  = 'cognito ddb apigw lam s3img'
  '5.7'  = 'lam s3img rek bed'
  '5.8'  = 'cognito cf apigw s3web'
  '5.9'  = 'users cognito waf_web cf'
  '5.10' = 'ddb lam evb'
  '5.11' = 'apigw lam cw sns'
  '5.12' = $all
}

node (Join-Path $root 'diagram\export_png.mjs') (Join-Path $dia 'overview.drawio') (Join-Path $img '5.1\overview.png')
if ($LASTEXITCODE) { throw 'export overview failed' }
foreach ($k in $scope.Keys) {
  $f = Join-Path $dia "focus-$k.drawio"
  python -B $focus (Join-Path $dia 'overview.drawio') $f @($scope[$k] -split ' ')
  if ($LASTEXITCODE) { throw "focus $k failed" }
  node (Join-Path $root 'diagram\export_png.mjs') $f (Join-Path $img "$k\architecture.png")
  if ($LASTEXITCODE) { throw "export $k failed" }
}
