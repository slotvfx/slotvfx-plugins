#!/bin/sh
# Builds dist/: a zip of the plugin and a marketplace.json that points at it,
# so Claude Code can install the plugin over HTTPS without Git.
# Run after changing the plugin, then commit dist/ together with the change.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
base="https://raw.githubusercontent.com/slotvfx/slotvfx-plugins/main/dist"
version=$(sed -n 's/^ *"version": *"\([^"]*\)".*/\1/p' "$root/plugins/slotvfx/.claude-plugin/plugin.json" | head -n 1)
zipname="slotvfx-plugin-$version.zip"
mkdir -p "$root/dist"
rm -f "$root"/dist/slotvfx-plugin-*.zip
(cd "$root/plugins/slotvfx" && zip -qrX "$root/dist/$zipname" . -x '*.DS_Store')
sha=$(shasum -a 256 "$root/dist/$zipname" | cut -d ' ' -f 1)
cat > "$root/dist/marketplace.json" <<JSON
{
  "name": "slotvfx",
  "owner": {
    "name": "SlotVFX (Gamix Labs)",
    "url": "https://slotvfx.com"
  },
  "metadata": {
    "description": "SlotVFX plugins for Claude Code, installed without Git: create, animate, test and export slot game VFX in SlotVFX Desktop."
  },
  "plugins": [
    {
      "name": "slotvfx",
      "source": {
        "source": "archive",
        "url": "$base/$zipname",
        "sha256": "$sha"
      },
      "description": "Claude Code plugin for SlotVFX: 20 skills plus the SlotVFX Desktop MCP connection, so Claude can create, animate, test and export slot game VFX (win celebrations, transitions, particles, Spine) right in the editor.",
      "category": "design"
    }
  ]
}
JSON
echo "Built dist/$zipname ($sha)"
