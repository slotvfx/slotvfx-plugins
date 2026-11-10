# SlotVFX skills for Claude Code

Let Claude build animation and VFX for your 2D game in **[SlotVFX](https://slotvfx.com)**. This plugin adds 20 expert skills, so Claude can create, animate, test and export win moments, transitions, particles, logo reveals and Spine VFX right in the SlotVFX editor, ready for game developers to integrate.

This is the **skills-only** version, as listed in Anthropic's plugin directory. It doesn't include the SlotVFX connection (the MCP server that ships inside SlotVFX Desktop), so you add that once. The skills explain how when Claude can't find the SlotVFX tools.

Website: [slotvfx.com](https://slotvfx.com) · Docs: [slotvfx.com/docs](https://slotvfx.com/docs/) · Source: [slotvfx/slotvfx-plugins](https://github.com/slotvfx/slotvfx-plugins)

## What you get
- **20 skills:** particle recipes, win celebrations and hold loops, travel effects, slashes, per-cell effects, logo reveals, spin showcases, Spine VFX, motion craft (eases, springs, staggers), state machines and scenarios, performance, build verification and dev handoff reports.
- **Skills are text only:** Markdown guides. A few skills mention small Python helpers (for example `motion_keys.py`); those come with the full plugin on GitHub and are left out here, and the skills say how to do the same steps without them. The plugin starts no programs and connects to nothing by itself.

## Connect SlotVFX
You need SlotVFX Desktop 0.9.64 or newer, open, with **Connect AI** turned on. Then add the SlotVFX connection to Claude Code once. Claude offers to do this for you the first time it can't find the SlotVFX tools; the one-line commands for macOS and Windows are in [Connect SlotVFX](skills/slotvfx-mcp-authoring/references/connect-slotvfx.md).

Restart Claude Code, then ask: "Use SlotVFX to check app state and bridge compatibility. Don't edit anything yet."

The SlotVFX connection runs on your own computer, so it works in Claude Code (terminal, IDE or the Claude desktop app's Code tab), not in claude.ai chat in the browser.

## Licence
The skills and plugin files are MIT (see LICENSE and NOTICE.md). SlotVFX Desktop itself, its MCP server and its licence are separate and are not included here.
