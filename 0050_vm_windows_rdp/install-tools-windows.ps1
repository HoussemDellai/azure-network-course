# The script will be downloaded into the VM: C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.15\Downloads\0

# Install chocolately
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Terminal (already installed in Windows 11)
# choco install microsoft-windows-terminal -y

## Start Terminal

# Install Azure CLI
choco install azure-cli -y
# Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi

# Install Kubernetes CLI
choco install kubernetes-cli -y

# Install kubelogin
choco install azure-kubelogin -y

# Install Helm CLI
choco install kubernetes-helm -y

# Install Terraform
choco install terraform -y

# Install jq
choco install jq -y

# Install yq
choco install yq -y

# Install VS Code
choco install vscode -y

# Install Edge
choco install microsoft-edge -y
# Install Lens
choco install lens -y

# Install Git
choco install git -y

choco install openssl -y

# Install Azure Storage Explorer
choco install microsoftazurestorageexplorer -y

# Install Azure Data Studio
choco install azure-data-studio -y

# Install curl
choco install curl -y

# Install python
choco install python -y

# Install ffmpeg
choco install ffmpeg -y

# install auto-editor
py -m pip install auto-editor

# install VLC
choco install vlc -y

# install winrar
choco install winrar -y

# install openssl
choco install openssl -y

# install sqlcmd
choco install sqlcmd -y

choco install lens -y

Set-Alias -Name k -Value kubectl

# # (Optional) Install Docker for Desktop
# choco install docker-desktop -y
# choco install docker-cli -y

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

$powershellProfile > $PSHOME\Profile.ps1 # $PROFILE.CurrentUserAllHosts

# # Set up language preference
# $LanguageList = Get-WinUserLanguageList
# $LanguageList.Add("fr-FR")
# Set-WinUserLanguageList $LanguageList

## Restart Terminal

# # Install Terraform extension in VS Code
code --install-extension hashicorp.terraform
code --install-extension ms-azuretools.vscode-azureterraform

code --install-extension Postman.postman-for-vscode

code --install-extension github.copilot

code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension ms-kubernetes-tools.vscode-aks-tools
code --install-extension ms-azuretools.vscode-azurecontainerapps
code --install-extension ms-azuretools.vscode-docker

code --install-extension ms-vscode.vscode-node-azure-pack
code --install-extension ms-azuretools.vscode-azureresourcegroups
code --install-extension ms-azuretools.vscode-azurevirtualmachines
code --install-extension ms-vscode.azurecli
code --install-extension ms-azure-devops.azure-pipelines

# cd .\Desktop\
# git clone https://github.com/HoussemDellai/aks-enterprise
# cd aks-enterprise
# code .

# az login --identity
# az account set --subscription "Microsoft-Azure-NonProd"
# az aks list -o table
# az aks get-credentials -g rg-lzaks-spoke-weu-aks-cluster -n aks-cluster

# kubelogin convert-kubeconfig -l azurecli

# kubectl get nodes
# kubectl get pods -A
# kubectl run nginx --image=nginx
# kubectl exec nginx -it -- ls
# kubectl create deployment nginx --image=nginx --replicas=3


# $ACR_NAME=$(az acr list --query [0].name -o tsv)
# $ACR_TOKEN=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)
# docker login $ACR_NAME.azurecr.io -u $ACR_NAME -p $ACR_TOKEN

# docker pull $ACR_NAME.azurecr.io/hello-world:latest

# # IMDS
# Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -NoProxy -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | ConvertTo-Json -Depth 64

# Install Camtasia

Invoke-WebRequest -Uri https://download.techsmith.com/camtasiastudio/releases/2254/camtasia.msi -OutFile .\camtasia.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I camtasia.msi /quiet';
# Invoke-WebRequest -Uri https://netcologne.dl.sourceforge.net/project/shotcut/v24.04.28/shotcut-win64-240428.exe -OutFile .\shotcut-win64-240428.exe; Start-Process msiexec.exe -Wait -ArgumentList '/I camtasia.msi /quiet';

# install Powershell Core
choco install powershell-core -y
# winget install --id Microsoft.Powershell --source winget

# # install Postman CLI
# powershell.exe -NoProfile -InputFormat None -ExecutionPolicy AllSigned -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://dl-cli.pstmn.io/install/win64.ps1'))"

winget settings --enable InstallerHashOverride
winget install --id Microsoft.PowerBI --source winget --ignore-security-hash --accept-source-agreements
winget install Microsoft.DevProxy --silent
