@echo off
chcp 65001 > nul
color 0A

:: ┌────────────────────────────────────────┐
:: │ Bu yazılım Oğuzhan D. tarafından       │
:: │ hazırlanmıştır - Sürüm 0.0.1 Alfa      │
:: └────────────────────────────────────────┘
echo ┌────────────────────────────────────────┐
echo │ Bu yazılım Oğuzhan D. tarafından       │
echo │ hazırlanmıştır - Sürüm 0.0.1 Alfa      │
echo └────────────────────────────────────────┘
echo.

:: Yönetici ayrıcalıkları ile pencere yükseltme
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\\getadmin.vbs" del "%temp%\\getadmin.vbs" ) && fsutil dirty query %systemdrive% >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0"" %params%", "", "runas", 1 > "%temp%\\getadmin.vbs"
    "%temp%\\getadmin.vbs"
    exit /B
)

:: Tarama işlemleri başlıyor...
echo ┌────────────────────────────────────────┐
echo │ Yönetici ayrıcalıkları ile taramalar   │
echo │ gerçekleştiriliyor...                  │
echo └────────────────────────────────────────┘
echo.

echo ┌────────────────────────────────────────┐
echo │ "SFC /ScanNow" taraması başlatılıyor   │
SFC /ScanNow
echo └────────────────────────────────────────┘
echo.

echo ┌────────────────────────────────────────┐
echo │ "DISM /Online /Cleanup-Image           │
echo │ /CheckHealth" taraması başlatılıyor    │
DISM /Online /Cleanup-Image /CheckHealth
echo └────────────────────────────────────────┘
echo.

echo ┌────────────────────────────────────────┐
echo │ "DISM /Online /Cleanup-Image           │
echo │ /ScanHealth" taraması başlatılıyor     │
DISM /Online /Cleanup-Image /ScanHealth
echo └────────────────────────────────────────┘
echo.

echo ┌────────────────────────────────────────┐
echo │ "DISM /Online /Cleanup-Image           │
echo │ /RestoreHealth" taraması başlatılıyor  │
DISM /Online /Cleanup-Image /RestoreHealth
echo └────────────────────────────────────────┘
echo.

echo y|chkdsk c: /f /r /x

:: Geçici dosyaların ve Prefetch dosyalarının temizlenmesi
echo ┌────────────────────────────────────────┐
echo │ Geçici dosyalar temizleniyor...        │
del %temp%\*.* /s /q
echo └────────────────────────────────────────┘
echo.

:: C: sürücüsünün defragmentasyonu
echo ┌────────────────────────────────────────┐
echo │ C: sürücüsü defragmente ediliyor...    │
defrag c:
echo └────────────────────────────────────────┘
echo.
echo ┌────────────────────────────────────────┐
echo │ Güncelleme sistemi düzeltiliyor..      │
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
echo │ Dosyalar temizleniyor...               │
cleanmgr /sageset:1
echo └────────────────────────────────────────┘
echo.
:: Tarama ve bakım işlemlerinin tamamlanması
echo ┌────────────────────────────────────────┐
echo │ Tarama ve bakım işlemleri tamamlandı   │
echo └────────────────────────────────────────┘
echo.

:: Winget kontrolü ve paketlerin güncellenmesi
:: Winget yüklü mü kontrol et
winget --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ┌────────────────────────────────────────┐
    echo │ Winget yüklü değil. Lütfen Microsoft   │
    echo │ Store'dan en son App Installer sürümünü│
    echo │ yükleyin.                              │
    echo └────────────────────────────────────────┘
    pause
) else (
    echo ┌────────────────────────────────────────┐
    echo │ Tüm yüklü paketler winget kullanılarak │
    echo │ güncelleniyor...                       │
    winget upgrade --all
    echo └────────────────────────────────────────┘
    echo ┌────────────────────────────────────────┐
    echo │ Tüm işlemler tamamlandı.               │
    echo └────────────────────────────────────────┘
)

echo ┌────────────────────────────────────────┐
echo │ Lütfen bilgisayarınızı yeniden başlatın │
echo └────────────────────────────────────────┘
pause
exit
