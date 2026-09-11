# osaka-2027.html (아티팩트용 조각) → index.html (GitHub Pages용 완전한 문서)
# 일정을 고친 뒤 이 스크립트를 실행하면 웹 버전이 다시 만들어집니다.
#   powershell -ExecutionPolicy Bypass -File build.ps1

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$src  = Join-Path $root 'osaka-2027.html'
$out  = Join-Path $root 'index.html'

$raw = Get-Content -Raw -Encoding UTF8 $src

# <style> 블록까지는 <head>로, 나머지는 <body>로 보냅니다.
$i = $raw.IndexOf('</style>')
if ($i -lt 0) { throw "osaka-2027.html 에서 </style> 를 찾지 못했습니다." }
$headExtra = $raw.Substring(0, $i + 8)
$bodyHtml  = $raw.Substring($i + 8)

$head = @'
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="2027년 1월 13~17일, 성인 4명 오사카 4박 5일 여행 일정표 10장. 3일차 교토 투어 2인·유니버설 스튜디오 2인 분리 운영, 구글맵 길찾기와 숙소 좌표 고정, 패스권 판정과 예산 배분.">
<meta name="robots" content="noindex, nofollow, noarchive, nosnippet">
<meta name="googlebot" content="noindex, nofollow">
<meta name="theme-color" content="#eceeef" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#0f161c" media="(prefers-color-scheme: dark)">
<meta property="og:type" content="website">
<meta property="og:title" content="오사카 4박 5일">
<meta property="og:description" content="2027.01.13–17 · 성인 4명 · 10장 · 3일차 교토 2인 / USJ 2인 분리">
<link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🍢</text></svg>">
<style>
  :root { color-scheme: light dark; }
  body { margin: 0; font: 14px system-ui, sans-serif; }
  img { max-width: 100%; }
  [hidden] { display: none !important; }
</style>
'@

$foot = @'

</body>
</html>
'@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($out, $head + $headExtra + "`n</head>`n<body>" + $bodyHtml + $foot, $utf8NoBom)

Write-Host "index.html 생성 완료 ($([math]::Round((Get-Item $out).Length / 1KB, 1)) KB)"
