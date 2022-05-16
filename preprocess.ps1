# Adopted from
# 1. Ultimate Windows Toolbox under MIT License (Copyright (c) 2021-2022 CT Tech Group, LLC)
#    https://github.com/ChrisTitusTech/win10script
# 2. Sophia Script for Windows under MIT License (Copyright (c) 2019 farag2)
#    https://github.com/farag2/Sophia-Script-for-Windows

# Check if there is a restart pending action
$PendingActions = @(
    # CBS pending
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootInProgress",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackagesPending",
    # Windows Update pending
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\PostRebootReporting",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
)
if ($null -ne (Get-Item -Path $PendingActions -Force -ErrorAction Ignore))
{
    Write-Warning -Message "The PC is waiting to be restarted. Please restart the PC and run the script again."
    exit
}

Write-Host "Do not notify UAC..."
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
New-ItemProperty -Path $RegPath -Name ConsentPromptBehaviorAdmin -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling Telemetry..."
Get-Service -Name "DiagTrack" | Stop-Service -Force | Out-Null
Get-Service -Name "DiagTrack" | Set-Service -StartupType Disabled | Out-Null
# Block connection for the Unified Telemetry Client Outbound Traffic
Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled False -Action Block | Out-Null

Write-Host "Minimize diagnostic data collection..."
$RegPathLM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
$RegPathCU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack"
New-ItemProperty -Path $RegPathLM -Name AllowTelemetry -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty -Path $RegPathLM -Name MaxTelemetryAllowed -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty -Path $RegPathCU -Name ShowedToastAtLevel -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling error reporting..."
Get-ScheduledTask -TaskName QueueReporting | Disable-ScheduledTask | Out-Null
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
New-ItemProperty -Path $RegPath -Name Disabled -PropertyType DWord -Value 1 -Force | Out-Null
Get-Service -Name WerSvc | Stop-Service -Force | Out-Null
Get-Service -Name WerSvc | Set-Service -StartupType Disabled | Out-Null

Write-Host "Setting Feedback frequency to Never..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name NumberOfSIUFInPeriod -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling diagnostic tracking schedule tasks..."
[string[]]$ScheduledTasks = @(
    # Collects technical data regarding the usage and performance of computer
    # and Windows 10 software
    "Microsoft Compatibility Appraiser",

    # Collects program telemetry information if opted-in to the Microsoft
    # Customer Experience Improvement Program
    "ProgramDataUpdater",

    # This task collects and uploads autochk SQM data if opted-in to the
    # Microsoft Customer Experience Improvement Program
    "Proxy",

    # If the user has consented to participate in the Windows Customer
    # Experience Improvement Program, this job collects and sends usage data to
    # Microsoft
    "Consolidator",

    # The USB CEIP (Customer Experience Improvement Program) task collects
    # Universal Serial Bus related statistics and information about your
    # machine and sends it to the Windows Device Connectivity engineering group
    # at Microsoft
    "UsbCeip",

    # The Windows Disk Diagnostic reports general disk and system information
    # to Microsoft for users participating in the Customer Experience Program
    "Microsoft-Windows-DiskDiagnosticDataCollector",

    # This task shows various Map related toasts
    "MapsToastTask",

    # This task checks for updates to maps which you have downloaded for
    # offline use
    "MapsUpdateTask",

    # Initializes Family Safety monitoring and enforcement
    "FamilySafetyMonitor",

    # Synchronizes the latest settings with the Microsoft family features
    # service
    "FamilySafetyRefreshTask",

    # XblGameSave Standby Task
    "XblGameSaveTask"
)
# Check if device has a camera
# If no camera, disable Windows Hello related tasks
$DeviceHasCamera = Get-CimInstance -ClassName Win32_PnPEntity | Where-Object -FilterScript {(($_.PNPClass -eq "Camera") -or ($_.PNPClass -eq "Image")) -and ($_.Service -ne "StillCam")}
if (-not $DeviceHasCamera)
{
    # Windows Hello
    $ScheduledTasks += "FODCleanupTask"
}
Foreach ($Task in $ScheduledTasks) {
    Write-Host "    --> Disabling '$Task'..."
    Get-ScheduledTask -TaskName $Task | Disable-ScheduledTask | Out-Null
}

