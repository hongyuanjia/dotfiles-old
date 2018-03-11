# Change directory to $Home
Push-Location  ~
# By default PowerShell uses TLS 1.0, but GitHub requires TLS 1.2
# https://stackoverflow.com/questions/41618766/powershell-invoke-webrequest-fails-with-ssl-tls-secure-channel
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Install Chocolatey
Write-Output "Install Package Manager 'Chocolatey'..."
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Refresh environment
refreshenv

# Install pacakges
choco install -y`
    7zip.install`
    autohotkey.install`
    conemu`
    dotnet4.5`
    everything`
    git.install`
    googlechrome`
    irfanview`
    irfanviewplugins`
    pandoc`
    pt`
    python3`
    r.project r.studio`
    sumatrapdf.install`
    vcredist-all`
    vim-tux.install`
    visualstudiocode`
    zotero-standalone`
    gitkraken
# For 'LyX' specifically, ignore MikTex
choco install lyx --ignore-dependencies -y

Rscript install.R
