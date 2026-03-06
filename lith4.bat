@echo off
title LITH Security Toolkit - by Sopa
color 0a
cd /d "%~dp0"

:: =========================================
:: LITH SECURITY TOOLKIT
:: Created by Sopa
:: A simple Windows diagnostics and
:: security helper written in batch.
::
:: This tool demonstrates:
:: - system diagnostics
:: - automation
:: - logging
:: - CLI menu systems
:: =========================================

:: Create log files if missing
if not exist lith_log.txt echo LITH Security Log Created on %date% %time% > lith_log.txt
if not exist lith_report.txt echo LITH Reports > lith_report.txt

:menu
cls
echo =========================================
echo        LITH SECURITY TOOLKIT - by Sopa
echo =========================================
echo.
echo SYSTEM TOOLS
echo 1  - Quick Computer Safety Check
echo 2  - Show Running Programs
echo 3  - Check RAM Usage
echo 4  - Check CPU Usage
echo 5  - Check Disk Health
echo 6  - Full System Information
echo.
echo NETWORK TOOLS
echo 7  - Show Internet Connections
echo 8  - Show Open Network Ports
echo 9  - Scan Devices On Your WiFi
echo 10 - Watch Network Activity
echo 11 - Monitor Network Traffic
echo 12 - Check If Another Device Is Online
echo.
echo SECURITY TOOLS
echo 13 - Scan For Suspicious Files
echo 14 - View Startup Programs
echo 15 - Run Windows System File Check
echo 16 - Run Windows Defender Quick Scan
echo.
echo CLEANUP TOOLS
echo 17 - Clean Temporary Files
echo 18 - Empty Recycle Bin
echo.
echo MONITORING
echo 19 - Live CPU Monitor
echo 20 - Live RAM Monitor
echo.
echo LOGS
echo 21 - View Security Log
echo 22 - Write Message To Log
echo 23 - Generate Full Security Report
echo.
echo NETWORK ADVANCED
echo 24 - Find Location Of A Public IP
echo 25 - Network Activity Graph
echo 26 - Network Device List
echo 27 - System Security Score
echo.
echo EXTRA SYSTEM INFO
echo 28 - Show Network Devices
echo 29 - Test Internet Connection
echo 30 - Show Logged In Users
echo 31 - Show Installed Programs
echo 32 - Show System Uptime
echo 33 - Quick LAN Overview
echo.
echo 34 - Exit
echo.
set /p choice=Choose a tool number: 

if "%choice%"=="1" goto quick
if "%choice%"=="2" goto processes
if "%choice%"=="3" goto ram
if "%choice%"=="4" goto cpu
if "%choice%"=="5" goto disk
if "%choice%"=="6" goto sysinfo
if "%choice%"=="7" goto net
if "%choice%"=="8" goto ports
if "%choice%"=="9" goto lanscan
if "%choice%"=="10" goto lanalert
if "%choice%"=="11" goto traffic
if "%choice%"=="12" goto pingtest
if "%choice%"=="13" goto suspicious
if "%choice%"=="14" goto startup
if "%choice%"=="15" goto sfcscan
if "%choice%"=="16" goto defender
if "%choice%"=="17" goto clean
if "%choice%"=="18" goto recycle
if "%choice%"=="19" goto cpumonitor
if "%choice%"=="20" goto rammonitor
if "%choice%"=="21" goto viewlog
if "%choice%"=="22" goto writelog
if "%choice%"=="23" goto report
if "%choice%"=="24" goto iplookup
if "%choice%"=="25" goto netgraph
if "%choice%"=="26" goto arp
if "%choice%"=="27" goto threat
if "%choice%"=="28" goto arp
if "%choice%"=="29" goto speed
if "%choice%"=="30" goto users
if "%choice%"=="31" goto programs
if "%choice%"=="32" goto uptime
if "%choice%"=="33" goto laninfo
if "%choice%"=="34" exit

goto menu

:: ===============================
:: BASIC SYSTEM CHECK
:: ===============================

:quick
cls
echo Running quick system safety check...
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
echo %date% %time% - Quick safety check executed >> lith_log.txt
pause
goto menu

:processes
cls
echo Showing currently running programs...
tasklist
pause
goto menu

