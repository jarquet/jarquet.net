# Renders public/og.png (1200x630 social preview) and public/apple-touch-icon.png (180x180)
# with .NET System.Drawing and Windows system fonts. No dependencies to install.
#   powershell -NoProfile -ExecutionPolicy Bypass -File assets-src\render.ps1
Add-Type -AssemblyName System.Drawing

$out = Join-Path (Split-Path $PSScriptRoot -Parent) "public"

function New-Color([string]$hex, [int]$alpha = 255) {
    $c = [System.Drawing.ColorTranslator]::FromHtml($hex)
    return [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B)
}

function New-RoundedRect([single]$x, [single]$y, [single]$w, [single]$h, [single]$r) {
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $r * 2
    $p.AddArc($x, $y, $d, $d, 180, 90)
    $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
    $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
    $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
    $p.CloseFigure()
    return $p
}

function Set-Quality($g) {
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
}

$px = [System.Drawing.GraphicsUnit]::Pixel
# Windows PowerShell 5.1 reads this file as ANSI, so build non-ASCII characters from code points.
$mid = [string][char]0x00B7
$center = New-Object System.Drawing.StringFormat
$center.Alignment = [System.Drawing.StringAlignment]::Center
$center.LineAlignment = [System.Drawing.StringAlignment]::Center

# ---------------- og.png ----------------
$W = 1200; $H = 630
$bmp = New-Object System.Drawing.Bitmap $W, $H
$g = [System.Drawing.Graphics]::FromImage($bmp)
Set-Quality $g

$g.Clear((New-Color "#0d1117"))
$dot = New-Object System.Drawing.SolidBrush (New-Color "#85a6ff" 34)
for ($y = 12; $y -lt $H; $y += 24) { for ($x = 12; $x -lt $W; $x += 24) { $g.FillEllipse($dot, $x - 1.4, $y - 1.4, 2.8, 2.8) } }
$blue = New-Object System.Drawing.SolidBrush (New-Color "#2448b5")
$g.FillRectangle($blue, 0, 0, 14, $H)

$L = 96
$mark = New-RoundedRect $L 92 64 64 15
$g.FillPath($blue, $mark)
$fMark = New-Object System.Drawing.Font("Consolas", 27, [System.Drawing.FontStyle]::Bold, $px)
$white = New-Object System.Drawing.SolidBrush (New-Color "#ffffff")
$g.DrawString("JF", $fMark, $white, (New-Object System.Drawing.RectangleF($L, 92, 64, 66)), $center)

$fUrl = New-Object System.Drawing.Font("Consolas", 28, [System.Drawing.FontStyle]::Bold, $px)
$muted = New-Object System.Drawing.SolidBrush (New-Color "#9ba4b4")
$right = New-Object System.Drawing.StringFormat
$right.Alignment = [System.Drawing.StringAlignment]::Far
$right.LineAlignment = [System.Drawing.StringAlignment]::Center
$g.DrawString("jarquet.net", $fUrl, $muted, (New-Object System.Drawing.RectangleF(600, 92, 504, 64)), $right)

$text = New-Object System.Drawing.SolidBrush (New-Color "#e8ebf1")
$fName = New-Object System.Drawing.Font("Segoe UI", 92, [System.Drawing.FontStyle]::Bold, $px)
$g.DrawString("Jonathan Farro", $fName, $text, ($L - 6), 196)

$fRole = New-Object System.Drawing.Font("Segoe UI", 34, [System.Drawing.FontStyle]::Regular, $px)
$g.DrawString("Senior Software Engineer  $mid  Backend Systems & Data Platforms", $fRole, $muted, ($L - 2), 324)

$accent = New-Object System.Drawing.SolidBrush (New-Color "#85a6ff")
$fStack = New-Object System.Drawing.Font("Consolas", 27, [System.Drawing.FontStyle]::Regular, $px)
$g.DrawString("Python $mid C# $mid Rust $mid AWS $mid 15+ years", $fStack, $accent, $L, 420)

$green = New-Object System.Drawing.SolidBrush (New-Color "#3ccf91")
$g.FillEllipse($green, $L, 524, 16, 16)
$fOpen = New-Object System.Drawing.Font("Segoe UI", 27, [System.Drawing.FontStyle]::Regular, $px)
$g.DrawString("Open to Senior & Staff Backend and Data Engineering roles", $fOpen, $text, ($L + 28), 512)

$bmp.Save((Join-Path $out "og.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "wrote $(Join-Path $out 'og.png')"

# ---------------- apple-touch-icon.png ----------------
$S = 180
$bmp = New-Object System.Drawing.Bitmap $S, $S
$g = [System.Drawing.Graphics]::FromImage($bmp)
Set-Quality $g
$g.Clear((New-Color "#2448b5"))   # iOS rounds the corners itself
$fIcon = New-Object System.Drawing.Font("Consolas", 78, [System.Drawing.FontStyle]::Bold, $px)
$g.DrawString("JF", $fIcon, $white, (New-Object System.Drawing.RectangleF(0, 0, $S, ($S + 6))), $center)
$bmp.Save((Join-Path $out "apple-touch-icon.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "wrote $(Join-Path $out 'apple-touch-icon.png')"
