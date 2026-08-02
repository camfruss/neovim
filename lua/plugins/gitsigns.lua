-- Persistent across buffers: are we currently diffing against the branch fork
-- point (true) or the index / uncommitted changes (false, the default)?
local branch_base = false

-- Toggle the gitsigns diff base between:
--   * the index (default) -> signs show the current uncommitted changes, and
--   * the merge-base of HEAD and the trunk -> signs show every change made on
--     this feature branch since it forked off main/master.
-- Using the merge-base (not the trunk tip) means the diff stays anchored to
-- where the branch diverged, even after main advances. change_base(base, true)
-- applies globally to every attached buffer.
local function toggle_diff_base()
	local gs = require("gitsigns")
	if branch_base then
		gs.change_base(nil, true)
		branch_base = false
		vim.notify("gitsigns: uncommitted changes (index)")
		return
	end
	local base
	for _, ref in ipairs({ "origin/HEAD", "origin/main", "origin/master", "main", "master" }) do
		local mb = vim.trim(vim.fn.system({ "git", "merge-base", "HEAD", ref }))
		if vim.v.shell_error == 0 and mb ~= "" then
			base = mb
			break
		end
	end
	if not base then
		vim.notify("gitsigns: no trunk found for merge-base", vim.log.levels.WARN)
		return
	end
	gs.change_base(base, true)
	branch_base = true
	vim.notify("gitsigns: whole branch (from " .. base:sub(1, 8) .. ")")
end

return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "±" },
			delete = { text = "-" },
			topdelete = { text = "-" },
			changedelete = { text = "±" },
			untracked = { text = "┆" },
		},
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 300,
			virt_text_pos = "eol",
		},
		on_attach = function(bufnr)
			local gs = require("gitsigns")

			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			-- Navigation between hunks. nav_hunk is async, so center from its
			-- completion callback rather than right after the call, which would
			-- run zz before the cursor has actually moved.
			local function nav(direction)
				return function()
					gs.nav_hunk(direction, {}, function(err)
						if not err then
							vim.cmd("normal! zz")
						end
					end)
				end
			end

			map("n", "]h", nav("next"), "Next git hunk (centered)")
			map("n", "[h", nav("prev"), "Previous git hunk (centered)")

			-- Hunk actions
			map({ "n", "v" }, "<leader>hs", gs.stage_hunk, "Stage hunk")
			map({ "n", "v" }, "<leader>hr", gs.reset_hunk, "Reset hunk")
			map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
			map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")

			-- Blame
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end, "Blame line (popup)")
			map("n", "<leader>hB", gs.blame, "Blame whole file")
			map("n", "<leader>ht", gs.toggle_current_line_blame, "Toggle inline blame")

			-- Diff base: flip signs between uncommitted changes and whole branch
			map("n", "<leader>hD", toggle_diff_base, "Toggle diff base (branch/index)")
		end,
	},
}