:ram
cls
echo RAM Usage Information:
wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Format:List
pause
goto menu

:cpu
cls
echo CPU Usage:
wmic cpu get LoadPercentage
pause
goto menu

:disk
cls
echo Disk Health Status:
wmic diskdrive get Model,Status
pause
goto menu

:sysinfo
cls
echo Full System Information:
systeminfo
pause
goto menu

:: ===============================
:: NETWORK
:: ===============================

:net
cls
netstat -ano
pause
goto menu

:ports
cls
netstat -a -n -o | findstr LISTEN
pause
goto menu

:lanscan
cls
echo Scanning typical home network range...
echo (192.168.1.x)
for /L %%i in (1,1,254) do (
ping -n 1 192.168.1.%%i | find "Reply"
)
pause
goto menu

:lanalert
cls
echo Monitoring network activity...
echo Press CTRL+C to stop.
:loop
arp -a
timeout 10 >nul
goto loop

:traffic
cls
netstat -e
pause
goto menu

:pingtest
cls
echo This checks if another computer is reachable.
echo Example IP: 192.168.1.10
set /p ip=Enter device IP address: 
ping %ip%
pause
goto menu

:: ===============================
:: SECURITY
:: ===============================

:suspicious
cls
echo Checking common folders for executable files...
for %%F in ("%userprofile%\Desktop" "%userprofile%\Downloads") do (
dir /b "%%F\*.exe" 2>nul
)
pause
goto menu

:startup
cls
wmic startup get Caption,Command
pause
goto menu

:sfcscan
cls
echo Running Windows System File Checker...
sfc /scannow
pause
goto menu

:defender
cls
echo Starting Windows Defender quick scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
pause
goto menu

:: ===============================
:: CLEANUP
:: ===============================

:clean
cls
echo Cleaning temporary files...
del /q /f /s %temp%\*
echo Temporary files removed.
pause
goto menu

:recycle
cls
powershell.exe -NoProfile -Command Clear-RecycleBin -Force
pause
goto menu

:: ===============================
:: MONITORING
:: ===============================

:cpumonitor
cls
echo Press CTRL+C to stop monitoring.
:cpu_loop
wmic cpu get LoadPercentage
timeout 2 >nul
goto cpu_loop

:rammonitor
cls
echo Press CTRL+C to stop monitoring.
:ram_loop
wmic OS get FreePhysicalMemory
timeout 2 >nul
goto ram_loop

:: ===============================
:: LOGGING
:: ===============================

:viewlog
cls
type lith_log.txt
pause
goto menu

:writelog
cls
set /p msg=Write message for log: 
echo %date% %time% - %msg% >> lith_log.txt
pause
goto menu

:report
cls
echo Generating system security report...
systeminfo > lith_report.txt
netstat -ano >> lith_report.txt
tasklist >> lith_report.txt
echo Report saved as lith_report.txt
pause
goto menu

:: ===============================
:: IP LOOKUP
:: ===============================

:iplookup
cls
echo This tool finds the location of a PUBLIC IPv4 address.
echo.
echo Examples:
echo 8.8.8.8
echo 1.1.1.1
echo.
echo NOTE: Private addresses like:
echo 192.168.x.x or 10.x.x.x cannot be located.
echo.
set /p ip=Enter IPv4 Address: 
powershell -Command "Invoke-RestMethod http://ip-api.com/json/%ip% | Select country,city,isp"
pause
goto menu

:: ===============================

:netgraph
cls
echo Simple ASCII Network Activity Graph
echo Press CTRL+C to stop.
:graph
set /a size=%random% %% 40
set line=
for /L %%i in (1,1,%size%) do set line=!line!#
echo !line!
timeout /t 2 >nul
goto graph

:arp
cls
arp -a
pause
goto menu

:threat
cls
set score=100
for /f %%a in ('tasklist ^| find /c ".exe"') do set processes=%%a
if %processes% GTR 200 set /a score-=20
echo System Security Score: %score% / 100
pause
goto menu

:speed
cls
ping google.com
pause
goto menu

:users
cls
query user
pause
goto menu

:programs
cls
wmic product get name
pause
goto menu

:uptime
cls
net stats workstation | find "Statistics since"
pause
goto menu

:laninfo
cls
ipconfig
arp -a
pause
goto menu