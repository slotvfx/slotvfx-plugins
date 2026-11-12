#!/bin/sh
# Builds dist/: a zip of each plugin and a marketplace.json that points at them,
# so Claude Code can install the plugins over HTTPS without Git.
# Run scripts/sync-plugins.sh first, then this, and commit dist/ with the change.
# The plugin named slotvfx here is the full macOS plugin in plugins/slotvfx-mac;
# plugins/slotvfx is the skills-only copy for Anthropic's directory and isn't built.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
base="https://raw.githubusercontent.com/slotvfx/slotvfx-plugins/main/dist"
mkdir -p "$root/dist"
rm -f "$root"/dist/*.zip
entries=""
for pair in slotvfx:slotvfx-mac slotvfx-windows:slotvfx-windows; do
  name=${pair%%:*}
  dir="$root/plugins/${pair#*:}"
  version=$(sed -n 's/^ *"version": *"\([^"]*\)".*/\1/p' "$dir/.claude-plugin/plugin.json" | head -n 1)
  description=$(sed -n 's/^ *"description": *"\([^"]*\)".*/\1/p' "$dir/.claude-plugin/plugin.json" | head -n 1)
  zipname="$name-plugin-$version.zip"
  (cd "$dir" && zip -qrX "$root/dist/$zipname" . -x '*.DS_Store')
  sha=$(shasum -a 256 "$root/dist/$zipname" | cut -d ' ' -f 1)
  # "version" lets the SlotVFX MCP server tell users when newer skills are out.
  entry=$(printf '    {\n      "name": "%s",\n      "version": "%s",\n      "source": {\n        "source": "archive",\n        "url": "%s/%s",\n        "sha256": "%s"\n      },\n      "description": "%s",\n      "category": "design"\n    }' "$name" "$version" "$base" "$zipname" "$sha" "$description")
  entries="${entries:+$entries,
}$entry"
  echo "Built dist/$zipname ($sha)"
done
cat > "$root/dist/marketplace.json" <<JSON
{
  "name": "slotvfx",
  "owner": {
    "name": "SlotVFX (Gamix Labs)",
    "url": "https://slotvfx.com"
  },
  "metadata": {
    "description": "SlotVFX plugins for Claude Code, installed without Git: create, animate, test and export animation and VFX for 2D games in SlotVFX Desktop."
  },
  "plugins": [
$entries
  ]
}
JSON
