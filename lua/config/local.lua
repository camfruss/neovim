-- Loads per-repo config from <config>/local/<repo>/init.lua when the cwd is
-- inside that repo. The file is plain Lua run at load time, so it can do
-- anything: vim.lsp.config(), options, keymaps.
--
-- Repo identity comes from the *canonical* root, so linked worktrees resolve to
-- the same name as the repo they were created from -- a worktree's .git is a
-- file reading "gitdir: /path/to/repo/.git/worktrees/<name>".
--
-- Untracked; see .gitignore.

local loaded = {}

--- Both roots for a directory: the worktree it is actually in, and the canonical
--- repository that worktree belongs to. They differ inside a linked worktree,
--- where .git is a file reading "gitdir: /path/to/repo/.git/worktrees/<name>".
--- The canonical root picks *which* local config to load; the worktree root is
--- what paths must be built from.
--- @param dir string
--- @return string|nil canonical
--- @return string|nil worktree
local function roots_for(dir)
	local git = vim.fs.find(".git", { path = dir, upward = true })[1]
	if not git then
		return nil
	end

	local worktree = vim.fs.dirname(git)

	local stat = vim.uv.fs_stat(git)
	if stat and stat.type == "directory" then
		return worktree, worktree
	end

	-- A linked worktree: read the gitdir pointer and walk back to the main repo.
	local fd = io.open(git, "r")
	if not fd then
		return nil
	end
	local contents = fd:read("*a")
	fd:close()

	local gitdir = contents:match("gitdir:%s*(.-)%s*$")
	if not gitdir then
		return nil
	end
	local main = gitdir:match("^(.*)/%.git/worktrees/")
	return main or vim.fs.dirname(gitdir), worktree
end

local function load_for(dir)
	local root, worktree = roots_for(dir)
	if not root then
		return
	end

	local name = vim.fs.basename(root)
	if loaded[name] then
		return
	end

	local path = vim.fs.joinpath(vim.fn.stdpath("config"), "local", name, "init.lua")
	if not vim.uv.fs_stat(path) then
		loaded[name] = true -- nothing to load; don't stat again
		return
	end

	loaded[name] = true
	-- The local file needs the worktree it was triggered from, not just the
	-- canonical repo: file paths, and anything generated from them, differ per
	-- worktree.
	vim.g.local_repo = { canonical = root, worktree = worktree or root, name = name }
	local ok, err = pcall(dofile, path)
	if not ok then
		vim.schedule(function()
			vim.notify("local config failed (" .. path .. "): " .. tostring(err), vim.log.levels.WARN)
		end)
	end
end

load_for(vim.uv.cwd())

local group = vim.api.nvim_create_augroup("LocalRepoConfig", { clear = true })

-- Picking up a repo entered later in the session, e.g. via <leader>swd or :cd.
vim.api.nvim_create_autocmd("DirChanged", {
	group = group,
	callback = function()
		load_for(vim.uv.cwd())
	end,
})

-- Also key on the buffer's own path, not just the cwd: opening a file in a repo
-- from somewhere else (`cd ~ && nvim path/to/repo/file.rs`, or a telescope jump)
-- is common, and the cwd alone would miss it -- leaving the repo's LSP tuning
-- unapplied. BufReadPre runs before FileType, so vim.lsp.config() from the local
-- file is still in place by the time a client attaches.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = group,
	callback = function(ev)
		local name = ev.file
		if name ~= "" and not name:match("^%a+://") then
			load_for(vim.fs.dirname(vim.fn.fnamemodify(name, ":p")))
		end
	end,
})
