# A tiny MCP server used only when SlotVFX can't start. It tells Claude what is
# missing, so Claude can explain the fix to the user in chat.
param([string]$Message)
$stdin = [Console]::In
$stdout = [Console]::Out
while ($null -ne ($line = $stdin.ReadLine())) {
  try { $request = $line | ConvertFrom-Json } catch { continue }
  if ($null -eq $request.id) { continue }
  $response = @{ jsonrpc = '2.0'; id = $request.id }
  if ($request.method -eq 'initialize') {
    $version = if ($request.params.protocolVersion) { $request.params.protocolVersion } else { '2025-06-18' }
    $response.result = @{ protocolVersion = $version; capabilities = @{ tools = @{} }; serverInfo = @{ name = 'slotvfx-setup'; version = '1.0.0' }; instructions = $Message }
  } elseif ($request.method -eq 'tools/list') {
    $tool = @{ name = 'slotfx_setup_status'; description = "SlotVFX is not connected yet. Call this and tell the user exactly what it says. $Message"; inputSchema = @{ type = 'object'; properties = @{} } }
    $response.result = @{ tools = @($tool) }
  } elseif ($request.method -eq 'tools/call') {
    $response.result = @{ content = @(@{ type = 'text'; text = $Message }); isError = $true }
  } elseif ($request.method -eq 'ping') {
    $response.result = @{}
  } else {
    $response.error = @{ code = -32601; message = 'SlotVFX is not connected yet.' }
  }
  $stdout.WriteLine(($response | ConvertTo-Json -Depth 10 -Compress))
  $stdout.Flush()
}
