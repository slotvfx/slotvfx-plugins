#!/bin/sh
# Starts the MCP server that ships inside SlotVFX Desktop with the Node.js
# built into the app, so no separate Node.js install is needed on macOS.
case "$0" in */*) here=${0%/*} ;; *) here=. ;; esac
for res in "/Applications/SlotVFX.app/Contents/Resources" "$HOME/Applications/SlotVFX.app/Contents/Resources"; do
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
exec sh "$here/setup-help.sh" "SlotVFX Desktop is not installed. Download it from https://slotvfx.com, move it to the Applications folder, open it and turn on Connect AI, then restart Claude Code."
