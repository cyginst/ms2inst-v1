@if(0)==(0) echo off
:: URL: https://github.com/cyginst/ms2inst-v1/blob/master/ms2inst.bat
setlocal ENABLEDELAYEDEXPANSION

if "%1"=="SUBPROC" goto skip_init

set MSYS2_NAME=ms2prep
set MSYS2_BITS=32
set MSYS2_PKGS=diffutils,procps,psmisc
set MSYS2_PKGS=%MSYS2_PKGS%,tmux-git &:: THIS IS TMUX
set MSYS2_PKGS=%MSYS2_PKGS%,vim      &:: THIS IS VIM
set MSYS2_PKGS=%MSYS2_PKGS%,         &:: THIS IS EMPTY
set MSYS2_USE_MINGW32=1
set MSYS2_USE_MINGW64=1
set MSYS2_USE_MSYS=1
::set DT_ICONS=1
::set MSYS2_HOME=.
::set MSYS2_ASIS=1

set MSYS2_DEBUG=0
set MSYS2_FONT=MS Gothic
set MSYS2_FONT_HEIGHT=12
set MSYS2_CURSOR_TYPE=block
set MSYS2_CONFIRM_EXIT=no

:skip_init


set SCRIPT=%~0
for /f "delims=\ tokens=*" %%z in ("%SCRIPT%") do (set SCRIPT_CURRENT_DIR=%%~dpz)

if "%MSYS2_DEBUG%"=="1" echo on
if /i "%MSYS2_BITS%"=="auto" (
    if exist "%ProgramFiles(x86)%" (
        set MSYS2_BITS=64
    ) else (
        set MSYS2_BITS=32
    )
)
set MSYS2_SETUP=
if "%MSYS2_BITS%"=="32" (
    set MSYS2_SETUP=msys2-i686-20161025.7z
) else if "%MSYS2_BITS%"=="64" (
    set MSYS2_SETUP=msys2-x86_64-20161025.7z
) else (
    echo MSYS2_BITS must be 32 or 64. [Current MSYS2_BITS: %MSYS2_BITS%] Aborting!
    if not "%1"=="SUBPROC" pause
    exit /b
)
if not exist .binaries mkdir .binaries
call :dl_from_url 7z.exe https://github.com/cyginst/msys2bin/raw/master/7z.exe
call :dl_from_url 7z.dll https://github.com/cyginst/msys2bin/raw/master/7z.dll
call :dl_from_url %MSYS2_SETUP% https://github.com/cyginst/msys2bin/raw/master/%MSYS2_SETUP%
set MSYS2_ROOT=%SCRIPT_CURRENT_DIR%%MSYS2_NAME%.m%MSYS2_BITS%
if not exist "%MSYS2_ROOT%" (
    if exist "%MSYS2_ROOT%.tmp" rmdir /s /q "%MSYS2_ROOT%.tmp"
    .binaries\7z.exe x -y -o"%MSYS2_ROOT%.tmp" ".binaries\%MSYS2_SETUP%" && move "%MSYS2_ROOT%.tmp" "%MSYS2_ROOT%"
)
set HOME=%MSYS2_ROOT%
::set cmd="%MSYS2_ROOT%\usr\bin\bash.exe" --norc -l -c "pacman --noconfirm -Syuu"
set cmd="%MSYS2_ROOT%\usr\bin\bash.exe" --norc -l -c "pacman -Syuu"
echo [1st] %cmd%
%cmd%
echo [2nd] %cmd%
%cmd%
echo [3rd] %cmd%
%cmd%
set cmd="%MSYS2_ROOT%\usr\bin\bash.exe" --norc -l -c "pkgfile --update"
echo %cmd%
set cmd="%MSYS2_ROOT%\usr\bin\bash.exe" --norc -l -c "pacman --noconfirm -Fy"
echo %cmd%
%cmd%
%cmd%

echo Preparation for %MSYS2_NAME% finished!

endlocal
if not "%1"=="SUBPROC" pause
exit /b
goto :EOF

:dl_from_url
if not exist .binaries mkdir .binaries
if not exist "%SCRIPT_CURRENT_DIR%.binaries\%1" bitsadmin /TRANSFER "%1" "%2" "%SCRIPT_CURRENT_DIR%.binaries\%1"
exit /b

:trim
set %2=%1
exit /b

@end
