@echo off
chcp 65001 > nul
color 0A

:: ┌────────────────────────────────────────┐
:: │ This software was prepared by Oğuzhan D.│
:: │ - Version 0.0.1 Alpha                  │
:: └────────────────────────────────────────┘
echo ┌────────────────────────────────────────┐
echo │ This software was prepared by Oğuzhan D.│
echo │ - Version 0.0.1 Alpha                  │
echo └────────────────────────────────────────┘
echo.

:: Elevating window with administrator privileges
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\\getadmin.vbs" del "%temp%\\getadmin.vbs" ) && fsutil dirty query %systemdrive% >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0"" %params%", "", "runas", 1 > "%temp%\\getadmin.vbs"
    "%temp%\\getadmin.vbs"
    exit /B
)

:: Scanning processes begin...
echo ┌────────────────────────────────────────┐
echo │ Running scans with administrator       │
echo │ privileges...                          │
echo └────────────────────────────────────────┘
echo.

echo ┌────────────────────────────────────────┐
echo │ Starting "SFC /ScanNow" scan           │
SFC /ScanNow
echo └────────────────────────────────────────┘
echo.

echo ┌────────────────────────────────────────┐
echo │ Starting "DISM /Online /Cleanup-Image  │
echo │ /CheckHealth" scan                     │
DISM /Online /Cleanup-Image /CheckHealth
echo └────────────────────────────────────────┘
echo.

echo ┌────────────────────────────────────────┐
echo │ Starting "DISM /Online /Cleanup-Image  │
echo │ /ScanHealth" scan                      │
DISM /Online /Cleanup-Image /ScanHealth
echo └────────────────────────────────────────┘
echo.

echo ┌────────────────────────────────────────┐
echo │ Starting "DISM /Online /Cleanup-Image  │
echo │ /RestoreHealth" scan                   │
DISM /Online /Cleanup-Image /RestoreHealth
echo └────────────────────────────────────────┘
echo.

echo y|chkdsk c: /f /r /x

:: Cleaning temporary and prefetch files
echo ┌────────────────────────────────────────┐
echo │ Cleaning temporary files...            │
del %temp%\*.* /s /q
echo └────────────────────────────────────────┘
echo.

:: Defragmenting C: drive
echo ┌────────────────────────────────────────┐
echo │ Defragmenting C: drive...              │
defrag c:
echo └────────────────────────────────────────┘
echo.
echo ┌────────────────────────────────────────┐
echo │ Update Fix...             │
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
echo └────────────────────────────────────────┘
echo.
echo ┌────────────────────────────────────────┐
echo │ Cleaning  files...             │
cleanmgr /sageset:1
echo └────────────────────────────────────────┘
echo.

:: Completion of scanning and maintenance tasks
echo ┌────────────────────────────────────────┐
echo │ Scan and maintenance tasks completed   │
echo └────────────────────────────────────────┘
echo.

:: Winget installation check and package updates
:: Check if winget is installed
winget --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ┌────────────────────────────────────────┐
    echo │ Winget is not installed. Please install│
    echo │ the latest version of App Installer    │
    echo │ from the Microsoft Store.              │
    echo └────────────────────────────────────────┘
    pause
) else (
    echo ┌────────────────────────────────────────┐
    echo │ Updating all installed packages using  │
    echo │ winget...                              │
    winget upgrade --all
    echo └────────────────────────────────────────┘
    echo ┌────────────────────────────────────────┐
    echo │ All processes have been completed.     │
    echo └────────────────────────────────────────┘
)

echo ┌────────────────────────────────────────┐
echo │ Please restart your computer           │
echo └────────────────────────────────────────┘
pause
exit
