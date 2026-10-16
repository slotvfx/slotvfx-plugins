#!/usr/bin/env node
// Starts the MCP server that ships inside SlotVFX Desktop, so this plugin
// carries no copy of it and always matches the installed app version.
// Override the location with SLOTVFX_MCP_SERVER=/path/to/slotfxMcpServer.mjs.
import { existsSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';
import { spawn } from 'node:child_process';

const rel = ['mcp', 'adapter', 'server', 'slotfxMcpServer.mjs'];
const env = process.env;
const candidates = [
  env.SLOTVFX_MCP_SERVER,
  // macOS
  join('/Applications', 'SlotVFX.app', 'Contents', 'Resources', ...rel),
  join(homedir(), 'Applications', 'SlotVFX.app', 'Contents', 'Resources', ...rel),
  // Windows (default Electron install locations; not yet tested)
  env.LOCALAPPDATA && join(env.LOCALAPPDATA, 'Programs', 'SlotVFX', 'resources', ...rel),
  env.ProgramFiles && join(env.ProgramFiles, 'SlotVFX', 'resources', ...rel),
].filter(Boolean);

const server = candidates.find(p => existsSync(p));
if (!server) {
  process.stderr.write(
    'SlotVFX Desktop was not found. Install SlotVFX Desktop or set ' +
    'SLOTVFX_MCP_SERVER to its slotfxMcpServer.mjs. Looked in:\n  ' + candidates.join('\n  ') + '\n');
  process.exit(1);
}

const child = spawn(process.execPath, [server, ...process.argv.slice(2)], { stdio: 'inherit' });
for (const sig of ['SIGINT', 'SIGTERM', 'SIGHUP']) process.on(sig, () => child.kill(sig));
child.on('exit', (code, signal) => process.exit(signal ? 1 : code ?? 0));
child.on('error', err => { process.stderr.write(`SlotVFX MCP could not start: ${err.message}\n`); process.exit(1); });
