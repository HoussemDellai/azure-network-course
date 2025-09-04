# install Visual Studio Code
winget install -e --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements

# install git
winget install -e --id Git.Git --accept-package-agreements --accept-source-agreements

# install browser
winget install -e --id Brave.Brave --accept-package-agreements --accept-source-agreements

# install python
winget install -e --id Python.Python.3.13

# install mitmproxy using winget
winget install -e --id mitmproxy.mitmproxy

# install mitm using pip
# pip install mitmproxy

# start mitmproxy and wireguard
# mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false --mode wireguard -s ./python/io-write-flow-file.py
# mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false --mode wireguard -w +flows.mitm

# to connect to wireguard you need:
# 1. download wireguard client
# 2. add profile
# 3. install MITMProxy certificate


# # Connect to proxy using command line: https://learn.microsoft.com/en-us/windows/win32/winhttp/netsh-exe-commands#set-advproxy
# netsh winhttp set advproxy setting-scope=machine settings-file=proxy-on.json

# # view configured proxy
# netsh winhttp show advproxy

# # to disable proxy
# netsh winhttp set advproxy setting-scope=machine settings-file=proxy-off.json

# # Connect to VPN
# rasdial "vnet-hub-swc-vpngw2-fw-std"

# # Disconnect from VPN
# rasdial "vnet-hub-swc-vpngw2-fw-std" /disconnect


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