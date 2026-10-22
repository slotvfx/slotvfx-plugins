#!/bin/sh
# A tiny MCP server used only when SlotVFX can't start. It tells Claude what is
# missing (passed as $1), so Claude can explain the fix to the user in chat.
msg=$(printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g')
reply() { printf '{"jsonrpc":"2.0","id":%s,%s}\n' "$id" "$1"; }
while IFS= read -r line || [ -n "$line" ]; do
  id=$(printf '%s' "$line" | sed -nE 's/.*"id"[[:space:]]*:[[:space:]]*("[^"]*"|-?[0-9]+).*/\1/p')
  [ -n "$id" ] || continue
  method=$(printf '%s' "$line" | sed -nE 's/.*"method"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/p')
  case $method in
    initialize)
      version=$(printf '%s' "$line" | sed -nE 's/.*"protocolVersion"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/p')
      reply "\"result\":{\"protocolVersion\":\"${version:-2025-06-18}\",\"capabilities\":{\"tools\":{}},\"serverInfo\":{\"name\":\"slotvfx-setup\",\"version\":\"1.0.0\"},\"instructions\":\"$msg\"}" ;;
    tools/list)
      reply "\"result\":{\"tools\":[{\"name\":\"slotfx_setup_status\",\"description\":\"SlotVFX is not connected yet. Call this and tell the user exactly what it says. $msg\",\"inputSchema\":{\"type\":\"object\",\"properties\":{}}}]}" ;;
    tools/call)
      reply "\"result\":{\"content\":[{\"type\":\"text\",\"text\":\"$msg\"}],\"isError\":true}" ;;
    ping)
      reply '"result":{}' ;;
    *)
      reply '"error":{"code":-32601,"message":"SlotVFX is not connected yet."}' ;;
  esac
done
