@echo off
cd /d "%~dp0"

echo ================================================
echo   Earth Weather and Ocean Info - Local Server
echo ================================================
echo.

set "PYTHON_CMD="

where py >nul 2>&1 && set "PYTHON_CMD=py"
if not defined PYTHON_CMD where python >nul 2>&1 && set "PYTHON_CMD=python"
if not defined PYTHON_CMD where python3 >nul 2>&1 && set "PYTHON_CMD=python3"

if not defined PYTHON_CMD (
  echo [ERROR] Python 3 was not found on this system.
  echo         Please install it from: https://www.python.org/downloads/
  pause
  exit /b 1
)

echo Using Python command: %PYTHON_CMD%
echo Server URL: http://localhost:8080
echo Close this window to stop the server.
echo.

start "" "http://localhost:8080"
%PYTHON_CMD% -m http.server 8080
