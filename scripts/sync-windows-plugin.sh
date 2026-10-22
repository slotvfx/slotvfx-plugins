#!/bin/sh
# Copies the shared parts of the macOS plugin (skills, licence, notices, icon)
# into the Windows plugin. Its starter, .mcp.json, plugin.json and README stay
# Windows-specific. Run after changing the skills, before build-url-marketplace.sh.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
src="$root/plugins/slotvfx"
dst="$root/plugins/slotvfx-windows"
rm -rf "$dst/skills" "$dst/assets"
cp -R "$src/skills" "$src/assets" "$dst/"
cp "$src/LICENSE" "$src/NOTICE.md" "$dst/"
version=$(sed -n 's/^ *"version": *"\([^"]*\)".*/\1/p' "$src/.claude-plugin/plugin.json" | head -n 1)
sed -i.bak "s/\"version\": *\"[^\"]*\"/\"version\": \"$version\"/" "$dst/.claude-plugin/plugin.json" && rm "$dst/.claude-plugin/plugin.json.bak"
find "$dst" -name .DS_Store -delete
echo "Synced the Windows plugin (version $version)"
