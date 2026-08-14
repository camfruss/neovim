return {
  -- Ships inside Xcode on macOS and with the Swift toolchain on Linux, so resolve
  -- it from PATH rather than hard-coding either location. lua/config/lsp.lua only
  -- enables this server where the executable exists.
  cmd = { "sourcekit-lsp" },
  -- Swift only: clangd already owns c/cpp/objc/objcpp here, and two servers
  -- answering the same buffer means duplicate completions and diagnostics.
  filetypes = { "swift" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    -- buildServer.json (from xcode-build-server) gives sourcekit the compile
    -- database for an Xcode project; Package.swift covers SwiftPM. Without one of
    -- these, sourcekit works per-file with no cross-module knowledge.
    local marker = vim.fs.find(function(name, _)
      return name == "buildServer.json"
        or name == "Package.swift"
        or name:match("%.xcodeproj$") ~= nil
        or name:match("%.xcworkspace$") ~= nil
    end, { path = vim.fs.dirname(fname), upward = true, limit = 1 })[1]

    on_dir(marker and vim.fs.dirname(marker) or vim.fs.root(fname, ".git"))
  end,
}
