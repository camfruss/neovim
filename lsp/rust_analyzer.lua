-- What each client has already been announced for, keyed by client id.
--
-- rust-analyzer emits serverStatus on every state change, repeating whatever is
-- currently wrong each time -- so an unfixable condition (see the build-script
-- note below) would otherwise reprint on every tick. Notifications that repeat
-- get scrolled past; ones that repeat *while you are typing* cost keystrokes.
local announced = {}

--- Notify at most once per client per distinct message.
--- Single line, always: vim.notify writes to the cmdline, and anything taller
--- than one row raises the hit-enter prompt, which swallows the next keystroke.
--- Detail belongs in :LspLog, which is where the full text already goes.
local function notify_once(client_id, key, message, level)
  local seen = announced[client_id]
  if not seen then
    seen = {}
    announced[client_id] = seen
  end
  if seen[key] then
    return
  end
  seen[key] = true
  vim.notify(message:gsub("%s+", " "), level)
end

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
  -- Per-repo tuning lives in <config>/local/<repo>/init.lua, applied via
  -- vim.lsp.config() when the cwd is inside that repo. See lua/config/local.lua.
  -- Nothing here reads anything from the repos themselves.
  --
  handlers = {
    -- showMessage is left alone deliberately: when cargo drives the build, a
    -- failed build script or proc-macro server is a real problem and hiding it
    -- turns into hours of debugging why nothing resolves.
    --
    -- logMessage is the verbose per-request stream, which is only ever noise
    -- interactively; it still reaches :LspLog.
    ["window/logMessage"] = function() end,

    -- The one failure mode worth interrupting for. When `cargo metadata` fails --
    -- an uninitialised submodule behind a path dependency is the usual cause --
    -- rust-analyzer does not stop. It silently retries with `--no-deps` and serves
    -- a crate graph containing workspace members and nothing else: every external
    -- type is unresolved, so go-to-definition, hover and completion die on anything
    -- from a dependency while first-party jumps keep working. That reads as a flaky
    -- editor rather than a broken workspace, and it stays wrong until the server is
    -- reloaded even after the underlying cause is fixed.
    --
    -- serverStatusNotification (asked for in capabilities below) is what surfaces
    -- it: health is "warning" or "error" with the cargo output as the message.
    ["experimental/serverStatus"] = function(_, result, ctx)
      if not result then
        return
      end
      -- Say once when the crate graph is actually queryable. Loading this repo's
      -- cargo workspace runs into minutes (24s in :RustProjectFast mode), and
      -- until it finishes go-to-definition returns nothing -- indistinguishable
      -- from the broken-graph case above unless the server says which it is.
      if result.quiescent then
        notify_once(ctx.client_id, "ready", "rust-analyzer: workspace ready")
      end
      if result.health == "ok" then
        return
      end
      -- :RustProjectFast points linkedProjects at a generated rust-project.json,
      -- which deliberately bypasses discovery -- so rust-analyzer's complaint that
      -- it could not discover a workspace is expected there, and fires on every
      -- start with a fully working graph behind it. Warning about it would train
      -- the eye to dismiss exactly the notification that matters.
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      local linked = client and vim.tbl_get(client.config or {}, "init_options", "linkedProjects")
      if linked and (result.message or ""):match("Failed to discover workspace") then
        return
      end
      local level = result.health == "error" and vim.log.levels.ERROR or vim.log.levels.WARN
      -- Cargo errors arrive as a wall of text with a backtrace appended; the
      -- first line carries the cause and the rest is already in :LspLog.
      local summary = vim.split(vim.trim(result.message or "(no detail)"), "\n")[1]
      notify_once(
        ctx.client_id,
        result.health .. ":" .. summary,
        "rust-analyzer " .. result.health .. ": " .. summary .. " (:LspLog, :RustReload)",
        level
      )
    end,
  },
  -- :RustReload re-runs project discovery in place. Needed after anything the crate
  -- graph is built from changes outside the editor -- a submodule being checked out,
  -- a Cargo.toml edited on another branch, a toolchain switch -- since rust-analyzer
  -- only reloads on manifest edits it sees itself, and never retries a failed fetch.
  -- Cheaper and less disruptive than restarting the client, which re-indexes.
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "RustReload", function()
      client:request("rust-analyzer/reloadWorkspace", nil, function(err)
        if err then
          vim.notify("reloadWorkspace failed: " .. tostring(err.message), vim.log.levels.ERROR)
          return
        end
        vim.notify("rust-analyzer: workspace reloaded")
      end)
      -- Proc-macro dylibs are built from the graph that just changed; leaving the
      -- old ones loaded leaves derive-generated items resolving against stale code.
      client:request("rust-analyzer/rebuildProcMacros", nil, function() end)
    end, { desc = "Reload the rust-analyzer workspace (re-run cargo metadata)" })
  end,
  -- Let rust-analyzer watch files itself: Neovim's client-side FSEvents watcher
  -- over huge monorepos makes quitting block for 10-20s on watcher teardown
  capabilities = {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = false },
    },
    -- Opt in to experimental/serverStatus; without it a failed workspace fetch is
    -- reported nowhere except :LspLog. See the handler above.
    experimental = {
      serverStatusNotification = true,
    },
  },
  settings = {
    ["rust-analyzer"] = {
      -- allFeatures expands the feature graph across every crate, which is the
      -- biggest memory amplifier on a large workspace. Off by default; name the
      -- features you actually work in from a repo's local config, e.g.
      --   cargo = { features = { "some_feature", "another_feature" } }
      -- Code behind features that aren't enabled reads as inactive: dimmed, with
      -- no completion, hover or diagnostics.
      cargo = { allFeatures = false },
      checkOnSave = true,
      check = { command = "clippy", workspace = false },
      inlayHints = { lifetimeElisionHints = { enable = true } },
    },
  },
}
