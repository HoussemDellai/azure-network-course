# The script will be downloaded into the VM: C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.15\Downloads\0

# Install chocolately
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Azure Data Studio
choco install azure-data-studio -y

# Install curl
choco install curl -y

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

Import-Module Terminal-Icons

Clear

pwd

"@

$powershellProfile > $PSHOME\Profile.ps1