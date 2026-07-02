return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  -- disable ruff's hover in favor of pyright's; keep ruff for
  -- lint/quick-fix/organize-imports only
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
