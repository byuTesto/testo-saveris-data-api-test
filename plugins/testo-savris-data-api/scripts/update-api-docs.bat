@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\skills\api-doc-update\scripts\update-api-docs.ps1" %*
