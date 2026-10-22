@echo off
rem Starts the MCP server that ships inside SlotVFX Desktop with the Node.js
rem built into the app, so no separate Node.js install is needed on Windows.
setlocal
set "APP="
for %%P in ("%LOCALAPPDATA%\Programs\SlotVFX" "%ProgramFiles%\SlotVFX" "%ProgramFiles(x86)%\SlotVFX") do (
  if not defined APP if exist "%%~P\SlotVFX.exe" set "APP=%%~P"
)
rem Installed somewhere else, or unzipped: ask the running app or the installer's registry entry.
rem Set SLOTVFX_APP to the SlotVFX folder to choose one yourself.
if defined SLOTVFX_APP if exist "%SLOTVFX_APP%\SlotVFX.exe" set "APP=%SLOTVFX_APP%"
set "FOUND=%TEMP%\slotvfx-app-folder-%RANDOM%.txt"
if not defined APP (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0find-slotvfx.ps1" < NUL > "%FOUND%" 2> NUL
  set /p APP=< "%FOUND%"
  del "%FOUND%" 2> NUL
)
if not defined APP (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-help.ps1" "SlotVFX Desktop was not found. If it is not installed, download it from https://slotvfx.com. If it is installed in another folder, open SlotVFX first or set SLOTVFX_APP to that folder. Turn on Connect AI, then restart Claude Code."
  exit /b 0
)
set "SERVER=%APP%\resources\mcp\adapter\server\slotfxMcpServer.mjs"
if not exist "%SERVER%" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-help.ps1" "This SlotVFX Desktop is too old for AI. Update it to version 0.9.64 or newer from https://slotvfx.com, turn on Connect AI in SlotVFX, then restart Claude Code."
  exit /b 0
)
set "ELECTRON_RUN_AS_NODE=1"
"%APP%\SlotVFX.exe" "%SERVER%" %*
