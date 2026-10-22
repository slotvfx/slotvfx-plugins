# Prints the folder that holds SlotVFX.exe, for SlotVFX installed anywhere:
# the SLOTVFX_APP override, the running app, then the installer's registry entry.
$candidates = @()
if ($env:SLOTVFX_APP) { $candidates += $env:SLOTVFX_APP }
$running = Get-Process -Name SlotVFX -ErrorAction SilentlyContinue | Where-Object { $_.Path } | Select-Object -First 1
if ($running) { $candidates += (Split-Path -Parent $running.Path) }
$uninstallKeys = @(
  'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
  'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
  'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
)
$candidates += Get-ItemProperty -Path $uninstallKeys -ErrorAction SilentlyContinue |
  Where-Object { $_.DisplayName -like 'SlotVFX*' -and $_.DisplayName -notlike '*Staging*' -and $_.InstallLocation } |
  ForEach-Object { $_.InstallLocation }
foreach ($folder in $candidates) {
  $folder = $folder.Trim('"').TrimEnd('\')
  if (Test-Path -LiteralPath (Join-Path $folder 'SlotVFX.exe')) { Write-Output $folder; exit 0 }
}
