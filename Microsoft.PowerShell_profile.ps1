# Start oh-my-posh with shell for nerd font support
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\aliens.omp.json" | Invoke-Expression

# PowerToys CommandNotFound module
Import-Module "C:\Users\thede\AppData\Local\PowerToys\WinUI3Apps\..\WinGetCommandNotFound.psd1"

# Shortcut directory environment variables
$projects = "E:\Projects"
$notes = "C:\Users\thede\Dropbox\Apps\remotely-save\Notes"
$config = "C:\Users\thede\OneDrive\Documents\Powershell"

## WSL aliases ##
# vim
function vi { wsl NVIM_APPNAME=tdk.nvim nvim } # My nvim config
function vim { wsl nvim } # Default NeoVim
function lazyvim { wsl NVIM_APPNAME=lazyvim nvim } # LazyVim

# git
function git { wsl git }
function lazygit { wsl lazygit }
## End WSL aliases ##

# Termux ssh connection
function termux
{
  Do {
      Write-Host "Which Termux Connection?"
      Write-Host "[1] ADB"
      Write-Host "[2] SSH"
      $Termux = Read-Host
    }
  While ( "1", "2" -notcontains $Termux )
    Switch ( $Termux )
    {
      "1" { adb forward tcp:8022 tcp:8022}
      "2" { ssh u0_a676@localhost -p 8022 }
    }
}

# Useful shortcuts for traversing directories
function cd... { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

# Reboot
function reboot
{
  Do { $InputReboot = Read-Host "Do you wish to reboot now? [y/n]" }
  While ( "y","n" -notcontains $InputReboot )
    Switch ( $InputReboot ) 
    {
      "y" { Restart-Computer }
      "n" { Break }
    }
}

# Load shell profile changes
function reload { & $profile }

# Create file linux-like
function touch($file) { "" | Out-File $file -Encoding ASCII }

# Speed up Invoke-WebRequest
$ProgressPreference = "SilentlyContinue"

# Get system up-time
function tdk_uptime
{
  $bootuptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
  $CurrentDate = Get-Date
  $uptime = $CurrentDate - $bootuptime
  # if uptime > 1 day prompt to reboot
  if ($uptime.days -gt 0)
  {
    Write-Output "Device Uptime --> Days: $($uptime.days), Hours: $($uptime.Hours), Minutes:$($uptime.Minutes)"
    Do
    { $InputReboot = Read-Host "Uptime is greater than 1 day, Reboot now? [y/n]" }
    While ("y","n" -notcontains $InputReboot)
    Switch ($InputReboot)
    {
      "y" { Restart-Computer }
      "n" { Break }
    }
  } else
  { Write-Output "Device Uptime --> Days: $($uptime.days), Hours: $($uptime.Hours), Minutes:$($uptime.Minutes)" }
}

# delete empty directories
function delete-empty-dirs {
    Get-ChildItem -Directory -Recurse | Where { $_.GetFiles().Count -eq 0 -and $_.GetDirectories().Count -eq 0 } | Remove-Item -Force
}

Clear-Host
tdk_uptime # Check uptime on launch/reload
