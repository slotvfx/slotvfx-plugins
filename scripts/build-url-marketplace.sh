#!/bin/sh
# Builds dist/: a zip of each plugin and a marketplace.json that points at them,
# so Claude Code can install the plugins over HTTPS without Git.
# Run scripts/sync-windows-plugin.sh first, then this, and commit dist/ with the change.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
base="https://raw.githubusercontent.com/slotvfx/slotvfx-plugins/main/dist"
mkdir -p "$root/dist"
rm -f "$root"/dist/*.zip
entries=""
for name in slotvfx slotvfx-windows; do
  dir="$root/plugins/$name"
  version=$(sed -n 's/^ *"version": *"\([^"]*\)".*/\1/p' "$dir/.claude-plugin/plugin.json" | head -n 1)
  description=$(sed -n 's/^ *"description": *"\([^"]*\)".*/\1/p' "$dir/.claude-plugin/plugin.json" | head -n 1)
  zipname="$name-plugin-$version.zip"
  (cd "$dir" && zip -qrX "$root/dist/$zipname" . -x '*.DS_Store')
  sha=$(shasum -a 256 "$root/dist/$zipname" | cut -d ' ' -f 1)
  entry=$(printf '    {\n      "name": "%s",\n      "source": {\n        "source": "archive",\n        "url": "%s/%s",\n        "sha256": "%s"\n      },\n      "description": "%s",\n      "category": "design"\n    }' "$name" "$base" "$zipname" "$sha" "$description")
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
    "description": "SlotVFX plugins for Claude Code, installed without Git: create, animate, test and export slot game VFX in SlotVFX Desktop."
  },
  "plugins": [
$entries
  ]
}
JSON
