# Vẽ lại toàn bộ sơ đồ phần Workshop từ CÙNG một nguồn với sơ đồ Proposal (bản gọn có khung nhóm).
# 1) make_architecture.py --workshop → docs/diagrams/overview.drawio (id ổn định)
# 2) focus_view.py (skill aws-grapher) → docs/diagrams/focus-5.N.drawio: giữ icon của mục, làm mờ phần còn lại
# 3) export_png.mjs (Chrome headless + viewer draw.io, cần mạng) → static/images/5-Workshop/5.N/architecture.png
# Chạy từ thư mục gốc repo:  powershell -File diagram/make_workshop.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$focus = "$env:USERPROFILE\.agents\skills\aws-grapher\scripts\focus_view.py"
$dia = Join-Path $root 'docs\diagrams'
$img = Join-Path $root 'static\images\5-Workshop'

python -B (Join-Path $root 'diagram\make_architecture.py') --workshop
if ($LASTEXITCODE) { throw 'make_architecture failed' }

$all = 'users dev repo ci waf_web cf waf_auth cognito postconf s3web apigw lam evb ddb s3img rek bed cw sns tfstate'
$scope = [ordered]@{
  '5.2'  = 'dev bed cw sns'
  '5.3'  = 'ddb'
  '5.4'  = 'cognito postconf ddb'
  '5.5'  = 'users s3img'
  '5.6'  = 'cognito ddb apigw lam s3img'
  '5.7'  = 'lam s3img rek bed'
  '5.8'  = 'dev cognito cf apigw s3web'
  '5.9'  = 'users waf_auth cognito waf_web cf'
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
