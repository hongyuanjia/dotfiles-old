<#
@author         :  Hongyuan Jia
@email          :  hongyuanjia@outlook.com
@repo           :  https://github.com/hongyuanjia/dotfiles
@createdOn      :  2021-02-23 14:59:36

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
# 
<#
.SYNOPSIS
    Rename file if exists
.DESCRIPTION
    Rename existing file with timestamp in format 'yyyyMMddThhmmss' and an
    extra '.bak' suffix
.PARAMETER Path
    A path of file or directory
#>
function Backup-Exists {
    param (
        [Parameter(Mandatory=$true)]$Path
    )

    if (!(Test-Path $Path)) { Return }

    # Get file name
    $File = [System.IO.Path]::GetFileName($Path)
    # Use timestamp as file suffix
    $Suffix = Get-Date -Format s | ForEach-Object {$_-replace "[:\-]", ""}
    $File_Bak = $File + "." + $Suffix + ".bak"

    Write-Host "'$File' already exists. Renaming it to '$File_Bak'..."
    Rename-Item -Path $Path -NewName $File_Bak -Force | Out-Null
}

# Resolve symbolic link and test if input path is the same as target
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
        [Parameter(Mandatory=$true)]$Path,
        [Parameter(Mandatory=$true)]$Target
    )
    
    # Resolve symbolic link or junction
    $RealPath = Get-Item $Path | Select-Object -ExpandProperty Target

    $RealPath -eq $Target
}

<#
.SYNOPSIS
    Create a symbolic link for input file or a junction for input directory

.DESCRIPTION
    Create a symbolic link for input file or a junction for input directory.

    If there is already a symbolic link or a junction to the input target,
    nothing will be done.

    Otherwise, by default, existing file/directory with the same name as
    input target will be renamed with pattern DateTime + '.bak'.

    If '-NoBackup', existing file/directory will be deleted.
.PARAMETER Directory
    A directory where you want to create a symbolic link or a junction

.PARAMETER Target
    A path of file or directory that you want to create a symbolic link or a
    junction

.PARAMETER NewName
    Optional. New name of the symbolic link or the junction to create. If not
    specified, the original file/directory name is used.

.PARAMETER NoBackup
    If set, existing file/directory in '-Directory' with the same name will
    be deleted.
#># 
function New-Link {
    param ($Directory, $Target, [String]$NewName, [Switch]$NoBackup)

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

    if ($IsFile) {
        # Test if symbolic link already exists
        if (Test-SameRealPath -Path $Path -Target $Target) {
            Write-Host "A symbolic link for '$BaseName' already exists in '$Directory'. Skip..."
            Return
        }
        
        # Backup file if required
        if (!$NoBackup) {
            Backup-Exists $Path
        # Delete file if exists
        } elseif (Test-Path $Path -PathType Leaf) {
            Remove-Item $Path -Force
        }

        # Create symbolic link
        Write-Host "Create a symbolic link for '$BaseName' in '$Directory'..."
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
    } elseif ($IsDir) {
        # Test if symbolic link already exists
        if (Test-SameRealPath -Path $Path -Target $Target) {
            Write-Host "A junction for '$BaseName' already exists in '$Directory'. Skip..."
            Return
        }
        
        # Backup file if required
        if (!$NoBackup) {
            Backup-Exists -Path $Path
        } else {
            # Delete file if exists
            if (Test-Path $Path -PathType Container) {
                Remove-Item $Path -Force -Recurse
            }
        }

        # Create junction
        Write-Host "Create a junction for '$BaseName' in '$Directory'..."
        New-Item -ItemType Junction -Path $Path -Target $Target -Force | Out-Null
    } else {
        Write-Error "Input '$Target' does not exist."
    }
}

# Path of 'Documents' folder for current user
$Documents = [IO.Path]::Combine($Env:USERPROFILE, "Documents")

Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                  Preprocess                                  #"
Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "Set the 'HOME' environment variable to $Env:USERPROFILE for current user "
[System.Environment]::SetEnvironmentVariable('HOME', $Env:USERPROFILE, [System.EnvironmentVariableTarget]::User)

Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                   Setup Git                                  #"
Write-Host "# ---------------------------------------------------------------------------- #"
$gitconfig = [System.IO.Path]::Combine($PSScriptRoot, '.gitconfig')
New-Link -Directory $Env:USERPROFILE -Target $gitconfig

Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                    Setup R                                   #"
Write-Host "# ---------------------------------------------------------------------------- #"
# Use environment variable instead of symbolic links
$Rprofile = [System.IO.Path]::Combine($PSScriptRoot, '.Rprofile')
$Renviron = [System.IO.Path]::Combine($PSScriptRoot, '.Renviron')
Write-Host "Set environment variable 'R_PROFILE_USER' to '$Rprofile' for current user..."
[System.Environment]::SetEnvironmentVariable('R_PROFILE_USER', $Rprofile, [System.EnvironmentVariableTarget]::User)
Write-Host "Set environment variable 'R_ENVIRON_USER' to '$Renviron' for current user..."
[System.Environment]::SetEnvironmentVariable('R_ENVIRON_USER', $Renviron, [System.EnvironmentVariableTarget]::User)
# Rconsole preferences for RGui
$Rconsole = [System.IO.Path]::Combine($PSScriptRoot, 'Rconsole')
New-Link -Directory $Documents -Target $Rconsole
# RStudio preferences
$RStudio = [System.IO.Path]::Combine($PSScriptRoot, 'rstudio-prefs.json')
$RStudio_Dir = [System.IO.Path]::Combine($Env:APPDATA, 'Rstudio')
New-Link -Directory $RStudio_Dir -Target $RStudio
# Makevars
$RMake = [System.IO.Path]::Combine($PSScriptRoot, '.R')
New-Link -Directory $Documents -Target $RMake


Write-Host "# ---------------------------------------------------------------------------- #"
Write-Host "#                                   Setup Vim                                  #"
Write-Host "# ---------------------------------------------------------------------------- #"
$VimDir = [System.IO.Path]::Combine($PSScriptRoot, ".vim")
$VimDir_Autoload = [System.IO.Path]::Combine($Env:USERPROFILE, ".vim", "autoload")
$VimPlug = [System.IO.Path]::Combine($VimDir_Autoload, "plug.vim")
$Vimrc = [System.IO.Path]::Combine($PSScriptRoot, ".config", "nvim", "init.vim")
New-Link -Directory $Env:USERPROFILE -Target $VimDir
# Download vim-plug
if (!(Test-Path $VimDir_Autoload)) {
    if (!(Test-Path $VimDir_Autoload -PathType Container)) {
        Write-Output "Create 'autoload' folder under '.vim'..."
        New-Item -Path $VimDir_Autoload -ItemType Directory
    }
    if (!(Test-Path $VimPlug -PathType Leaf)) {
        Write-Output "Download vim-plug under '.vim\autoload'..."
        $VimPlug_URI='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        Invoke-WebRequest -Uri $VimPlug_URI -Outfile $VimPlug
    }
}
# Create a symbolic link of vimrc
New-Link -Directory $Env:USERPROFILE -Target $Vimrc -NewName ".vimrc"

Write-Host "Completed!"
Read-Host -Prompt "Press Enter to exit"