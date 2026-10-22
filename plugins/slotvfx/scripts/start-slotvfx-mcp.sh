#!/bin/sh
# Starts the MCP server that ships inside SlotVFX Desktop with the Node.js
# built into the app, so no separate Node.js install is needed on macOS.
for res in "/Applications/SlotVFX.app/Contents/Resources" "$HOME/Applications/SlotVFX.app/Contents/Resources"; do
  server="$res/mcp/adapter/server/slotfxMcpServer.mjs"
  [ -f "$server" ] || continue
  # Newer SlotVFX builds ship this launcher; older ones run the app itself as Node.js.
  if [ -x "$res/mcp/slotvfx-mcp" ]; then
    exec "$res/mcp/slotvfx-mcp" "$@"
  fi
  ELECTRON_RUN_AS_NODE=1 exec "$res/../MacOS/SlotVFX" "$server" "$@"
done
# Elsewhere (for example Windows with Git Bash), fall back to Node.js.
if command -v node >/dev/null 2>&1; then
  exec node "$(dirname "$0")/start-slotvfx-mcp.mjs" "$@"
fi
echo "SlotVFX Desktop was not found in /Applications or ~/Applications. Install SlotVFX Desktop and turn on Connect AI." >&2
exit 1
