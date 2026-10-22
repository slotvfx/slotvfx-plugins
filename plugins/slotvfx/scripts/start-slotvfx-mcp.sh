#!/bin/sh
# Starts the MCP server that ships inside SlotVFX Desktop with the Node.js
# built into the app, so no separate Node.js install is needed on macOS.
case "$0" in */*) here=${0%/*} ;; *) here=. ;; esac
# SLOTVFX_APP (path to SlotVFX.app) wins; then the usual folders; then a running
# SlotVFX, so copies kept in another folder are found while they are open.
running=$(/bin/ps -axo comm= 2>/dev/null | sed -n 's#^\(.*\.app\)/Contents/MacOS/SlotVFX$#\1#p' | head -n 1)
for res in ${SLOTVFX_APP:+"$SLOTVFX_APP/Contents/Resources"} "/Applications/SlotVFX.app/Contents/Resources" "$HOME/Applications/SlotVFX.app/Contents/Resources" ${running:+"$running/Contents/Resources"}; do
  [ -d "$res" ] || continue
  server="$res/mcp/adapter/server/slotfxMcpServer.mjs"
  if [ ! -f "$server" ]; then
    exec sh "$here/setup-help.sh" "This SlotVFX Desktop is too old for AI. Update it to version 0.9.64 or newer from https://slotvfx.com, turn on Connect AI in SlotVFX, then restart Claude Code."
  fi
  # Newer SlotVFX builds ship this launcher; older ones run the app itself as Node.js.
  if [ -x "$res/mcp/slotvfx-mcp" ]; then
    exec "$res/mcp/slotvfx-mcp" "$@"
  fi
  for app in "$res/../MacOS/"*; do
    [ -f "$app" ] && [ -x "$app" ] && ELECTRON_RUN_AS_NODE=1 exec "$app" "$server" "$@"
  done
done
# Not macOS (for example Linux): use Node.js if it is there.
if [ "$(uname)" != Darwin ] && command -v node >/dev/null 2>&1; then
  exec node "$here/start-slotvfx-mcp.mjs" "$@"
fi
exec sh "$here/setup-help.sh" "SlotVFX Desktop was not found. If it is not installed, download it from https://slotvfx.com and move it to the Applications folder. If it is in another folder, open SlotVFX first or set SLOTVFX_APP to the SlotVFX.app path. Turn on Connect AI, then restart Claude Code."
