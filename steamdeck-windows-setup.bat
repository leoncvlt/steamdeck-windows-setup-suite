@echo off
set SCRIPT=%~p0steamdeck-windows-setup.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -Verb RunAs PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%SCRIPT%\"'"