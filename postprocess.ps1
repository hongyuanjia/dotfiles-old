<#
@author         :  Hongyuan Jia
@email          :  hongyuanjia@outlook.com
@repo           :  https://github.com/hongyuanjia/dotfiles
@createdOn      :  2021-02-23
@modifiedOn     :  2021-06-02 17:01

Copyright (c) 2021 Hongyuan Jia

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

# --------------------------------- Utilities -------------------------------- #
<#
.SYNOPSIS
    Rename file if exists

.DESCRIPTION
    Rename existing file with timestamp in format 'yyyyMMddThhmmss' and an
    extra '.bak' suffix

.PARAMETER Path
    A path of file or directory

.OUTPUTS
    The path of the renamed file
#>
function Backup-Exists {
    param (
        [Parameter(Mandatory=$True)]$Path
    )

    if (!(Test-Path $Path)) { Return $Path }

    # Get file name
    $File = [System.IO.Path]::GetFileName($Path)
    # Use timestamp as file suffix
    $Suffix = Get-Date -Format s | ForEach-Object {$_-replace "[:\-]", ""}
    $File_Bak = $File + "." + $Suffix + ".bak"

    Write-Host "'$File' already exists. Renaming it to '$File_Bak'..."
    Rename-Item -Path $Path -NewName $File_Bak -Force | Out-Null

    Return [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($Path), $File_Bak)
}

<#
.SYNOPSIS
    Test the real path with target with symbolic link resolved
.DESCRIPTION
    Resolve the real path of input and compare it with target.
    Test input path with target with symbolic link resolved
.OUTPUTS
    True or False
.NOTES
    '-Target' path is not resolved.
#>
function Test-SameRealPath {
    param (
        [Parameter(Mandatory=$True)]$Path,
        [Parameter(Mandatory=$true)]$Target
    )

    if (!(Test-Path $Path)) { Return $False }

    # Resolve symbolic link or junction
    $RealPath = Get-Item $Path | Select-Object -ExpandProperty Target

    $RealPath -eq $Target
}

<#
.SYNOPSIS
    Create a symbolic link for input file or directory

.DESCRIPTION
    Create a symbolic link for input file or directory.

    If there is already a symbolic link to the input target, nothing will be
    done.

    Otherwise, by default, existing file/directory with the same name as
    input target will be renamed with pattern DateTime + '.bak'.

    If '-NoBackup', existing file/directory will be deleted.

.PARAMETER Directory
    A directory where you want to create a symbolic link

.PARAMETER Target
    A path of file or directory that you want to create a symbolic link

.PARAMETER NewName
    Optional. New name of the symbolic link to create. If not specified, the
    original file/directory name is used.

.PARAMETER NoBackup
    If set, existing file/directory in '-Directory' with the same name will
    be deleted.

.OUTPUTS
    The path of symbolic link
#>
function New-Link {
    param (
        [Parameter(Mandatory=$True)]$Directory,
        [Parameter(Mandatory=$True)]$Target,
        [String]$NewName,
        [Switch]$NoBackup
    )

    # Check input target is a file or a directory
    $IsFile = Test-Path -Path $Target -PathType Leaf
    $IsDir = Test-Path -Path $Target -PathType Container

    # Get full path of the link to create
    if ($PSBoundParameters.ContainsKey("NewName")) {
        $BaseName = $NewName
        $Path = [System.IO.Path]::Combine($Directory, $NewName)
    } else {
        $BaseName = [System.IO.Path]::GetFileName($Target)
        $Path = [System.IO.Path]::Combine($Directory, $BaseName)
    }

    # Test if symbolic link already exists
    if (Test-SameRealPath -Path $Path -Target $Target) {
        Write-Host "A symbolic link for '$BaseName' already exists in '$Directory'. Skip..."
        Return $Path
    }

    # Backup file if required
    if (!$NoBackup) {
        Backup-Exists $Path
    } elseif ((!$isFile) -and (!$isDir)) {
        Write-Error "Input '$Target' does not exist."
    # Delete file/directory if exists
    } elseif ($IsFile -and (Test-Path $Path -PathType Leaf)) {
        Remove-Item $Path -Force
    } elseif ($IsDir -and (Test-Path $Path -PathType Container)) {
        Remove-Item $Path -Force -Recurse
    }

    # Create symbolic link
    Write-Host "Create a symbolic link for '$BaseName' in '$Directory'..."
    New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
    Return $Path
}

