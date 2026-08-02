return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  -- Anchor at the Cargo *workspace* root, not the nearest member crate. In a big
  -- workspace every crate has its own Cargo.toml, so keying on Cargo.toml would
  -- spawn a fresh rust-analyzer (re-indexing everything) each time you open a
  -- file in a different crate. Cargo.lock lives only at the workspace root, so
  -- all members share one client. Fall back to nearest Cargo.toml, then .git.
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(
      vim.fs.root(fname, "Cargo.lock")
        or vim.fs.root(fname, "Cargo.toml")
        or vim.fs.root(fname, ".git")
    )
  end,
  -- Per-repo overrides: if the repo has scripts/dev/<user>/nvim/rust-analyzer.lua
  -- (a function returning a settings table), deep-merge it over the defaults
  -- below. Keeps repo-specific tuning (target dir, features, linked projects)
  -- version-controlled inside the repo instead of hard-coded here. Only ever
  -- runs the current user's own personal file.
  before_init = function(_, config)
    local root = config.root_dir or vim.fn.getcwd()
    local repo = vim.fs.root(root, ".git") or root
    local user = os.getenv("USER") or ""
    local override = repo .. "/scripts/dev/" .. user .. "/nvim/rust-analyzer.lua"
    if user == "" or not vim.uv.fs_stat(override) then
      return
    end
    local ok, mod = pcall(dofile, override)
    if ok and type(mod) == "function" then
      config.settings = config.settings or {}
      config.settings["rust-analyzer"] = vim.tbl_deep_extend(
        "force",
        config.settings["rust-analyzer"] or {},
        mod(repo) or {}
      )
    else
      vim.schedule(function()
        vim.notify("rust-analyzer per-repo override failed: " .. tostring(mod), vim.log.levels.WARN)
      end)
    end
  end,
  -- Let rust-analyzer watch files itself: Neovim's client-side FSEvents watcher
  -- over huge monorepos makes quitting block for 10-20s on watcher teardown
  capabilities = {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = false },
    },
  },
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = true,
      check = { command = "clippy", workspace = false },
      inlayHints = { lifetimeElisionHints = { enable = true } },
    },
  },
}
