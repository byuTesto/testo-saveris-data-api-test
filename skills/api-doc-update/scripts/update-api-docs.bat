@echo off
setlocal

set "TARGET=%~1"
if "%TARGET%"=="" set "TARGET=all"

where pwsh >nul 2>nul
if %ERRORLEVEL%==0 (
  pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0update-api-docs.ps1" -Target "%TARGET%"
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update-api-docs.ps1" -Target "%TARGET%"
)
