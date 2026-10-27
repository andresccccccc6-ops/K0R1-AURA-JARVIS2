@echo off
chcp 65001 >nul
title Diagnostico K0R1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'Stop'; try { & '%~dp0K0R1.ps1' } catch { Write-Host '--- ERROR DETECTADO ---' -ForegroundColor Red; $_.Exception.Message; $_.ScriptStackTrace; Read-Host 'Presiona Enter para salir' }"