#!/bin/sh
# The full macOS plugin (plugins/slotvfx-mac) holds the skills. This copies the
# shared parts (skills, licence, notices, icon) and its version into:
#   plugins/slotvfx-windows  the full Windows plugin (its starter, .mcp.json,
#                            plugin.json and README stay Windows-specific)
#   plugins/slotvfx          the skills-only plugin for Anthropic's plugin
#                            directory, which accepts no MCP server that runs on
#                            the user's computer (its plugin.json and README stay
#                            its own, and it must never get .mcp.json, scripts/
#                            or any skill's scripts/ folder)
# Run after changing the skills, before build-url-marketplace.sh.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
src="$root/plugins/slotvfx-mac"
version=$(sed -n 's/^ *"version": *"\([^"]*\)".*/\1/p' "$src/.claude-plugin/plugin.json" | head -n 1)
# Stamp the plugin version into the skills' "SlotVFX skills version:" line, so
# assistants can compare it with slotfx_get_bridge_status.skills.latestVersion.
for f in "$src"/skills/*/SKILL.md; do
  sed -i.bak "s/^SlotVFX skills version: [0-9][0-9.]*\./SlotVFX skills version: $version./" "$f" && rm "$f.bak"
done
for name in slotvfx-windows slotvfx; do
  dst="$root/plugins/$name"
  rm -rf "$dst/skills" "$dst/assets"
  cp -R "$src/skills" "$src/assets" "$dst/"
  cp "$src/LICENSE" "$src/NOTICE.md" "$dst/"
  sed -i.bak "s/\"version\": *\"[^\"]*\"/\"version\": \"$version\"/" "$dst/.claude-plugin/plugin.json" && rm "$dst/.claude-plugin/plugin.json.bak"
  find "$dst" -name .DS_Store -delete
done
# Anthropic's directory refuses any program file from an unverified publisher:
# the skills-only copy drops the skills' helper scripts (the skills say what to
# do without them), and may only hold Markdown, text, JSON, YAML and images.
rm -rf "$root"/plugins/slotvfx/skills/*/scripts
if [ -e "$root/plugins/slotvfx/.mcp.json" ] || [ -e "$root/plugins/slotvfx/scripts" ]; then
  echo "plugins/slotvfx must stay skills-only: remove its .mcp.json and scripts/" >&2
  exit 1
fi
bad=$(find "$root/plugins/slotvfx" -type f ! -name LICENSE ! -name '*.md' ! -name '*.txt' \
  ! -name '*.json' ! -name '*.yaml' ! -name '*.yml' ! -name '*.png' ! -name '*.jpg' \
  ! -name '*.jpeg' ! -name '*.gif' ! -name '*.webp' ! -name '*.ico')
shebang=$(find "$root/plugins/slotvfx" -type f -exec sh -c 'head -c 2 "$1" | grep -q "^#!" && echo "$1"' _ {} \;)
if [ -n "$bad$shebang" ]; then
  printf 'plugins/slotvfx may only hold Markdown, text, JSON, YAML and images, none starting with #!:\n%s\n%s\n' "$bad" "$shebang" >&2
  exit 1
fi
echo "Synced the Windows and skills-only plugins (version $version)"
