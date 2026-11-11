# Otomasi alur screenshot: dump semantics Flutter -> tap presisi per teks.
$script:adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"

function Dump-UI {
  & $script:adb shell uiautomator dump /sdcard/ui.xml 2>$null | Out-Null
  & $script:adb pull /sdcard/ui.xml "$PSScriptRoot\ui_cur.xml" 2>$null | Out-Null
  [xml]$x = Get-Content "$PSScriptRoot\ui_cur.xml" -Raw
  $out = @()
  foreach ($n in $x.SelectNodes('//node')) {
    $t = $n.text
    if (-not $t) { $t = $n.'content-desc' }
    if (-not $t) { continue }
    $b = [regex]::Match($n.bounds, '\[(\d+),(\d+)\]\[(\d+),(\d+)\]')
    if (-not $b.Success) { continue }
    $out += [pscustomobject]@{
      Text = $t.Trim()
      X = [int](([double]$b.Groups[1].Value + [double]$b.Groups[3].Value) / 2)
      Y = [int](([double]$b.Groups[2].Value + [double]$b.Groups[4].Value) / 2)
      W = [double]$b.Groups[3].Value - [double]$b.Groups[1].Value
      Checked = $n.checked
      Clazz = $n.class
    }
  }
  return $out
}

function Tap-XY([int]$x, [int]$y) { & $script:adb shell input tap $x $y }

function Find-Node($nodes, [string]$contains) {
  return $nodes | Where-Object { $_.Text -like "*$contains*" } | Select-Object -First 1
}

function Tap-Text($nodes, [string]$contains) {
  $n = Find-Node $nodes $contains
  if ($n) { Tap-XY $n.X $n.Y; return $n } else { return $null }
}

function Shot([string]$name) {
  & $script:adb shell screencap -p "/sdcard/$name"
  & $script:adb pull "/sdcard/$name" "$PSScriptRoot\$name" | Out-Null
  "$name tersimpan ($((Get-Item "$PSScriptRoot\$name").Length) bytes)"
}