<#
.SYNOPSIS
    Get all installed programs

.DESCRIPTION
    Get all installed programs by querying the Registry and return:
    - DisplayName
    - Publisher
    - InstallDate
    - DisplayVersion
    - UninstallString
#>
function Get-AllInstalledApps {
    $LMReg32 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $CUReg32 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $LMReg64 = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $CUReg64 = "HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $Reg = @($LMReg32, $LMReg64, $CUReg32, $CUReg64) | Where-Object { Test-Path $_ }

    Get-ItemProperty $Reg |
        Where-Object { $_.DisplayName -and $_.UninstallString } |
        Select-Object DisplayName, Publisher, InstallLocation, InstallDate, DisplayVersion, UninstallString |
        Sort-Object DisplayName
}

<#
.SYNOPSIS
    Extract information of installed programs using regular expression

.DESCRIPTION
    Extract information of installed programs using regular expression
#>
function Get-InstalledApp {
    param (
        [Parameter(Mandatory=$True)]$Program
    )

    # Get all installed programs
    Get-AllInstalledApps | Where-Object { $_.DisplayName -Match $Program }
}

<#
.SYNOPSIS
    Download latest release files of a GitHub Repository

.DESCRIPTION
    Download latest release files of a GitHub Repository

.PARAMETER Repo
    A name of GitHub Repository. For example, "NREL/EnergyPlus"

.PARAMETER FilePattern
    A regular expression used to extract latest release files

.PARAMETER Directory
    A path of directory to save the downloaded files. Default is $TEMP

.OUTPUTS
    The path of downloaded file
#>
function Get-GitHubRelease {
    param (
        [Parameter(Mandatory=$True)]$Repo,
        [Parameter(Mandatory=$True)]$FilePattern,
        [Parameter(Mandatory=$False)]$Directory = [System.IO.Path]::GetTempPath()
    )

    $ReleaseUri = "https://api.github.com/repos/$Repo/releases/latest"
    $DownloadUri = ((Invoke-RestMethod -Method GET -Uri $ReleaseUri).assets |
        Where-Object name -Match $FilePattern ).browser_download_url

    if ($DownloadUri.length -eq 0) {
        Write-Error "No matched release file has been found"
    }

    $Output = [System.IO.Path]::Combine($Directory, [System.IO.Path]::GetFileName($DownloadUri))

    Invoke-WebRequest -Uri $DownloadUri -Outfile $Output

    Return $Output
}

# Path of 'Documents' folder for current user
$Documents = [IO.Path]::Combine($Env:USERPROFILE, "Documents")

Write-Host ""
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                  Preprocess                                  #"
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "Set the 'HOME' environment variable to $Env:USERPROFILE for current user "
[System.Environment]::SetEnvironmentVariable('HOME', $Env:USERPROFILE, [System.EnvironmentVariableTarget]::User)

Write-Host ""
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                      Git                                     #"
Write-Host "# ---------------------------------------------------------------------------- #"
$gitconfig = [System.IO.Path]::Combine($PSScriptRoot, '.gitconfig')
New-Link -Directory $Env:USERPROFILE -Target $gitconfig | Out-NULL

