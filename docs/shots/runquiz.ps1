# Loop kuis: jawab 12 soal dengan benar, dump semantics per soal.
. "$PSScriptRoot\flow.ps1"

$answers = @(
  'Aceh',
  '17 Agustus 1945',
  'Newton',
  'HyperText Markup Language',
  'Kalimantan',
  'Jawa Barat',
  'Jupiter',
  'Google',
  'Trowulan',
  'Puncak Jaya',
  'Air',
  '8 bit'
)

$ok = $true
for ($i = 0; $i -lt $answers.Count; $i++) {
  $expected = $i + 1
  $nodes = Dump-UI
  $soalNode = $nodes | Where-Object { $_.Text -match "SOAL \d+ DARI" } | Select-Object -First 1
  if (-not $soalNode) { "GAGAL: dump stale di iterasi $expected"; $ok = $false; break }
  if ($soalNode.Text -notmatch "SOAL $expected DARI") {
    "RETRY: dump menunjukkan '$($soalNode.Text)', harapannya SOAL $expected"
    Start-Sleep 2
    $nodes = Dump-UI
    $soalNode = $nodes | Where-Object { $_.Text -match "SOAL \d+ DARI" } | Select-Object -First 1
    if ($soalNode.Text -notmatch "SOAL $expected DARI") { "GAGAL: masih $($soalNode.Text)"; $ok = $false; break }
  }

  $opt = $nodes | Where-Object { $_.Text -like "*$($answers[$i])*" } | Select-Object -First 1
  if (-not $opt) { "GAGAL: opsi '$($answers[$i])' tidak ketemu"; $ok = $false; break }
  Tap-XY $opt.X $opt.Y
  "Q$expected OK -> '$($answers[$i])' @ ($($opt.X),$($opt.Y))"

  if ($expected -eq 1) { Start-Sleep 2.5; Shot '04_answered.png' | Out-Null }
  Start-Sleep 1.6

  $nodes2 = Dump-UI
  $btn = $nodes2 | Where-Object { $_.Text -match "SOAL BERIKUTNYA|LIHAT HASIL" } | Select-Object -First 1
  if (-not $btn) { "GAGAL: tombol lanjut tidak ketemu di Q$expected"; $ok = $false; break }
  Tap-XY $btn.X $btn.Y
  "   lanjut: $($btn.Text)"
  Start-Sleep 2.2
}
"LOOP SELESAI: $ok"
