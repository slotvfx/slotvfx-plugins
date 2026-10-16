# SlotVFX plugin for Claude Code

Let Claude build slot game VFX for you in **[SlotVFX](https://slotvfx.com)**. This plugin connects Claude Code to SlotVFX Desktop through its built-in MCP server and adds 20 expert skills. Claude can then create, animate, test and export win celebrations, transitions, particles, logo reveals and Spine VFX right in the editor, ready for game developers to integrate.

```
/plugin marketplace add slotvfx/slotvfx-plugins
/plugin install slotvfx@slotvfx
```

**What you get**
- **The SlotVFX MCP connection:** Claude works on the project open in SlotVFX Desktop (137 editor tools) through the app's local, token-protected AI bridge.
- **20 skills:** particle recipes, win celebrations and hold loops, travel effects, slashes, per-cell effects, logo reveals, spin showcases, Spine VFX, motion craft (eases, springs, staggers), state machines and scenarios, performance, build verification and dev handoff reports.

Website: [slotvfx.com](https://slotvfx.com) · Docs: [slotvfx.com/docs](https://slotvfx.com/docs/) · Skills source: [slotvfx/slotvfx-skills](https://github.com/slotvfx/slotvfx-skills)

## Requirements
- SlotVFX Desktop 0.9.64 or newer, running, with **Help → AI / MCP Bridge** turned on. The plugin starts the MCP server that ships inside the app, so the tools always match your app version.
- Node.js 22 or newer on your PATH (`node -v`).
- Tested on macOS. Windows is not tested yet; reports are welcome at https://slotvfx.com.
- Claude Code (terminal, IDE or the Claude desktop app's Code tab). The MCP runs on your own computer, so it does **not** work in claude.ai chat in the browser.

## Install
Run the two commands above inside Claude Code, then restart Claude Code and ask: "Use SlotVFX to check app state and bridge compatibility. Don't edit anything yet."

From the terminal: `claude plugin marketplace add slotvfx/slotvfx-plugins` then `claude plugin install slotvfx@slotvfx`.

## Updating
`/plugin marketplace update slotvfx`, or turn on auto-update for this marketplace in `/plugin` → Marketplaces.

## If SlotVFX isn't found
The plugin looks for the app in `/Applications` and `~/Applications` on macOS, and in the default install folders on Windows. If you installed SlotVFX somewhere else, set `SLOTVFX_MCP_SERVER` to the full path of `slotfxMcpServer.mjs` inside the app (on macOS: `SlotVFX.app/Contents/Resources/mcp/adapter/server/`).

If you already use the SlotVFX desktop extension in the Claude desktop app, you don't need it in Claude Code; avoid running both in the same client, or you'll see every tool twice.

## Licence
The skills and plugin files are MIT (see LICENSE and plugins/slotvfx/NOTICE.md). SlotVFX Desktop itself, its MCP server and its licence are separate and are not included here.
