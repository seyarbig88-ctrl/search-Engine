@echo off
setlocal
chcp 65001 >nul
cd /d "%~dp0"
title AMC Doctor Search - Setup

echo =============================================
echo AMC Doctor Search - Startup and Setup
echo =============================================
echo.

set "PYEXE="
where py >nul 2>nul
if not errorlevel 1 set "PYEXE=py -3"
if not defined PYEXE (
  where python >nul 2>nul
  if not errorlevel 1 set "PYEXE=python"
)
if not defined PYEXE (
  echo ERROR: Python was not found.
  echo Install Python 3.10 or newer and select "Add Python to PATH".
  echo Then close and reopen this window and run this file again.
  goto failed
)

echo Checking Python installation...
%PYEXE% --version
if errorlevel 1 goto failed

if not exist ".venv\Scripts\python.exe" (
  echo.
  echo Creating the virtual environment...
  %PYEXE% -m venv .venv
  if errorlevel 1 (
    echo ERROR: Could not create the virtual environment.
    goto failed
  )
)

echo.
echo Checking pip...
.venv\Scripts\python.exe -m ensurepip --upgrade
if errorlevel 1 echo WARNING: ensurepip reported a problem; continuing to package installation.

echo.
echo Installing required packages. Internet access may be needed on first run...
.venv\Scripts\python.exe -m pip install -r requirements.txt
if errorlevel 1 (
  echo.
  echo ERROR: Required packages could not be installed.
  echo Check internet connection, proxy/firewall, and the error shown above.
  goto failed
)

echo.
echo Setup completed. Keep this window open while using the website.
echo Browser address: http://127.0.0.1:5000
echo.
start "" http://127.0.0.1:5000
.venv\Scripts\python.exe -u app.py
if errorlevel 1 (
  echo.
  echo ERROR: The website stopped with an error. Read the message above.
  goto failed
)
echo.
echo Website process ended.
pause
exit /b 0

:failed
echo.
echo Setup/startup did not complete. Please take a photo of this entire window,
echo especially the first red/error message, and send it for troubleshooting.
pause
exit /b 1
