@echo off
rem Starts the MCP server that ships inside SlotVFX Desktop with the Node.js
rem built into the app, so no separate Node.js install is needed on Windows.
setlocal
set "APP="
for %%P in ("%LOCALAPPDATA%\Programs\SlotVFX" "%ProgramFiles%\SlotVFX" "%ProgramFiles(x86)%\SlotVFX") do (
  if not defined APP if exist "%%~P\SlotVFX.exe" set "APP=%%~P"
)
if not defined APP (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-help.ps1" "SlotVFX Desktop is not installed. Download it from https://slotvfx.com, install it, open it and turn on Connect AI, then restart Claude Code."
  exit /b 0
)
set "SERVER=%APP%\resources\mcp\adapter\server\slotfxMcpServer.mjs"
if not exist "%SERVER%" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-help.ps1" "This SlotVFX Desktop is too old for AI. Update it to version 0.9.64 or newer from https://slotvfx.com, turn on Connect AI in SlotVFX, then restart Claude Code."
  exit /b 0
)
set "ELECTRON_RUN_AS_NODE=1"
"%APP%\SlotVFX.exe" "%SERVER%" %*
