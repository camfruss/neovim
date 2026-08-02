-- Pre-PR review helpers. Two ways to read a branch: the whole thing at once
-- (the way a reviewer sees it), or one commit at a time to check each is
-- self-contained.

-- Position in the branch's commit list, oldest first -- reviewing a series reads
-- forwards, unlike a git log. 0 means "not started"; <leader>dn begins at the
-- oldest commit.
local index = 0
local commits = {}

-- The trunk this branch forked from. Same fallback chain as the gitsigns diff
-- base toggle in gitsigns.lua.
local function merge_base()
	for _, ref in ipairs({ "origin/HEAD", "origin/main", "origin/master", "main", "master" }) do
		local base = vim.trim(vim.fn.system({ "git", "merge-base", "HEAD", ref }))
		if vim.v.shell_error == 0 and base ~= "" then
			return base
		end
	end
	vim.notify("diffview: no trunk found to compare against", vim.log.levels.WARN)
end

-- Re-read on every step: one cheap git call keeps the list correct across
-- commits, amends and rebases instead of going stale.
local function load_commits()
	local base = merge_base()
	if not base then
		return false
	end
	commits = vim.fn.systemlist({ "git", "rev-list", "--reverse", base .. "..HEAD" })
	if vim.v.shell_error ~= 0 or #commits == 0 then
		commits = {}
		vim.notify("diffview: no commits on this branch yet", vim.log.levels.WARN)
		return false
	end
	return true
end

local function step(delta)
	if not load_commits() then
		return
	end
	index = math.min(math.max(index + delta, 1), #commits)
	local sha = commits[index]
	-- `^!` is "just this commit" and, unlike sha~1..sha, works on a root commit
	-- that has no parent.
	vim.cmd("DiffviewOpen " .. sha .. "^!")
	vim.notify(
		string.format(
			"commit %d/%d  %s",
			index,
			#commits,
			vim.trim(vim.fn.system({ "git", "log", "-1", "--format=%h %s", sha }))
		)
	)
end

local function open_range(range)
	local base = merge_base()
	if base then
		vim.cmd("DiffviewOpen " .. (range and base .. "..HEAD" or base))
	end
end

return {
	"sindrets/diffview.nvim",
	opts = {
		-- Derives extra highlight groups so a deletion inside an added block (and
		-- vice versa) is distinguishable, instead of the whole line reading as one
		-- flat colour.
		enhanced_diff_hl = true,
		view = {
			-- Side-by-side split: old left, new right. This is also diffview's own
			-- default; pinned so it can't drift. The alternative is diff2_vertical
			-- (old above, new below) -- better on narrow windows -- or diff1_plain
			-- for a single unified pane. g<C-x> cycles at runtime.
			default = { layout = "diff2_horizontal" },
			file_history = { layout = "diff2_horizontal" },
		},
		hooks = {
			diff_buf_read = function()
				-- Absolute line numbers in both panes: relativenumber counts from
				-- the cursor, so the two sides disagree and you can't line changes
				-- up the way GitHub's split view lets you.
				vim.opt_local.relativenumber = false
				vim.opt_local.number = true
				vim.opt_local.cursorline = true
			end,
		},
	},
	keys = {
		{
			"<leader>dt",
			function()
				-- Toggle rather than a separate close key: DiffviewOpen on an
				-- already-open view does nothing useful.
				if require("diffview.lib").get_current_view() then
					vim.cmd("DiffviewClose")
				else
					vim.cmd("DiffviewOpen")
				end
			end,
			desc = "Diff toggle (working tree)",
		},
		{
			"<leader>da",
			function()
				open_range(true)
			end,
			desc = "Diff from start (merge-base..HEAD, committed work)",
		},
		{
			"<leader>dw",
			function()
				open_range(false)
			end,
			desc = "Diff whole (merge-base..working tree, incl. uncommitted)",
		},
		{
			"<leader>dn",
			function()
				step(1)
			end,
			desc = "Diff next commit",
		},
		{
			"<leader>dp",
			function()
				step(-1)
			end,
			desc = "Diff previous commit",
		},
		{
			"<leader>dh",
			function()
				local base = merge_base()
				if base then
					vim.cmd("DiffviewFileHistory --range=" .. base .. "..HEAD")
				end
			end,
			desc = "Diff history (this branch's commits)",
		},
		{
			"<leader>df",
			"<cmd>DiffviewFileHistory --follow %<cr>",
			desc = "Diff history of current file",
		},
	},
}
