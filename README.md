# SlotVFX plugin for Claude Code

Let Claude build slot game VFX for you in **[SlotVFX](https://slotvfx.com)**. This plugin connects Claude Code to SlotVFX Desktop through its built-in MCP server and adds 20 expert skills. Claude can then create, animate, test and export win celebrations, transitions, particles, logo reveals and Spine VFX right in the editor, ready for game developers to integrate.

```
/plugin marketplace add https://raw.githubusercontent.com/slotvfx/slotvfx-plugins/main/dist/marketplace.json
/plugin install slotvfx@slotvfx
```

No Git or Node.js needed. **On Windows**, install `slotvfx-windows@slotvfx` instead of `slotvfx@slotvfx`. Already have Git? `/plugin marketplace add slotvfx/slotvfx-plugins` works too.

**What you get**
- **The SlotVFX MCP connection:** Claude works on the project open in SlotVFX Desktop (137 editor tools) through the app's local, token-protected AI bridge.
- **20 skills:** particle recipes, win celebrations and hold loops, travel effects, slashes, per-cell effects, logo reveals, spin showcases, Spine VFX, motion craft (eases, springs, staggers), state machines and scenarios, performance, build verification and dev handoff reports.

Website: [slotvfx.com](https://slotvfx.com) · Docs: [slotvfx.com/docs](https://slotvfx.com/docs/) · Skills source: [slotvfx/slotvfx-skills](https://github.com/slotvfx/slotvfx-skills)

## What this plugin runs and connects to
- **One local process:** `scripts/start-slotvfx-mcp.sh` (readable source, about 20 lines) finds SlotVFX Desktop in its standard install folder and starts the MCP server that ships inside the app (`SlotVFX.app/Contents/Resources/mcp/adapter/server/slotfxMcpServer.mjs` on macOS) with the Node.js built into SlotVFX. Elsewhere it falls back to `scripts/start-slotvfx-mcp.mjs` with your Node.js. Nothing is downloaded or installed.
- **One local connection:** that server talks only to the SlotVFX Desktop app on the same computer, through the app's localhost, token-protected AI bridge. The plugin sends no data to any other server and reads no credentials.
- **Skills are text:** the 20 skills are Markdown guides plus small standard-library Python helpers (for example `motion_keys.py`) that Claude may run locally when a skill says so.
- Edits Claude makes in SlotVFX go through the app's own tools, are undoable, and are recorded in the SlotVFX AI audit log.

## Requirements
- SlotVFX Desktop 0.9.64 or newer, running, with **Help → AI / MCP Bridge** turned on. The plugin starts the MCP server that ships inside the app, so the tools always match your app version.
- Nothing else on macOS or Windows: the plugin uses the Node.js built into SlotVFX Desktop (on Windows, use the `slotvfx-windows` plugin).
- Linux: Node.js 22 or newer on your PATH (`node -v`).
- Git only if you add the marketplace as `slotvfx/slotvfx-plugins`. The HTTPS link above needs no Git (Claude Code 2.1.224 or newer).
- Tested on macOS. Windows is not tested yet; reports are welcome at https://slotvfx.com.
- Claude Code (terminal, IDE or the Claude desktop app's Code tab). The MCP runs on your own computer, so it does **not** work in claude.ai chat in the browser.

## Install
Run the two commands above inside Claude Code, then restart Claude Code and ask: "Use SlotVFX to check app state and bridge compatibility. Don't edit anything yet."

From the terminal: `claude plugin marketplace add https://raw.githubusercontent.com/slotvfx/slotvfx-plugins/main/dist/marketplace.json` then `claude plugin install slotvfx@slotvfx`.

## Updating
`/plugin marketplace update slotvfx`, or turn on auto-update for this marketplace in `/plugin` → Marketplaces.

## If SlotVFX isn't found
If SlotVFX Desktop is missing or too old, the plugin still connects and Claude tells you what to install or update.

The plugin looks for the app in `/Applications` and `~/Applications` on macOS, and in the default install folders on Windows. If you installed SlotVFX somewhere else, move it to one of those standard locations, or add the app's server to Claude Code yourself with `claude mcp add` (on macOS it is `SlotVFX.app/Contents/Resources/mcp/adapter/server/slotfxMcpServer.mjs`, run with `node`).

If you already use the SlotVFX desktop extension in the Claude desktop app, you don't need it in Claude Code; avoid running both in the same client, or you'll see every tool twice.

## Licence
The skills and plugin files are MIT (see LICENSE and plugins/slotvfx/NOTICE.md). SlotVFX Desktop itself, its MCP server and its licence are separate and are not included here.
