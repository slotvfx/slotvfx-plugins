# SlotVFX plugins for Claude

Create, animate, check and hand off slot game effects in **SlotVFX Desktop** by asking Claude. This marketplace has one plugin, `slotvfx`:

- **20 skills:** particles, win celebrations, logo reveals, Spine VFX, motion craft, hold loops, travel effects, state machines, performance, build verification and dev reports.
- **The SlotVFX MCP connection:** Claude edits the open project in SlotVFX Desktop through the app's local AI bridge.

## Requirements
- SlotVFX Desktop 0.9.64 or newer, running, with **Help → AI / MCP Bridge** turned on. The plugin starts the MCP server that ships inside the app, so the tools always match your app version.
- Node.js 22 or newer on your PATH (`node -v`).
- Tested on macOS. Windows is not tested yet; reports are welcome at https://slotvfx.com.
- Claude Code (terminal, IDE or the Claude desktop app's Code tab). The MCP runs on your own computer, so it does **not** work in claude.ai chat in the browser.

## Install
```
/plugin marketplace add slotvfx/slotvfx-plugins
/plugin install slotvfx@slotvfx
```
Then restart Claude Code and ask: "Use SlotVFX to check app state and bridge compatibility. Don't edit anything yet."

From the terminal: `claude plugin marketplace add slotvfx/slotvfx-plugins` then `claude plugin install slotvfx@slotvfx`.

## Updating
`/plugin marketplace update slotvfx`, or turn on auto-update for this marketplace in `/plugin` → Marketplaces.

## If SlotVFX isn't found
The plugin looks for the app in `/Applications` and `~/Applications` on macOS, and in the default install folders on Windows. If you installed SlotVFX somewhere else, set `SLOTVFX_MCP_SERVER` to the full path of `slotfxMcpServer.mjs` inside the app (on macOS: `SlotVFX.app/Contents/Resources/mcp/adapter/server/`).

If you already use the SlotVFX desktop extension in the Claude desktop app, you don't need it in Claude Code; avoid running both in the same client, or you'll see every tool twice.

## Licence
The skills and plugin files are MIT (see LICENSE and plugins/slotvfx/NOTICE.md). SlotVFX Desktop itself, its MCP server and its licence are separate and are not included here.
