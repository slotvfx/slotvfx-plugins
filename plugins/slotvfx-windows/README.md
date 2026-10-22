# SlotVFX plugin for Claude Code on Windows

The Windows version of the [SlotVFX plugin](https://github.com/slotvfx/slotvfx-plugins): the SlotVFX Desktop MCP connection plus the same 20 skills. It starts the MCP server that ships inside SlotVFX Desktop with the Node.js built into the app, so you don't need Node.js, Git or Git Bash.

```
/plugin marketplace add https://raw.githubusercontent.com/slotvfx/slotvfx-plugins/main/dist/marketplace.json
/plugin install slotvfx-windows@slotvfx
```

Requirements: SlotVFX Desktop 0.9.64 or newer, running, with Connect AI turned on. The plugin finds SlotVFX in its default folders, wherever the installer put it, or from the running app. To choose the folder yourself, set `SLOTVFX_APP` to the folder that holds `SlotVFX.exe`. Restart Claude Code after installing.

If SlotVFX isn't found or is too old, the plugin still connects and Claude tells you what to install or update.

The skills and plugin files are MIT (see LICENSE and NOTICE.md). SlotVFX Desktop itself, its MCP server and its licence are separate and are not included here.