Write-Host ""
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                      Vim                                     #"
Write-Host "# ---------------------------------------------------------------------------- #"
# Create a symbolic link of vimrc
$Vimrc = [System.IO.Path]::Combine($PSScriptRoot, ".vim", "init.vim")
New-Link -Directory $Env:USERPROFILE -Target $Vimrc -NewName ".vimrc" | Out-NULL
# NOTE: On Windows, 'runtimepath' will resolve the symbolic link and use both
# the symbolic link and original folder. This causes problem for Nvim-R.
# See: https://github.com/jalvesaq/Nvim-R/issues/576
# To solve this, instead of symbolic linking '.vim' directory, make links for
# every file and folder inside '.vim'.
$VimDir = [System.IO.Path]::Combine($PSScriptRoot, ".vim")
$VimDirHome = [System.IO.Path]::Combine($Env:USERPROFILE, ".vim")
# Create '.vim' folder if necessary
if (!(Test-Path -Path $VimDirHome -PathType Container)) {
    Write-Host "Create '.vim' folder in '$Env:USERPROFILE'..."
    New-Item -Path $VimDirHome -ItemType Directory | Out-Null
}
Get-ChildItem $VimDir | ForEach-Object {
    if (($_.Name -ne ".gitignore") -and ($_.Name -ne "plugged") ) {
        New-Link -Directory $VimDirHome -Target $_.FullName -NoBackup
    } elseif ($_.Name -ne "plugged") {
        Backup-Exists "$VimDirHome\plugged"
        Copy-Item -Path "$VimDir\plugged" -Destination "$VimDirHome\plugged" -Recurse
    }
} | Out-Null
$VimDirAutoload = [System.IO.Path]::Combine($VimDirHome, "autoload")
$VimPlug = [System.IO.Path]::Combine($VimDirAutoload, "plug.vim")
# Download vim-plug
if (!(Test-Path $VimDirAutoload)) {
    if (!(Test-Path $VimDirAutoload -PathType Container)) {
        Write-Output "Create 'autoload' folder under '.vim'..."
        New-Item -Path $VimDirAutoload -ItemType Directory
    }
    if (!(Test-Path $VimPlug -PathType Leaf)) {
        Write-Output "Download vim-plug under '.vim\autoload'..."
        $VimPlug_URI='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        Invoke-WebRequest -Uri $VimPlug_URI -Outfile $VimPlug
    }
}
# Install all plugins
& vim +PlugInstall +qall

