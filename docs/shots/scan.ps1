# Helper: pemindai piksel untuk navigasi UI via warna (tanpa perlu melihat gambar).
Add-Type -AssemblyName System.Drawing

function Get-Bitmap {
  param([string]$Path)
  return [System.Drawing.Bitmap]::FromFile($Path)
}

# Cari kotak pembatas piksel yang mendekati warna target dalam area tertentu.
function Find-ColorBounds {
  param(
    [string]$Path, [int]$R, [int]$G, [int]$B,
    [int]$Tol = 30, [int]$XMin = 0, [int]$XMax = 1080,
    [int]$YMin = 0, [int]$YMax = 2400, [int]$Stride = 4,
    [int]$MinCount = 6
  )
  $bmp = Get-Bitmap $Path
  $rect = New-Object System.Drawing.Rectangle(0, 0, $bmp.Width, $bmp.Height)
  $data = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $bytes = New-Object byte[] ($data.Stride * $data.Height)
  [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)
  $bmp.UnlockBits($data)

  $minx = 99999; $miny = 99999; $maxx = -1; $maxy = -1; $count = 0
  for ($y = $YMin; $y -lt $YMax -and $y -lt $bmp.Height; $y += $Stride) {
    $row = $y * $data.Stride
    for ($x = $XMin; $x -lt $XMax -and $x -lt $bmp.Width; $x += $Stride) {
      $i = $row + ($x * 4)
      $b0 = $bytes[$i]; $g0 = $bytes[$i+1]; $r0 = $bytes[$i+2]
      if ([math]::Abs($r0 - $R) -le $Tol -and [math]::Abs($g0 - $G) -le $Tol -and [math]::Abs($b0 - $B) -le $Tol) {
        $count++
        if ($x -lt $minx) { $minx = $x }; if ($x -gt $maxx) { $maxx = $x }
        if ($y -lt $miny) { $miny = $y }; if ($y -gt $maxy) { $maxy = $y }
      }
    }
  }
  $bmp.Dispose()
  if ($count -lt $MinCount -or $maxx -lt 0) { return $null }
  [pscustomobject]@{
    Count = $count; MinX = $minx; MaxX = $maxx; MinY = $miny; MaxY = $maxy
    CX = [int](($minx + $maxx) / 2); CY = [int](($miny + $maxy) / 2)
    W = $maxx - $minx; H = $maxy - $miny
  }
}

# Rata-rata luminance area (0-255) — untuk deteksi mode gelap/terang.
function Get-Luminance {
  param([string]$Path, [int]$YMin = 0, [int]$YMax = 2400, [int]$Stride = 8)
  $bmp = Get-Bitmap $Path
  $rect = New-Object System.Drawing.Rectangle(0, 0, $bmp.Width, $bmp.Height)
  $data = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $bytes = New-Object byte[] ($data.Stride * $data.Height)
  [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)
  $bmp.UnlockBits($data)
  $sum = 0.0; $n = 0
  for ($y = $YMin; $y -lt $YMax -and $y -lt $bmp.Height; $y += $Stride) {
    $row = $y * $data.Stride
    for ($x = 0; $x -lt $bmp.Width; $x += $Stride) {
      $i = $row + ($x * 4)
      $sum += (0.299 * $bytes[$i+2] + 0.587 * $bytes[$i+1] + 0.114 * $bytes[$i]); $n++
    }
  }
  $bmp.Dispose()
  return [math]::Round($sum / $n, 1)
}

# Shortcut warna aplikasi.
function Find-Orange    { param($Path, $XMin=0, $XMax=1080, $YMin=0, $YMax=2400, $Stride=4) Find-ColorBounds -Path $Path -R 255 -G 90 -B 31 -Tol 30 -XMin $XMin -XMax $XMax -YMin $YMin -YMax $YMax -Stride $Stride }
function Find-Teal      { param($Path, $XMin=0, $XMax=1080, $YMin=0, $YMax=2400, $Stride=4) Find-ColorBounds -Path $Path -R 14 -G 124 -B 123 -Tol 28 -XMin $XMin -XMax $XMax -YMin $YMin -YMax $YMax -Stride $Stride }
function Find-DangerRed { param($Path, $XMin=0, $XMax=1080, $YMin=0, $YMax=2400, $Stride=4) Find-ColorBounds -Path $Path -R 196 -G 64 -B 47 -Tol 30 -XMin $XMin -XMax $XMax -YMin $YMin -YMax $YMax -Stride $Stride }