Write-Host "Disabling sign-in info usage after update or restart..."
$SID = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID
$RegDir = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO"
if (-not (Test-Path -Path "$RegDir\$SID"))
{
    New-Item -Path "$RegDir\$SID" -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path "$RegDir\$SID" -Name OptOut -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling websites to access language list..."
$RegPath = "HKCU:\Control Panel\International\User Profile"
New-ItemProperty -Path $RegPath -Name HttpAcceptLanguageOptOut -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling advertising ID..."
$RegPathCU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
$RegPathLM = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
if (-not (Test-Path -Path $RegPathCU))
{
    New-Item -Path $RegPathCU -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPathCU -Name Enabled -PropertyType DWord -Value 0 -Force | Out-Null
If (-not (Test-Path $RegPathLM)) {
    New-Item -Path $RegPathLM -ItemType Directory | Out-Null
}
New-ItemProperty -Path $RegPathLM -Name DisabledByGroupPolicy -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling Windows welcome experience after updates..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
New-ItemProperty -Path $RegPath -Name SubscribedContent-310093Enabled -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "Disabling Windows Tips..."
New-ItemProperty -Path $RegPath -Name SubscribedContent-338389Enabled -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "Disabling suggested contents in Settings..."
New-ItemProperty -Path $RegPath -Name SubscribedContent-338393Enabled -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name SubscribedContent-353694Enabled -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name SubscribedContent-353696Enabled -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "Disabling automatic installing suggested apps..."
New-ItemProperty -Path $RegPath -Name SilentInstalledAppsEnabled -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling suggestions on setting up the device..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name ScoobeSystemSettingEnabled -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling tailored experiences based on the diagnostic data..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy"
New-ItemProperty -Path $RegPath -Name TailoredExperiencesWithDiagnosticDataEnabled -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling Bing Search..."
$RegPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name DisableSearchBoxSuggestions -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Changing default Explorer view..."
$RegPathCU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
$RegPathLM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
Write-Host "    --> Do not show frequent files..."
New-ItemProperty -Path $RegPathCU            -Name ShowFrequent -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "    --> Do not show recent files..."
New-ItemProperty -Path $RegPathCU            -Name ShowRecent -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "    --> Show hidden files..."
New-ItemProperty -Path "$RegPathCU\Advanced" -Name Hidden -PropertyType DWord -Value 2 -Force | Out-Null
Write-Host "    --> Show system files..."
New-ItemProperty -Path "$RegPathCU\Advanced" -Name ShowSuperHidden -PropertyType DWord -Value 1 -Force | Out-Null
Write-Host "    --> Showing file extensions..."
New-ItemProperty -Path "$RegPathCU\Advanced" -Name HideFileExt -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "    --> Open File Explorer to 'This PC'..."
New-ItemProperty -Path "$RegPathCU\Advanced" -Name LaunchTo -PropertyType DWord -Value 1 -Force | Out-Null
Write-Host "    --> Expand navigation panel to current folder..."
New-ItemProperty -Path "$RegPathCU\Advanced" -Name NavPaneExpandToCurrentFolder -Value 1 -Force | Out-Null
Write-Host "    --> Show all folders in navigation panel..."
New-ItemProperty -Path "$RegPathCU\Advanced" -Name NavPaneShowAllFolders -Value 1 -Force | Out-Null
Write-Host "    --> Hide OneDrive ad..."
New-ItemProperty -Path "$RegPathCU\Advanced" -Name ShowSyncProviderNotifications -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "    --> Show full path in title bar..."
if (-not (Test-Path -Path "$RegPathCU\CabinetState"))
{
    New-Item -Path "$RegPathCU\CabinetState" -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path "$RegPathCU\CabinetState" -Name FullPath -Value 1 -Force | Out-Null
Write-Host "    --> Hide Ribbon..."
if (-not (Test-Path -Path "$RegPathCU\Ribbon"))
{
    New-Item -Path "$RegPathCU\Ribbon" -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path "$RegPathCU\Ribbon" -Name MinimizedStateTabletModeOff -Value 1 -Force | Out-Null
Write-Host "    --> Remove '3D Objects' folder..."
if (-not (Test-Path -Path "$RegPathLM\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"))
{
    New-Item -Path "$RegPathLM\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path "$RegPathLM\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name ThisPCPolicy -PropertyType String -Value Hide -Force | Out-Null

Write-Host "Hiding ThisPC and RecycleBin on Desktop..."
Remove-ItemProperty -Path "$RegPathCU\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Force -ErrorAction Ignore
Remove-ItemProperty -Path "$RegPathCU\HideDesktopIcons\NewStartPanel" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Force -ErrorAction Ignore

Write-Host "Changing default Taskbar view..."
$RegDir = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion"
Write-Host "    --> Hide Cortana..."
New-ItemProperty -Path "$RegDir\Explorer\Advanced" -Name ShowCortanaButton -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "    --> Hide search box..."
New-ItemProperty -Path "$RegDir\Search" -Name SearchboxTaskbarMode -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "    --> Hide Task View..."
New-ItemProperty -Path "$RegDir\Explorer\Advanced" -Name ShowTaskViewButton -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "    --> Hide People..."
if (-not (Test-Path -Path "$RegDir\Explorer\Advanced\People"))
{
    New-Item -Path "$RegDir\Explorer\Advanced\People" -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path "$RegDir\Explorer\Advanced\People" -Name PeopleBand -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "    --> Hide Ink Workspace..."
New-ItemProperty -Path "$RegDir\PenWorkspace" -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "    --> Hide Meet Now..."
$Settings = Get-ItemPropertyValue -Path "$RegDir\Explorer\StuckRects3" -Name Settings -ErrorAction Ignore
$Settings[9] = 128
New-ItemProperty -Path "$RegDir\Explorer\StuckRects3" -Name Settings -PropertyType Binary -Value $Settings -Force | Out-Null
Write-Host "    --> Hide News and Interests..."
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name EnableFeeds -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling Snap Assit..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
New-ItemProperty -Path $RegPath -Name JointResize -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name SnapAssist  -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name SnapFill    -Value 0 -Force | Out-Null

Write-Host "Enabling detailed file transfer dialog box..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name EnthusiastMode -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Hiding new application installation indicator..."
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name NoNewAppAlert -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling first logon animation..."
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
New-ItemProperty -Path $RegPath -Name EnableFirstLogonAnimation -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Setting JPEG wallpaper quality to maximum..."
$RegPath = "HKCU:\Control Panel\Desktop"
New-ItemProperty -Path $RegPath -Name JPEGImportQuality -PropertyType DWord -Value 100 -Force | Out-Null

Write-Host "Starting task manager in the expanded mode..."
# Close current task manager window if exists
$Taskmgr = Get-Process -Name Taskmgr -ErrorAction Ignore
Start-Sleep -Seconds 1
if ($Taskmgr)
{
    $Taskmgr.CloseMainWindow()
}
# Open task manager
Start-Process -FilePath Taskmgr.exe -PassThru | Out-Null
Start-Sleep -Seconds 3
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager"
# get task manager preferences
do
{
    Start-Sleep -Milliseconds 100
    $Preferences = Get-ItemPropertyValue -Path $RegPath -Name Preferences
}
until ($Preferences)
# Close task manager
Stop-Process -Name Taskmgr -ErrorAction Ignore
# Set expanded mode preference
$Preferences[28] = 0
New-ItemProperty -Path $RegPath -Name Preferences -PropertyType Binary -Value $Preferences -Force | Out-Null

Write-Host "Hiding restart notification for updates..."
$RegPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
New-ItemProperty -Path $RegPath -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Removing ' Shortcut' suffix when creating shortcuts..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name ShortcutNameTemplate -PropertyType String -Value "%s.lnk" -Force | Out-Null

Write-Host "Using a different input method for each app..."
Set-WinLanguageBarOption -UseLegacySwitchMode

Write-Host "Disabling storage sense..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name 01 -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Enabling Hibernation..."
$RegPath = "HKLM:\System\CurrentControlSet\Control\Session Manager\Power"
New-ItemProperty -Path $RegPath -Name "HibernteEnabled" -PropertyType Dword -Value 1 -Force | Out-Null
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings"
If (-not (Test-Path -Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name ShowHibernateOption -PropertyType Dword -Value 1 -Force | Out-Null

Write-Host "Disabling 260 character path limit..."
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
New-ItemProperty -Path $RegPath -Name LongPathsEnabled -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Displaying Stop error code when BSoD occurs..."
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl"
New-ItemProperty -Path $RegPath -Name DisplayParameters -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling updates for other Microsoft products in Windows update..."
if (((New-Object -ComObject Microsoft.Update.ServiceManager).Services | Where-Object -FilterScript {$_.ServiceID -eq "7971f918-a847-4430-9279-4a52d1efe18d"}).IsDefaultAUService)
{
    (New-Object -ComObject Microsoft.Update.ServiceManager).RemoveService("7971f918-a847-4430-9279-4a52d1efe18d")
}

Write-Host "Setting default input method to English..."
Set-WinDefaultInputMethodOverride -InputTip "0409:00000409"

Write-Host "Disabling reserved storage after the next update installation..."
try
{
    Set-WindowsReservedStorageState -State Disabled
}
catch [System.Runtime.InteropServices.COMException]
{
    Write-Error -Message "Reserved storage in use. Skip..." -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
}

Write-Host "Disable the shortcut to start Sticky Keys..."
$RegPath = "HKCU:\Control Panel\Accessibility\StickyKeys"
New-ItemProperty -Path $RegPath -Name Flags -PropertyType String -Value 506 -Force | Out-Null

Write-Host "Disabling autoplay..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers"
New-ItemProperty -Path $RegPath -Name DisableAutoplay -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling automatically saving restartable apps..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
New-ItemProperty -Path $RegPath -Name RestartApps -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling automatically restart when an update is newly installed..."
$RegPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
New-ItemProperty -Path $RegPath -Name IsExpedited -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Uninstalling the 'PC Health Check' app..."
$Folder = (New-Object -ComObject Shell.Application).NameSpace("$env:SystemRoot\Installer")
# Find the necessary .msi with the Subject property equal to "Windows PC Health Check"
foreach ($MSI in @(Get-ChildItem -Path "$env:SystemRoot\Installer" -Filter *.msi -File -Force))
{
    $File = $Folder.Items() | Where-Object -FilterScript {$_.Name -eq $MSI.Name}
    # "22" is the "Subject" file property
    if ($Folder.GetDetailsOf($File, 22) -eq "Windows PC Health Check")
    {
        Start-Process -FilePath msiexec.exe -ArgumentList "/uninstall $($MSI.FullName) /quiet /norestart" -Wait
        break
    }
}
# Prevent the "PC Health Check" app from installing in the future
if (-not (Test-Path -Path HKLM:\SOFTWARE\Microsoft\PCHC))
{
    New-Item -Path HKLM:\SOFTWARE\Microsoft\PCHC -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\PCHC -Name PreviousUninstall -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Hiding recently added apps in the Start menu..."
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name HideRecentlyAddedApps -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Hiding app suggestions in the Start menu..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
New-ItemProperty -Path $RegPath -Name SubscribedContent-338388Enabled -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling XBox Game Bar..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
New-ItemProperty -Path $RegPath -Name AppCaptureEnabled -PropertyType DWord -Value 0 -Force | Out-Null
$RegPath = "HKCU:\System\GameConfigStore"
New-ItemProperty -Path $RegPath -Name GameDVR_Enabled -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Removing Unnecessary Appx..."
$Bloatware = @(
    # Intel Graphics Control Center
    "AppUp.IntelGraphicsControlPanel"
    "AppUp.IntelGraphicsExperience"

    # NVIDIA Control Panel
    "NVIDIACorp.NVIDIAControlPanel"

    # Unnecessary Windows 10 AppX Apps
    "Microsoft.3DBuilder"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.AppConnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingTranslator"
    "Microsoft.BingWeather"
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.BingTravel"
    "Microsoft.MinecraftUWP"
    "Microsoft.GamingApp"
    "Microsoft.DesktopAppInstaller"
    "Microsoft.GamingServices"
    "Microsoft.WindowsReadingList"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.News"
    "Microsoft.Office.Lens"
    "Microsoft.Office.Sway"
    "Microsoft.Office.OneNote"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    "Microsoft.Whiteboard"
    "Microsoft.WindowsAlarms"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.XboxApp"
    "Microsoft.ConnectivityStore"
    "Microsoft.CommsPhone"
    "Microsoft.ScreenSketch"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.MixedReality.Portal"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "Microsoft.YourPhone"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MSPaint"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.Windows.Photos"
    "Microsoft.Photos.MediaEngineDLC"
    "Microsoft.WindowsCamera"
    "Microsoft.549981C3F5F10" # Cortana
    "Microsoft.HEVCVideoExtension"
    "Microsoft.WindowsTerminal"
    "Microsoft.WindowsTerminalPreview"
    "Microsoft.WebMediaExtensions"

    # Sponsored Windows 10 AppX Apps
    # Add sponsored/featured apps to remove in the "*AppName*" format
    "*EclipseManager*"
    "*ActiproSoftwareLLC*"
    "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
    "*Duolingo-LearnLanguagesforFree*"
    "*PandoraMediaInc*"
    "*CandyCrush*"
    "*BubbleWitch3Saga*"
    "*Wunderlist*"
    "*Flipboard*"
    "*Twitter*"
    "*Facebook*"
    "*Royal Revolt*"
    "*Sway*"
    "*Speed Test*"
    "*Dolby*"
    "*Viber*"
    "*ACGMediaPlayer*"
    "*Netflix*"
    "*OneCalendar*"
    "*LinkedInforWindows*"
    "*HiddenCityMysteryofShadows*"
    "*Hulu*"
    "*HiddenCity*"
    "*AdobePhotoshopExpress*"
    "*HotspotShieldFreeVPN*"

    "*Microsoft.Advertising.Xaml*"
)
foreach ($Bloat in $Bloatware) {
    Write-Host "Trying to remove $Bloat..."
    Get-AppxPackage -Name $Bloat | Remove-AppxPackage -ErrorAction SilentlyContinue | Out-Null
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
}

Write-Host "Disabling SmartScreen..."
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
New-ItemProperty -Path $RegPath -Name SmartScreenEnabled -PropertyType String -Value Off -Force | Out-Null

Write-Host "Disabling marking downloaded files as unsafe..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name SaveZoneInformation -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Hiding the 'Share' item in the context menu..."
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -PropertyType String -Value "" -Force | Out-Null

Write-Host "Cleaning up the context menu..."
Write-Host "    --> 'Include in Library' item..."
$RegPath = "Registry::HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\Library Location"
New-ItemProperty -Path $RegPath -Name "(default)" -PropertyType String -Value "-{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" -Force | Out-Null
Write-Host "    --> 'Turn on BitLocker' item..."
$RegPath = "Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde-elev"
if ((Get-BitLockerVolume).ProtectionStatus -eq "Off")
{
    New-ItemProperty -Path $RegPath -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force | Out-Null
}
Write-Host "    --> 'Rich Text Document' item..."
$RegPath = "Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew"
if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.WordPad*").State -eq "Installed")
{
    Remove-Item -Path $RegPath -Force -ErrorAction Ignore
}
Write-Host "    --> 'Compressed (zipped) Folder' item in the context menu..."
$RegPath = "Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew"
if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.WordPad*").State -eq "Installed")
{
    Remove-Item -Path $RegPath -Force -ErrorAction Ignore
}
Write-Host "    --> 'Look for an app in the Microsoft Store' item..."
$RegPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
if (-not (Test-Path -Path $RegPath))
{
    New-Item -Path $RegPath -ItemType Directory -Force
}
New-ItemProperty -Path $RegPath -Name NoUseStoreOpenWith -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling Wi-Fi Sense..."
$RegDir = "HKLM:\Software\Microsoft\PolicyManager\default\WiFi"
If (-not (Test-Path "$RegDir\AllowWiFiHotSpotReporting")) {
    New-Item -Path "$RegDir\AllowWiFiHotSpotReporting" -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path "$RegDir\AllowWiFiHotSpotReporting" -Name "Value" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path "$RegDir\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling Application suggestions..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
New-ItemProperty -Path $RegPath -Name "ContentDeliveryAllowed" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "OemPreInstalledAppsEnabled" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "PreInstalledAppsEnabled" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "PreInstalledAppsEverEnabled" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "SilentInstalledAppsEnabled" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "SubscribedContent-338387Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "SubscribedContent-338388Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "SubscribedContent-338389Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "SubscribedContent-353698Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "SystemPaneSuggestionsEnabled" -PropertyType DWord -Value 0 -Force | Out-Null
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name DisableWindowsConsumerFeatures -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling Activity History..."
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
New-ItemProperty -Path $RegPath -Name EnableActivityFeed -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name PublishUserActivities -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name UploadUserActivities -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling automatic Maps updates..."
New-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling Feedback..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "NumberOfSIUFInPeriod" -PropertyType DWord -Value 0 -Force | Out-Null
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
New-ItemProperty -Path $RegPath -Name DoNotShowFeedbackNotifications -PropertyType DWord -Value 1 -Force | Out-Null
Get-ScheduledTask -TaskPath "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskPath "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Disable-ScheduledTask

Write-Host "Disabling Tailored Experiences..."
$RegPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name DisableTailoredExperiencesWithDiagnosticData -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Restricting Windows Update P2P only to local network..."
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "DODownloadMode" -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling Remote Assistance..."
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance"
New-ItemProperty -Path $RegPath -Name "fAllowToGetHelp" -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Removing AutoLogger file and restricting directory..."
$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
If (Test-Path -Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
    Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
}
icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null

Write-Host "Disabling Clipboard history..."
$RegPath = "HKLM:\Software\Policies\Microsoft\Windows\System"
New-ItemProperty -Path $RegPath -Name "AllowClipboardHistory" -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling OneDrive..."
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "DisableFileSyncNGSC" -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Uninstalling OneDrive..."
Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
Start-Sleep -s 2
$onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
If (-not (Test-Path $onedrive)) {
    $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
}
Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
Start-Sleep -s 2
Stop-Process -Name "explorer" -ErrorAction SilentlyContinue
Start-Sleep -s 2
Remove-Item -Path "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
If (-not (Test-Path "HKCR:")) {
    New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}
Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue

Write-Host "Disabling Cortana..."
$RegPath = $RegPath
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force
}
New-ItemProperty -Path $RegPath -Name "AcceptedPrivacyPolicy" -PropertyType DWord -Value 0 -Force | Out-Null
$RegPath = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force
}
New-ItemProperty -Path $RegPath -Name "RestrictImplicitTextCollection" -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "RestrictImplicitInkCollection" -PropertyType DWord -Value 1 -Force | Out-Null
$RegPath = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "HarvestContacts" -PropertyType DWord -Value 0 -Force | Out-Null
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "AllowCortana" -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling driver offering through Windows Update..."
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "PreventDeviceMetadataFromNetwork" -PropertyType DWord -Value 1 -Force | Out-Null
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "DontPromptForWindowsUpdate" -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "DontSearchWindowsUpdate" -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "DriverUpdateWizardWuSearchEnabled" -PropertyType DWord -Value 0 -Force | Out-Null
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "ExcludeWUDriversInQualityUpdate" -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling Windows Update automatic restart..."
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "NoAutoRebootWithLoggedOnUsers" -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty -Path $RegPath -Name "AUPowerManagement" -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling Action Center..."
$RegPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "DisableNotificationCenter" -PropertyType DWord -Value 1 -Force | Out-Null
$RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications"
New-ItemProperty -Path $RegPath -Name "ToastEnabled" -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling Bing Search in Start Menu..."
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
New-ItemProperty -Path $RegPath -Name "BingSearchEnabled" -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "Disabling Xbox Gamebar..."
$RegPath = "HKCU:\SOFTWARE\Microsoft\GameBar"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "ShowStartupPanel" -Value 0 -PropertyType "DWord" -ErrorAction SilentlyContinue -Force | Out-Null

Write-Host "Removing all Start Menu Tiles and pinned Icons in Taskbar..."
$FilePath = "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml"
Set-Content -Path $FilePath -Value '<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">'
Add-Content -Path $FilePath -value '  <LayoutOptions StartTileGroupCellWidth="6" />'
Add-Content -Path $FilePath -value '  <DefaultLayoutOverride>'
Add-Content -Path $FilePath -value '    <StartLayoutCollection>'
Add-Content -Path $FilePath -value '      <defaultlayout:StartLayout GroupCellWidth="6" />'
Add-Content -Path $FilePath -value '    </StartLayoutCollection>'
Add-Content -Path $FilePath -value '  </DefaultLayoutOverride>'
Add-Content -Path $FilePath -value '    <CustomTaskbarLayoutCollection PinListPlacement="Replace" >'
Add-Content -Path $FilePath -value '      <defaultlayout:TaskbarLayout>'
Add-Content -Path $FilePath -value '        <taskbar:TaskbarPinList>'
Add-Content -Path $FilePath -value '        </taskbar:TaskbarPinList>'
Add-Content -Path $FilePath -value '      </defaultlayout:TaskbarLayout>'
Add-Content -Path $FilePath -value '    </CustomTaskbarLayoutCollection>'
Add-Content -Path $FilePath -value '</LayoutModificationTemplate>'
$START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
            <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
    <CustomTaskbarLayoutCollection PinListPlacement="Replace" >
        <defaultlayout:TaskbarLayout>
            <taskbar:TaskbarPinList>
            </taskbar:TaskbarPinList>
        </defaultlayout:TaskbarLayout>
    </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
"@
$layoutFile="$PSScriptRoot\..\StartLayout.xml"
# Delete layout file if it already exists
If (Test-Path $layoutFile)
{
    Remove-Item $layoutFile
}
# Creates the blank layout file
$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
$regAliases = @("HKLM", "HKCU")
# Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
foreach ($regAlias in $regAliases) {
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer"
    If (-not (Test-Path -Path $keyPath)) {
        New-Item -Path $basePath -Name "Explorer" -Force | Out-Null
    }
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1 | Out-Null
    Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile | Out-Null
}
Start-Sleep -Seconds 3
# Restart the Start menu, open the start menu (necessary to load the new layout)
Stop-Process -Name Explorer -Force -ErrorAction Ignore
Start-Sleep -Seconds 3
$wshell = New-Object -ComObject wscript.shell
$wshell.SendKeys('^{ESCAPE}')
Start-Sleep -Seconds 3
# Enable the ability to pin items again by disabling "LockedStartLayout"
foreach ($regAlias in $regAliases) {
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer"
    Remove-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Force -ErrorAction Ignore | Out-Null
    Remove-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Force -ErrorAction Ignore | Out-Null
}
# Remove the layout file
Remove-Item -Path $layoutFile -Force
# Restart the Start menu, open the start menu (necessary to load the new layout)
Stop-Process -Name Explorer -Force -ErrorAction Ignore
Start-Sleep -Seconds 3
# Open the Start menu to load the new layout
$wshell = New-Object -ComObject WScript.Shell
$wshell.SendKeys("^{ESC}")

Write-Host "Unlimiting network bandwidth..."
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Psched"
If (!(Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
New-ItemProperty -Path $RegPath -Name "NonBestEffortLimit" -PropertyType DWord -Value 0
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
New-ItemProperty -Path $RegPath -Name "NetworkThrottlingIndex" -PropertyType DWord -Value 0xffffffff

Write-Host "Removing pinned 'Pictures' and 'Documents' icon in start menu..."
# Ref: https://docs.microsoft.com/en-us/windows/client-management/mdm/policy-csp-start#start-allowpinnedfolderdocuments
$RegPath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Start"
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory -Force | Out-Null
}
# Hide the folder 
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderDocuments      -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderDownloads      -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderFileExplorer   -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderHomeGroup      -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderMusic          -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderNetwork        -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderPersonalFolder -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderSettings       -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderVideos         -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
# Allows to toggle in the settings
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderDocuments_ProviderSet      -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderDownloads_ProviderSet      -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderFileExplorer_ProviderSet   -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderHomeGroup_ProviderSet      -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderMusic_ProviderSet          -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderNetwork_ProviderSet        -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderPersonalFolder_ProviderSet -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderSettings_ProviderSet       -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null
New-ItemProperty -Path $RegPath -Name AllowPinnedFolderVideos_ProviderSet         -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue -Force | Out-Null

Write-Host "Enabling Hyper-V and WSL2..."
Enable-WindowsOptionalFeature -Online -FeatureName "HypervisorPlatform" -All -NoRestart -WarningAction SilentlyContinue| Out-Null
Enable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -All -NoRestart -WarningAction SilentlyContinue| Out-Null
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All -NoRestart -WarningAction SilentlyContinue | Out-Null
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-All" -All -NoRestart -WarningAction SilentlyContinue| Out-Null
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V" -All -NoRestart -WarningAction SilentlyContinue| Out-Null
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Tools-All" -All -NoRestart -WarningAction SilentlyContinue | Out-Null
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Management-PowerShell" -All -NoRestart -WarningAction SilentlyContinue | Out-Null
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Hypervisor" -All -NoRestart -WarningAction SilentlyContinue | Out-Null
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Services" -All -NoRestart -WarningAction SilentlyContinue | Out-Null
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V-Management-Clients" -All -NoRestart -WarningAction SilentlyContinue | Out-Null
cmd /c bcdedit /set hypervisorschedulertype classic

# Tweak services
$services_disable = @(
    "AdAppMgrSvc"                              # Autodesk Desktop App Service
    "AdskLicensingService"                     # Autodesk Desktop Licensing Service
    "AdobeARMservice"                          # Adobe Acrobat Update Service
    "AGMService"                               # Adobe Genuine Monitor Service
    "AGSService"                               # Adobe Genuine Software Integrity Service
    "NetTcpPortSharing"                        # Net.Tcp Port Sharing Service
    "RemoteAccess"                             # Routing and Remote Access
    "RemoteRegistry"                           # Remote Registry
    "SysMain"                                  # Analyze computer usage and improve it by using the collected data
    "dmwappushservice"                         # WAP Push Service
    "HomeGroupListener"                        # Home Groups service
    "HomeGroupProvider"                        # Home Groups service
    "lfsvc"                                    # Geolocation Service
    "MapsBroker"                               # Downloaded Maps Manager
    "TrkWks"                                   # Distributed Link Tracking Client
    "WMPNetworkSvc"                            # Windows Media Player Network Sharing Service
    "WSearch"                                  # Windows Search
    "XblAuthManager"                           # Xbox Live Auth Manager
    "XblGameSave"                              # Xbox Live Game Save Service
    "XboxNetApiSvc"                            # Xbox Live Networking Service
    "XboxGipSvc"                               # Xbox Accessory Management Service
    "ndu"                                      # Windows Network Data Usage Monitor
)
foreach ($service in $services_disable) {
    Write-Host "Setting $service StartupType to Disabled"
    Get-Service -Name $service -ErrorAction SilentlyContinue | Stop-Service -WarningAction SilentlyContinue | Out-Null
    Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue | Out-Null
}

$services_manual = @(
    "AJRouter"                                  # AllJoyn Router Service
    "BcastDVRUserService_b9197"                 # GameDVR and Broadcast used for Game Recordings and Live Broadcasts
    "BDESVC"                                    # Bitlocker
    "Bonjour"                                   # Bonjour service installed via iTunes
    "DPS"                                       # Diagnostic Policy Service
    "dbupdate"                                  # Dropbox Update Service
    "dbupdatem"                                 # Dropbox Update Service, too
    "EntAppSvc"                                 # Enterprise Application Management
    "Fax"                                       # Fax
    "fhsvc"                                     # File Histroy Service
    "FlexNet Licensing Service"                 # FlexNet Licensing Service
    "GamingServicesNet"                         # Gaming Services
    "GamingServices"                            # Gaming Services
    "HPPrintScanDoctorService"                  # HP Print Scan Doctor Service
    "Lenovo Instant On"                         # Lenovo EasyResume Service
    "TPHKLOAD"                                  # Lenovo Hotkey Client Loader
    "PBMPMSVC"                                  # Lenovo PM Service
    "LenovoVantageService"                      # Lenovo Vantage Service
    "LPlatSvc"                                  # Lenovo Platform Service
    "LITSSVC"                                   # Lenovo Intelligent Thermal Solution Service
    "McNeelUpdate"                              # Rhino Update Service
    "diagnosticshub.standardcollector.service"  # Diagnostics Hub Standard Collector Service
    "MicrosoftEdgeElevationService"             # Edge Update Service
    "edgeupdate"                                # Edge Update Service, too
    "edgeupdatem"                               # Edge Update Service, too
    "OLPUpdateService"                          # TencentMeeting OutlookPlugin Update Service
    "PerfHost"                                  # Performance Counter DLL Host
    "pla"                                       # Performance Logs & Alerts
    "PhoneSvc"                                  # Phone Service
    "wercplsupport"                             # Problem Reports Control Panel Support
    "PcaSvc"                                    # Program Compatibility Assistant Service
    "QPCore"                                    # Tencent Protection Core Service
    "QQMusicService"                            # Tencent Music SpeedUp Service
    "QQWbService"                               # Tencent Wubi Input Method Service
    "SCardSvr"                                  # Smart Card
    "ScDeviceEnum"                              # Smart Card Device Enumeration Service
    "SCPolicySvc"                               # Smart Card Removal Policy
    "Steam Client Service"                      # Steam Client Service monitors and updates Steam content
    "ImControllerService"                       # Lenovo System Interface Foundation Service
    "VSStandardCollectorService150"             # Visual Studio Standard Collector Service
    "WemeetUpdateSvc"                           # Tecent Wemeet Update Service
    "ZoomCptService"                            # Zoom Sharing Service
    "gupdate"                                   # Google Update
    "gupdatem"                                  # Google Update, too
    "stisvc"                                    # Windows Image Acquisition (WIA)
    "MSDTC"                                     # Transaction Coordinator
    "WpcMonSvc"                                 # Parental Controls
    "lmhosts"                                   # TCP/IP NetBIOS Helper
    "wisvc"                                     # Windows Insider program (Windows Insider will not work)
    "FontCache"                                 # Windows font cache
    "SEMgrSvc"                                  # Payments and NFC/SE Manager
    "RtkBtManServ"                              # Realtek Bluetooth Device Manager Service
)
foreach ($service in $services_manual) {
    Write-Host "Setting $service StartupType to Manual..."
    Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Manual -ErrorAction SilentlyContinue | Out-Null
}

$services_manual = @(
    "dbupdate"                      # Dropbox Update Service
    "dbupdatem"                     # Dropbox Update Service, too
    "Lenovo Instant On"             # Lenovo EasyResume Service
    "TPHKLOAD"                      # Lenovo Hotkey Client Loader
    "PBMPMSVC"                      # Lenovo PM Service
    "LenovoVantageService"          # Lenovo Vantage Service
    "LPlatSvc"                      # Lenovo Platform Service
    "LITSSVC"                       # Lenovo Intelligent Thermal Solution Service
    "ImControllerService"           # Lenovo System Interface Foundation Service
    "McNeelUpdate"                  # Rhino Update Service
    "OLPUpdateService"              # TencentMeeting OutlookPlugin Update Service
    "QPCore"                        # Tencent Protection Core Service
    "QQMusicService"                # Tencent Music SpeedUp Service
    "QQWbService"                   # Tencent Wubi Input Method Service
    "WemeetUpdateSvc"               # Tecent Wemeet Update Service
    "VSStandardCollectorService150" # Visual Studio Standard Collector Service
    "ZoomCptService"                # Zoom Sharing Service
    "gupdate"                       # Google Update
    "gupdatem"                      # Google Update, too
)
foreach ($service in $services_manual) {
    Write-Host "Setting $service StartupType to Manual..."
    Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Manual -ErrorAction SilentlyContinue | Out-Null
}

# choco install -y 7zip.install
# choco install -y dropbox
# choco install -y irfanview
# choco install -y irfanviewplugins
# choco install -y powertoys
# choco install -y clash-for-windows
# choco install -y wechat --ignore-checksums
# choco install -y internet-download-manager --ignore-checksums
# choco install -y everything --params "/client-service /run-on-system-startup /start-menu-shortcuts"

# Requires restart, or add the -Restart flag
$computername = "X1E"
if ($env:computername -ne $computername) {
    Rename-Computer -NewName $computername -Restart
}