Write-Host ""
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                       R                                      #"
Write-Host "# ---------------------------------------------------------------------------- #"
# Use environment variable instead of symbolic links
$Renviron = [System.IO.Path]::Combine($PSScriptRoot, '.Renviron')
Write-Host "Set environment variable 'R_ENVIRON_USER' to '$Renviron' for current user..."
[System.Environment]::SetEnvironmentVariable('R_ENVIRON_USER', $Renviron, [System.EnvironmentVariableTarget]::User)
# Rprofile
$Rprofile = [System.IO.Path]::Combine($PSScriptRoot, '.Rprofile')
New-Link -Directory $Env:USERPROFILE -Target $Rprofile | Out-NULL
# Rconsole preferences for RGui
$Rconsole = [System.IO.Path]::Combine($PSScriptRoot, 'Rconsole')
New-Link -Directory $Env:USERPROFILE -Target $Rconsole | Out-NULL
# RStudio preferences
$RStudio = [System.IO.Path]::Combine($PSScriptRoot, 'rstudio-prefs.json')
$RStudio_Dir = [System.IO.Path]::Combine($Env:APPDATA, 'Rstudio')
New-Link -Directory $RStudio_Dir -Target $RStudio | Out-NULL
# Makevars
$RMake = [System.IO.Path]::Combine($PSScriptRoot, '.R')
New-Link -Directory $Documents -Target $RMake | Out-NULL
# Install {languageserver} and {nvimcom} packages
# Create 'R_LIBS_USER' if not exists
$RParams = @("-e", "cat(normalizePath(Sys.getenv('R_LIBS_USER'), mustWork = FALSE))")
$R_LIBS_USER = & Rscript.exe @RParams
# Escape backslash
$R_LIBS_USER_ESC = $R_LIBS_USER.Replace("\", "\\")
if (!(Test-Path -Path $R_LIBS_USER -PathType Container)) {
    New-Item -ItemType Directory -Path $R_LIBS_USER
}

# Install {languageserver} package and return the install location
Write-Host "Install {languageserver} R package if necessary..."
$RParams =
"if (!suppressWarnings(require(`"languageserver`", character.only = TRUE, quietly = TRUE))) {
    install.packages(`"languageserver`", `"$R_LIBS_USER_ESC`")
}
cat(find.package(`"languageserver`"), sep = `"\n`")
"
$TMP = New-TemporaryFile
[System.IO.File]::WriteAllLines($TMP.FullName, $RParams)
$LanguageServer = [System.IO.Path]::GetFullPath((& Rscript.exe $TMP.FullName | Select-Object -Last 1))

# Install {nvimcom} package that is distributed with 'Nvim-R' plugin
Write-Host "Install {nvimcom} R package if necessary..."
$NvimCom = [System.IO.Path]::Combine($R_LIBS_USER, "nvimcom")
if (!(Test-Path -Path $NvimCom -PathType Container)) {
    $NvimComSrc = [System.IO.Path]::Combine($VimDirHome, "plugged", "Nvim-R", "R", "nvimcom")
    $NvimComBuild = & R.exe CMD build $NvimcomSrc | Select-Object -Last 1
    if (!($NvimComBuild -match "nvimcom_[0-9\.\-]+.tar.gz")) {
        Write-Error "Failed to build 'nvimcom' package for 'Nvim-R' Vim plugin"
    }
    & R.exe CMD INSTALL --no-multiarch $($Matches.Values) -l=$($R_LIBS_USER)
}

# Install {startup} package to enable system-specific Rprofile and Renviron
Write-Host "Install {startup} R package if necessary..."
$RParams =
"if (!suppressWarnings(require(`"startup`", character.only = TRUE, quietly = TRUE))) {
    install.packages(`"startup`", `"$R_LIBS_USER_ESC`")
}
"
$TMP = New-TemporaryFile
[System.IO.File]::WriteAllLines($TMP.FullName, $RParams)
& Rscript.exe $TMP.FullName | Out-Null

# Create a folder that contains the path of those 2 packages to work better
# with {renv}. Otherwise, {nvimcom} and {languageserver} will have to be
# added in every {renv} project
# See: https://github.com/jalvesaq/Nvim-R/issues/445#issuecomment-635419033
$R_LIBS_EXT = [System.IO.Path]::Combine($Env:USERPROFILE, "R", "External")
if (!(Test-Path -Path $R_LIBS_EXT -PathType Container)) {
    New-Item -Path $R_LIBS_EXT -ItemType Directory | Out-Null
}
# Create symbolic links to {nvimcom} and {languageserver} package folder
New-Link $R_LIBS_EXT -Target $LanguageServer -NoBackup | Out-Null
New-Link $R_LIBS_EXT -Target $NvimCom -NoBackup | Out-Null

# ------------- NOTE: Steps below depends on files on my Dropbox ------------- #
# Path of Dropbox folder
$Dropbox = [System.IO.Path]::Combine($Env:USERPROFILE, "Dropbox")
$Backup = [System.IO.Path]::Combine($Dropbox, "software", "backup")
$AppData = [System.IO.Path]::Combine($Backup, "Roaming")
$LocalAppData = [System.IO.Path]::Combine($Backup, "Local")

Write-Host ""
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                    Zotero                                    #"
Write-Host "# ---------------------------------------------------------------------------- #"
<#
Zotero Data: ~/Dropbox/literatures/Zetero
Attachments: ~/Dropbox/literatures/Attachments
#>
Write-Host "Recover Zetero data..."
# Create a symbolic link for Zotero Data folder
$ZoteroData = [System.IO.Path]::Combine($Dropbox, "literatures", "Zotero")
New-Link -Directory $Env:USERPROFILE -Target $ZoteroData | Out-NULL

Write-Host ""
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                Total Commander                               #"
Write-Host "# ---------------------------------------------------------------------------- #"
<#
Total Commander portable: ~/Dropbox/software/backup/TotalCMD64
Total Commander System Variable: COMMANDER_PATH
#>
Write-Host "Install Total Commander (portable)..."
$TotalCMD = [System.IO.Path]::Combine($LocalAppData, "TotalCMD64")
New-Link -Directory $Env:LOCALAPPDATA -Target $TotalCMD -NoBackup | Out-NULL
Write-Host "Set environment variable 'COMMANDER_PATH' to '$Env:LOCALAPPDATA\TotalCMD64' for current user..."
[System.Environment]::SetEnvironmentVariable('COMMANDER_PATH', $Env:LOCALAPPDATA + "\TotalCMD64", [System.EnvironmentVariableTarget]::User)

Write-Host ""
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                 Flow Launcher                                #"
Write-Host "# ---------------------------------------------------------------------------- #"
<#
Currently, Flow Launcher did not provide a way to recover settings.
See: https://github.com/Flow-Launcher/Flow.Launcher/issues/365
Flow Launcher: ~/Dropbox/software/backup/Roaming/FlowLauncher
#>
# Check if Flow Launcher has been installed and install it if not
Write-Host "Install Flow Launcher if necessary..."
if ((Get-InstalledApp "Flow Launcher").length -eq 0) {
    Write-Host "Download Flow Launcher from GitHub..."

    $FLInstaller = Get-GitHubRelease "Flow-Launcher/Flow.Launcher" "Flow-Launcher-v\d+\.\d+\.\d+\.exe"

    Write-Host "Install Flow Launcher..."
    Start-Process -Wait -FilePath $FLInstaller -ArgumentList "/S" -PassThru | Out-Null
}

Write-Host ""
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                 Input Method                                 #"
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "Install im-select and wubiLex..."
<#
im-select
Needed for switching input methods between normal mode and input mode in Vim
Repo: https://github.com/daipeihust/im-select
Path: ~/Dropbox/software/backup/im-select

wubiLex
Utilities of Wubi IM on Windows 10
Repo: https://github.com/aardio/wubi-lex
Path: ~/Dropbox/software/backup/wubiLex
#>
$wubiLex = [System.IO.Path]::Combine($LocalAppData, "wubiLex")
$imselect = [System.IO.Path]::Combine($LocalAppData, "im-select")
New-Link -Directory $Env:LOCALAPPDATA -Target $wubiLex -NoBackup | Out-NULL
New-Link -Directory $Env:LOCALAPPDATA -Target $imselect -NoBackup | Out-NULL

Write-Host "Install im-select and wubiLex..."
Write-Host ""
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                  Misc Tools                                  #"
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "Recover SSH data..."
$ssh = [System.IO.Path]::Combine($Backup, ".ssh")
New-Link -Directory $Env:USERPROFILE -Target $ssh -NoBackup | Out-NULL

Write-Host ""
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                               Application Data                               #"
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "Recover application data..."
Get-ChildItem $AppData | ForEach-Object {
    if ($_.Name -ne "Microsoft") {
        New-Link -Directory $Env:APPDATA -Target $_.FullName
    } else {
        # For Microsoft applications
        $Microsoft = [System.IO.Path]::Combine($Env:LOCALAPPDATA, "Microsoft")
        Get-ChildItem $_ | ForEach-Object {
            New-Link -Directory $Microsoft -Target $_.FullName
        }
    }
} | Out-Null

Write-Host ""
Write-Host "Completed!"

Read-Host -Prompt "Press Enter to exit"
