// Starts the MCP server that ships inside SlotVFX Desktop with the Node.js
// built into the app, so the tools always match the installed app version and
// any Node.js on PATH (even an old one) is enough to run this file.
// If SlotVFX can't be started, it serves one tool that tells Claude what to fix.
'use strict';
const fs = require('fs');
const os = require('os');
const path = require('path');
const childProcess = require('child_process');
const readline = require('readline');

const NOT_FOUND = 'SlotVFX Desktop was not found. If it is not installed, download it from https://slotvfx.com and move it to the Applications folder. If it is in another folder, open SlotVFX first or set SLOTVFX_APP to the SlotVFX.app path. Turn on Connect AI, then restart Claude Code.';
const TOO_OLD = 'This SlotVFX Desktop is too old for AI. Update it to version 0.9.64 or newer from https://slotvfx.com, turn on Connect AI in SlotVFX, then restart Claude Code.';
const NOT_MAC = 'This plugin is for macOS. On Windows, install slotvfx-windows@slotvfx instead, then restart Claude Code.';

// SLOTVFX_APP (path to SlotVFX.app) wins; then the usual folders; then a
// running SlotVFX, so copies kept in another folder are found while open.
function appCandidates() {
  const apps = [];
  if (process.env.SLOTVFX_APP) apps.push(process.env.SLOTVFX_APP);
  apps.push('/Applications/SlotVFX.app', path.join(os.homedir(), 'Applications', 'SlotVFX.app'));
  try {
    const ps = childProcess.execFileSync('/bin/ps', ['-axo', 'comm='], { encoding: 'utf8' });
    const running = ps.split('\n').map(line => line.match(/^(.*\.app)\/Contents\/MacOS\/SlotVFX$/)).find(Boolean);
    if (running) apps.push(running[1]);
  } catch (err) {
    // No process list; the folders above are still checked.
  }
  return apps;
}

// Newer SlotVFX builds ship a launcher; older ones run the app itself as Node.js.
function findServerCommand() {
  if (process.platform !== 'darwin') return { help: NOT_MAC };
  for (const app of appCandidates()) {
    const res = path.join(app, 'Contents', 'Resources');
    if (!fs.existsSync(res)) continue;
    const server = path.join(res, 'mcp', 'adapter', 'server', 'slotfxMcpServer.mjs');
    if (!fs.existsSync(server)) return { help: TOO_OLD };
    const launcher = path.join(res, 'mcp', 'slotvfx-mcp');
    if (isExecutable(launcher)) return { command: launcher, args: [], env: process.env };
    const macos = path.join(app, 'Contents', 'MacOS');
    const exe = fs.readdirSync(macos).map(name => path.join(macos, name)).find(isExecutable);
    if (exe) return { command: exe, args: [server], env: Object.assign({}, process.env, { ELECTRON_RUN_AS_NODE: '1' }) };
  }
  return { help: NOT_FOUND };
}

function isExecutable(file) {
  try {
    fs.accessSync(file, fs.constants.X_OK);
    return fs.statSync(file).isFile();
  } catch (err) {
    return false;
  }
}

function startServer(found) {
  const child = childProcess.spawn(found.command, found.args.concat(process.argv.slice(2)), { stdio: 'inherit', env: found.env });
  for (const sig of ['SIGINT', 'SIGTERM', 'SIGHUP']) process.on(sig, () => child.kill(sig));
  child.on('exit', (code, signal) => process.exit(signal ? 1 : code === null ? 0 : code));
  child.on('error', err => serveSetupHelp(`SlotVFX MCP could not start (${err.message}). Restart SlotVFX, turn on Connect AI, then restart Claude Code.`));
}

// A tiny MCP server used only when SlotVFX can't start, so Claude can explain
// the fix to the user in chat.
function serveSetupHelp(message) {
  const reply = (id, body) => process.stdout.write(JSON.stringify(Object.assign({ jsonrpc: '2.0', id }, body)) + '\n');
  readline.createInterface({ input: process.stdin }).on('line', line => {
    let request;
    try { request = JSON.parse(line); } catch (err) { return; }
    if (!request || request.id === undefined || request.id === null) return;
    const params = request.params || {};
    if (request.method === 'initialize') {
      reply(request.id, { result: { protocolVersion: params.protocolVersion || '2025-06-18', capabilities: { tools: {} }, serverInfo: { name: 'slotvfx-setup', version: '1.0.0' }, instructions: message } });
    } else if (request.method === 'tools/list') {
      reply(request.id, { result: { tools: [{ name: 'slotfx_setup_status', description: `SlotVFX is not connected yet. Call this and tell the user exactly what it says. ${message}`, inputSchema: { type: 'object', properties: {} } }] } });
    } else if (request.method === 'tools/call') {
      reply(request.id, { result: { content: [{ type: 'text', text: message }], isError: true } });
    } else if (request.method === 'ping') {
      reply(request.id, { result: {} });
    } else {
      reply(request.id, { error: { code: -32601, message: 'SlotVFX is not connected yet.' } });
    }
  });
}

const found = findServerCommand();
if (found.help) serveSetupHelp(found.help);
else startServer(found);
