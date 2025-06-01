# The script will be downloaded into the VM: C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.20\Downloads\0

winget install -e --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements

winget install -e --id Git.Git --accept-package-agreements --accept-source-agreements

winget install -e --id cURL.cURL --accept-package-agreements --accept-source-agreements

winget install -e --id Python.Python.3.13 --accept-package-agreements --accept-source-agreements

winget install -e --id Brave.Brave --accept-package-agreements --accept-source-agreements

winget install -e --id Brave.Brave.Dev --accept-package-agreements --accept-source-agreements

winget install -e --id WireGuard.WireGuard --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.AzureCLI --accept-package-agreements --accept-source-agreements

# Configure Auto-Complete
Set-ExecutionPolicy RemoteSigned
# Create profile when not exist
if (!(Test-Path -Path $PROFILE.CurrentUserAllHosts)) {
  New-Item -ItemType File -Path $PROFILE.CurrentUserAllHosts -Force
}
# Open the profile with an editor (e.g. good old Notepad)
# ii $PROFILE.CurrentUserAllHosts
# In the editor add the following lines to the profile:
$powershellProfile=@"
# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Import-Module posh-git

Import-Module PSReadLine
Set-PSReadLineOption -colors @{ Default = "Green"}
Set-PSReadLineOption -colors @{ Parameter = "Blue"}
Set-PSReadLineOption -colors @{ Command = "Magenta"}

function prompt {
" $ "
}

Clear

pwd

"@

$powershellProfile > $PSHOME\Profile.ps1 # $PROFILE.CurrentUserAllHosts

# save commands history
# Copy-Item -Path .\ConsoleHost_history.txt -Destination (Get-PSReadlineOption).HistorySavePath -Force