#!/bin/sh
# The full macOS plugin (plugins/slotvfx-mac) holds the skills. This copies the
# shared parts (skills, licence, notices, icon) and its version into:
#   plugins/slotvfx-windows  the full Windows plugin (its starter, .mcp.json,
#                            plugin.json and README stay Windows-specific)
#   plugins/slotvfx          the skills-only plugin for Anthropic's plugin
#                            directory, which accepts no MCP server that runs on
#                            the user's computer (its plugin.json and README stay
#                            its own, and it must never get .mcp.json or scripts/)
# Run after changing the skills, before build-url-marketplace.sh.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
src="$root/plugins/slotvfx-mac"
version=$(sed -n 's/^ *"version": *"\([^"]*\)".*/\1/p' "$src/.claude-plugin/plugin.json" | head -n 1)
for name in slotvfx-windows slotvfx; do
  dst="$root/plugins/$name"
  rm -rf "$dst/skills" "$dst/assets"
  cp -R "$src/skills" "$src/assets" "$dst/"
  cp "$src/LICENSE" "$src/NOTICE.md" "$dst/"
  sed -i.bak "s/\"version\": *\"[^\"]*\"/\"version\": \"$version\"/" "$dst/.claude-plugin/plugin.json" && rm "$dst/.claude-plugin/plugin.json.bak"
  find "$dst" -name .DS_Store -delete
done
if [ -e "$root/plugins/slotvfx/.mcp.json" ] || [ -e "$root/plugins/slotvfx/scripts" ]; then
  echo "plugins/slotvfx must stay skills-only: remove its .mcp.json and scripts/" >&2
  exit 1
fi
echo "Synced the Windows and skills-only plugins (version $version)"
